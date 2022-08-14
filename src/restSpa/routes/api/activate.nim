import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user
# import restSpa/db

from restSpa/auth/gen import genActivationCode

proc r_activate*(ctx: Context) {.async.} =
  ## Activate the user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.withParams(mergeGet = false):
    node.ifContains(all = ["username", "code"]):
      node.withUser(usr, {"username": "username"}):
        let code = node{"code"}.getStr
        echo code
        echo genActivationCode(usr.username, usr.email, usr.password, usr.salt)

        if code == genActivationCode(usr.username, usr.email, usr.password, usr.salt):
          if usr.rank == urGhost:
            usr.rank = urUser
            update usr
            respSuc "Successfully activated user"
          else:
            respErr "User already activated"
        else:
          echo "err"
          respErr "Invalid activation code"
