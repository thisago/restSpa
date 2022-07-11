import pkg/prologue

import myinf/db
import myinf/db/models/user

import myinf/utils

proc r_signIn*(ctx: Context) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.session["username"] = "admin"

proc r_signUp*(ctx: Context) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.withJson:
    node.ifContains(["username", "email", "password"], "No $1 provided"):
      let
        username = node{"username"}.getStr
        email = node{"email"}.getStr
        password = node{"password"}.getStr
      try:
        var user = newUser(username, email, password)
        inDb: dbConn.insert user
        resp($(%*user))
      except DbError:
        case getCurrentExceptionMsg():
        of "UNIQUE constraint failed: User.username":
          respErr "Username already used"
        of "UNIQUE constraint failed: User.email":
          respErr "Email already used"
        else:
          quit getCurrentExceptionMsg()
      ctx.session["username"] = username
      # respJson({"message": "Success"}, Http200)
