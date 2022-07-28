import pkg/prologue

import restSpa/routeUtils

proc r_logout*(ctx: Context) {.async.} =
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifLogin true: # if logged
    ctx.session.del "username"
    respSuc "Successfully logged out"
