import pkg/prologue

import restSpa/db
import restSpa/db/models/user

import restSpa/utils

proc r_signIn*(ctx: Context) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.withJson:
    node.ifContains(["username", "password"], ifContainsDefaultErr):
      let
        username = node{"username"}.getStr
        password = node{"password"}.getStr
      var user = newUser()
      try:
        inDb: dbConn.select(
                user,
                "User.username = ? or User.email = ?",
                username
              )
      except: discard
      if user.username.len == 0:
        respErr "Invalid username or email"
      elif user.password != password:
        respErr "Invalid password"
      else:
        ctx.session["username"] = username
        respSuc "Success"
        


proc r_signUp*(ctx: Context) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.withJson:
    node.ifContains(["username", "email", "password"], ifContainsDefaultErr):
      let
        username = node{"username"}.getStr
        email = node{"email"}.getStr
        password = node{"password"}.getStr
      try:
        var user = newUser(username, email, password)
        inDb: dbConn.insert user
        ctx.session["username"] = username
        resp($(%*user))
      except DbError:
        case getCurrentExceptionMsg():
        of "UNIQUE constraint failed: User.username":
          respErr "Username already used"
        of "UNIQUE constraint failed: User.email":
          respErr "Email already used"
        else:
          echo getCurrentExceptionMsg()
