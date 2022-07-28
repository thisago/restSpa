import pkg/prologue

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
          # echo usr.username
          if usr.password != password:
            respErr "Invalid password"
          else:
            usr.update(loginIp = ctx.request.ip)
            inDb: dbConn.update usr
            ctx.session["username"] = usr.username
            respSuc "Success"
