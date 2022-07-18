import pkg/prologue

import restSpa/db
import restSpa/db/models/user

import restSpa/routes/utils

proc r_signIn*(ctx: Context) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.withParams(mergeGet = false):
    node.ifContains(["username", "password"], ifContainsDefaultErr):
      let
        username = node{"username"}.getStr
        password = node{"password"}.getStr
      var user = User.get username
      if user.username.len == 0:
        respErr "Invalid username or email"
      elif user.password != password:
        respErr "Invalid password"
      else:
        user.update(loginIp = ctx.request.ip)
        inDb: dbConn.update user
        ctx.session["username"] = username
        respSuc "Success"


proc r_signUp*(ctx: Context) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.withParams(mergeGet = false):
    node.ifContains(["username", "email", "password"], ifContainsDefaultErr):
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
        respSucJson user.toJson
      except DbError:
        case getCurrentExceptionMsg():
        of "UNIQUE constraint failed: User.username":
          respErr "Username already used"
        of "UNIQUE constraint failed: User.email":
          respErr "Email already used"
        else:
          echo getCurrentExceptionMsg()
