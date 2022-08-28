from std/logging import nil

from std/json import parseJson, `{}=`, `%`, newJObject

from std/strtabs import keys

from restSpa/db/models/user import UserRank, User, get

import restSpa/config
export config
import restSpa/utils
export utils


const
  autoFormParsing {.boolDefine.} = true
  autoXmlParsing {.boolDefine.} = false # not implemented

when autoXmlParsing:
  from std/xmlparser import parseXml
  import std/xmltree

import pkg/prologue
export json

proc hasKey*(session: var Session; key: string): bool =
  ## Check if session have specific session
  try:
    discard session[key]
    return true
  except:
    return false

using
  ctx: Context
  node: JsonNode
  body: untyped

proc setContentJsonHeader*(ctx) =
  ## Set the response content-type to json
  ctx.response.setHeader "content-type", "application/json"

template withParams*(ctx; mergeGet = false; mergePath = false; bodyCode: untyped) =
  ## Run `body` if request has a JSON body
  ##
  ## If no JSON sent or/and the `content-type` is not
  ## JSON, it will response with `Http400` and close
  ## connection
  ##
  ## Use `mergeGet` to merge the get parameters into `node`
  ## The GET parameters override the POST
  let reqMethod = ctx.request.reqMethod
  var
    node {.inject.} = newJObject()
    error {.inject.} = true

  if reqMethod == HttpPost:
    case ctx.request.contentType:
    of "application/json":
      try:
        node = parseJson ctx.request.body
        error = false
      except JsonParsingError: discard
    of "application/x-www-form-urlencoded", "multipart/form-data":
      when autoFormParsing:
        for key, val in ctx.request.formParams.data:
          # echo val.params
          node{key} = %val.body
        error = false
    of "application/xml":
      when autoXmlParsing:
        {.fatal: "XML parsing not implemented".}
    else: discard
  if mergeGet or reqMethod == HttpGet:
    for key, val in ctx.request.queryParams:
      node{key} = %val
  if mergePath:
    for key, val in ctx.request.pathParams:
      node{key} = %val
  logging.debug "Auto parsed params: " & $node
  bodyCode

template withParams*(ctx; mergeGet = false; bodyCode: untyped) =
  ## Alias for `ctx.withParams(mergeGet, false): bodyCode`
  ctx.withParams(mergeGet, false): bodyCode
template withParams*(ctx; mergePath = false; bodyCode: untyped) =
  ## Alias for `ctx.withParams(mergeGet, false): bodyCode`
  ctx.withParams(false, mergePath): bodyCode
template withParams*(ctx; bodyCode: untyped) =
  ## Alias for `ctx.withParams(false, false): bodyCode`
  ctx.withParams(false, false): bodyCode

type
  ResponseJson* = object
    kind*: ResponseKind
    text*: string
    error*: bool
  ResponseKind* = enum
    RkMessage = "message",
    RkJson = "json"

func initResponseJson(
  kind: ResponseJson.kind;
  text: ResponseJson.text;
  error: ResponseJson.error
): ResponseJson =
  ResponseJson(kind: kind, text: text, error: error)

  
template respJson*(data: untyped; code: HttpCode) =
  ## Send a JSON to client
  resp($(%*data), code)

template respErr*(msg: string; code = Http400) =
  ## Send a error message in a JSON to client
  respJson(initResponseJson(RkMessage, msg, true), code)
template respSuc*(msg: string; code = Http200) =
  ## Send a success message in a JSON to client
  respJson(initResponseJson(RkMessage, msg, false), code)
template respErrJson*(json: string; code = Http400) =
  ## Send a success message in a JSON to client
  respJson(initResponseJson(RkJson, json, true), code)
template respSucJson*(json: string; code = Http200) =
  ## Send a error message in a JSON to client
  respJson(initResponseJson(RkJson, json, false), code)

from std/strutils import `%`, join

template ifNoError(body) =
  ## If `error` is false execute the body, else shows a error
  if not error: body
  else: respErr ifContainsInvalidReq

