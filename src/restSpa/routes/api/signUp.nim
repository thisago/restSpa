import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user
import restSpa/db

proc r_signUp*(ctx: Context) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifLogin false:
    ctx.withParams(mergeGet = false):
      node.ifContains(all = ["username", "email", "password"]):
        let
          username = node{"username"}.getStr
          email = node{"email"}.getStr
          password = node{"password"}.getStr
        try:
          let ip = ctx.request.ip
          var user = newUser(
            username = username,
            email = email,
            password = password,
            registerIp = ip,
            rank = urGhost
          )
          inDb: dbConn.insert user
          # ctx.session["username"] = username
          respSuc "Successfully created user"
        except DbError:
          case getCurrentExceptionMsg():
          of "UNIQUE constraint failed: User.username":
            respErr "Username already used"
          of "UNIQUE constraint failed: User.email":
            respErr "Email already used"
          else:
            echo getCurrentExceptionMsg()
