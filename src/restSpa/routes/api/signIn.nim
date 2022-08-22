import pkg/prologue

from restSpa/config import invalidPassword
from restSpa/db/models/user import passwordIs

import restSpa/routeUtils
import restSpa/db/models/user
import restSpa/db


proc r_signIn*(ctx: Context) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifLogin false:
    ctx.withParams(mergeGet = false):
      node.withUser(usr, {"username": "username"}):
        node.ifContains(all = ["password"]):
          let password = node{"password"}.getStr
          if usr.passwordIs password:
            usr.update(loginIp = ctx.request.ip)
            inDb: dbConn.update usr
            ctx.saveSession usr
            respSuc "Success"
          else:
            respErr invalidPassword
