import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user
from restSpa/email/activateAccount import nil 
from restSpa/auth/gen import genActivationCode

proc r_resend*(ctx: Context) {.async.} =
  ## Resend emails using with GET
  ## 
  ## Needs kind path param
  ctx.forceHttpMethod HttpGet
  ctx.setContentJsonHeader
  ctx.ifLogin true:
    let kind = ctx.getPathParams "kind"
    case kind:
    of "activation":
      echo activateAccount.send(
        to = loggedUsr.email,
        username = loggedUsr.username,
        code = genActivationCode(
          loggedUsr.username,
          loggedUsr.email,
          loggedUsr.password,
          loggedUsr.salt
        )
      )
    else:
      respErr "Unknown email message"
      return

    respSuc "Successfully resent email"
