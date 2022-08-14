import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user

import restSpa/routes/api/activate as api_activ

proc r_activate*(ctx: Context) {.async.} =
  ## Verify account's email; needs `code` path param
  ctx.forceHttpMethod HttpGet
  let
    username = ctx.getPathParams("username", "")
    code = ctx.getPathParams("code", "")

  await api_activ.r_activate(ctx)
  resp ctx.response.body
  # if username.len > 0:
  #   var usr = User.get(username, ["username"])
  #   if code.len > 0:
  #     await api_activ.r_activate(ctx)
  #     echo ctx.response.body
  #   else:
  #     resp "no code provided", Http400 # frontend rendering
  # else:
  #   resp "no username provided", Http400 # frontend rendering
