import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user
# import restSpa/db

from restSpa/db/models/user import passwordIs
from restSpa/auth/gen import genActivationCode
from restSpa/config import invalidPassword, successActivation, userAlreadyActivated,
                            invalidActivCode

proc r_activate*(ctx: Context) {.async.} =
  ## Activate the user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.withParams(get = false, path = false):
    node.ifContains(all = ["username", "code", "password"]):
      node.withUser(usr, {"username": "username"}):
        let
          code = node{"code"}.getStr
          password = node{"password"}.getStr

        if usr.passwordIs password:
          if code == genActivationCode(usr.username, usr.email, usr.password, usr.salt):
            if usr.rank == urGhost:
              usr.rank = urUser
              update usr
              respSuc successActivation
            else:
              respErr userAlreadyActivated
          else:
            respErr invalidActivCode
        else:
          respErr invalidPassword
