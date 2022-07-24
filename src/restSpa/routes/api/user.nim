from std/strformat import fmt
import pkg/prologue

import restSpa/db
import restSpa/db/models/user

import restSpa/routes/utils

using
  ctx: Context

proc r_signIn*(ctx) {.async.} =
  ## Create new user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifLogin false:
    ctx.withParams(mergeGet = false):
      node.withUser(usr, {"username": "username"}):
        node.ifContains(all = ["password"]):
          let password = node{"password"}.getStr
          echo usr.username
          if usr.password != password:
            respErr "Invalid password"
          else:
            usr.update(loginIp = ctx.request.ip)
            inDb: dbConn.update usr
            ctx.session["username"] = usr.username
            respSuc "Success"


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

proc r_delUser*(ctx) {.async.} =
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifLogin true: # if logged
    inDb: dbConn.delete loggedUsr
    respSuc fmt"Successfully deleted '{loggedUsr.username}'"

proc r_logout*(ctx) {.async.} =
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifLogin true: # if logged
    ctx.session.del "username"
    respSuc fmt"Successfully logged out"

# proc r_activate*(ctx) {.async.} =
#   ctx.forceHttpMethod HttpPost
#   ctx.setContentJsonHeader
#   ctx.ifLogin true: # if logged
#     ctx.session.del "username"
#     respSuc fmt"Successfully logged out"
