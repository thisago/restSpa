import pkg/prologue

import restSpa/utils

proc r_home*(ctx: Context) {.async.} =
  ## Homepage
  ctx.forceHttpMethod HttpGet
  if ctx.session.hasKey "username":
    resp "<h1>Logged in as " & ctx.session["username"] & "</h1>"
  else:
    resp "<h1>Not logged in</h1>"