template ifContains*(
  node;
  all: openArray[string];
  body
) =
  ## Checks if the json have errors and `all` fields, if not exists,
  ## send the error message and not executes the body
  ifNoError:
    var havent = @all
    for field in all:
      if node.hasKey field:
        havent.delete havent.find field
    if havent.len > 0:
      respErr ifContainsAllErr % havent.join ", "
    else:
      body

template ifContains*(
  node;
  atLeast: openArray[string];
  body
) =
  ## Checks if the json have errors and `atLeast` fields, if not exists,
  ## send the error message and not executes the body
  ifNoError:
    if atLeast.len > 0:
      var have = false
      for field in atLeast:
        if node.hasKey field:
          have = true
      if have:
        body
      else:
        respErr ifContainsAtLeastErr % atLeast.join ", "


template forceHttpMethod*(ctx; httpMethod: HttpMethod) =
  ## Forces an specific HTTP method
  ##
  ## Useful just in development
  assert ctx.request.reqMethod == httpMethod

proc getSession*(ctx; name: string; default = ""): string =
  ## Tries to get a session value
  result = default
  try:
    result = ctx.session[sess_username]
  except: discard


template ifLogin*(ctx; loggedIn = true; loggedUsr: untyped; body) =
  ## Runs the code if user have login
  ##
  ## It will inject `loggedUsr` var that contains the current logged user
  var check = false
  let username = ctx.getSession sess_username
  var loggedUsr {.inject.}: User
  if username.len > 0:
    loggedUsr = User.get username
    if loggedUsr.username.len > 0:
      check = true

  if not loggedIn:
    check = not check
  if check:
    body
  else:
    if loggedIn:
      respErr needLogin
    else:
      respErr needLogoff

template ifLogin*(ctx; loggedIn = true; body) =
  ## Alias for `ifLogin` but without the injected user var name changing
  ## (default is `loggedUsr`)
  ctx.ifLogin(loggedIn, loggedUsr): body

template ifMinRank*(ctx; minRank: UserRank; body) =
  ## Runs the code if user have correct rank
  ctx.ifLogin true:
    if loggedUsr.rank >= minRank:
      body
    else:
      respErr rankNotMeet


when not defined(windows):
  from pkg/httpx import ip
proc ip*(req: Request): string =
  ## Get ip from request
  when not defined windows:
    result = req.nativeRequest.ip
  else:
    result = req.nativeRequest.hostname

from std/json import getStr, getBool, getInt, getFloat

proc updateFields*(
  obj: var object;
  node: JsonNode;
  blacklist: openArray[string] = [];
): bool =
  ## Updates the object by node items (if exists)
  result = false
  for key, value in obj.fieldPairs:
    if key notin blacklist:
      if node.hasKey key:
        let val = node{key}
        when value is bool: value = val.getBool
        elif value is SomeFloat: value = val.getFloat
        elif value is SomeInteger: value = val.getInt
        elif value is string: value = val.getStr
        if not result:
          result = true

type
  ReqDbField = tuple
    ## Request/DB fields relation
    req, db: string
  ReqDbFields = openArray[ReqDbField]

proc getUsing*(
  table: type;
  fields: ReqDbFields;
  node
): auto =
  ## Gets a `table` row using some of the provided `fields` in the `node`
  for (field, inDb) in fields:
    if node.hasKey field:
      let val = node{field}.getStr
      result = table.get(val, [inDb])
      break

template withUser*(
  node;
  usr: untyped;
  userIdentf: openArray[(string, string)] = userIdentifiers;
  body
) =
  ## Checks if contains user identificators and try to get it, then run the body
  var fields: seq[string]
  for (field, inDb) in userIdentf:
    fields.add field
  node.ifContains(atLeast = fields):
    var usr {.inject.} = User.getUsing(userIdentf, node)
    if usr.username.len > 0:
      body
    else:
      respErr userNotExists

template withUser*(node; body) =
  ## Runs `withUser` but with default `usr` variable
  node.withUser(usr, userIdentifiers): body

template saveSession*(ctx; usr: User) =
  ## Set the session
  ctx.session["username"] = usr.username
  
template cleanSession*(ctx) =
  ## Set the session
  ctx.session.del "username"
