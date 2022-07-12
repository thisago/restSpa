from std/logging import nil

from std/json import parseJson, `{}=`, `%`, newJObject
from std/strtabs import keys

const
  autoFormParsing {.booldefine.} = true
  autoXmlParsing {.booldefine.} = false # not implemented

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

proc setContentJsonHeader*(ctx) =
  ## Set the response content-type to json
  ctx.response.setHeader "content-type", "application/json"

template withParams*(ctx; mergeGet = false; bodyCode: untyped) =
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
    of "application/xml":
      when autoXmlParsing:
        {.fatal: "XML parsing not implemented".}
    else: discard
  if mergeGet or reqMethod == HttpGet:
    for key, val in ctx.request.queryParams:
      node{key} = %val
  logging.debug "Auto parsed params: " & $node
  bodyCode

template respJson*(data: untyped; code: HttpCode) =
  ## Send a JSON to client
  resp($(%*data), code)

template respErr*(msg: string; code = Http400) =
  ## Send a error message in a JSON to client
  respJson({"message": msg, "error": true}, code)
template respSuc*(msg: string; code = Http200) =
  ## Send a success message in a JSON to client
  respJson({"message": msg, "error": false}, code)

from std/strutils import `%`

const ifContainsDefaultErr* = "No $1 provided"
template ifContains*(
  node;
  fields: openArray[string];
  errorMsg: string;
  body: untyped
) =
  ## Checks if the json have errors and specific fields, if not exists,
  ## send the error message.
  ## 
  ## If all is good, the body is executed
  if error:
    respJson({"message": "Invalid request", "error": true}, Http400)
  else:
    var haveAll = true
    for field in fields:
      if not node.hasKey field:
        respErr errorMsg
        haveAll = false
        break
    if haveAll:
      body

template forceHttpMethod*(ctx; httpMethod: HttpMethod) =
  ## Forces an specific HTTP method
  ## 
  ## Useful just in development
  doAssert ctx.request.reqMethod == httpMethod
