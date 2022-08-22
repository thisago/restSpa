import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user
import restSpa/db
from restSpa/email/activateAccount import nil 
from restSpa/auth/gen import genActivationCode

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
          echo activateAccount.send(
            to = user.email,
            username = user.username,
            code = genActivationCode(
              user.username,
              user.email,
              user.password,
              user.salt
            )
          )
          ctx.saveSession user
          respSuc "Successfully created user"
        except DbError:
          case getCurrentExceptionMsg():
          of "UNIQUE constraint failed: User.username":
            respErr "Username already used"
          of "UNIQUE constraint failed: User.email":
            respErr "Email already used"
          else:
            echo getCurrentExceptionMsg()
