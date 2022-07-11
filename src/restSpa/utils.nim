import pkg/prologue
import std/json
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

template withJson*(ctx; bodyCode: untyped) =
  ## Run `body` if request has a JSON body
  ##
  ## If no JSON sent or/and the `content-type` is not
  ## JSON, it will response with `Http400` and close
  ## connection
  var
    node {.inject.}: JsonNode
    error {.inject.} = true
  if ctx.request.contentType == "application/json":
    try:
      node = parseJson ctx.request.body
      error = false
    except JsonParsingError: discard
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
    respJson({"message": "Invalid JSON", "error": true}, Http400)
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
  doAssert ctx.request.reqMethod == httpMethod
