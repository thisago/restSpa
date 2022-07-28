import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user

proc r_getUser*(ctx: Context) {.async.} =
  ## Get all user data using POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifMinRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.withUser:
        respSucJson usr.toJson
