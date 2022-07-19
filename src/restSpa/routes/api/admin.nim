## Admin privilege actions
from std/strformat import fmt
from std/strutils import parseEnum
import pkg/prologue

import restSpa/db
import restSpa/db/models/user

import restSpa/routes/utils

const
  invalidUsername = "Invalid username or email"

proc r_setRank*(ctx: Context) {.async.} =
  ## Set user rank using POST
  ctx.setContentJsonHeader
  ctx.forceHttpMethod HttpPost
  ctx.minRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.ifContains(["username", "rank"], ifContainsDefaultErr):
        let
          username = node{"username"}.getStr
          rank = parseEnum[UserRank](node{"rank"}.getStr)
        var user = newUser()
        try:
          inDb: dbConn.select(
            user,
            "User.username = ? or User.email = ?",
            username
          )
        except: discard
        if user.username.len == 0:
          respErr invalidUsername
        else:
          if user.rank != rank:
            user.rank = rank
            try:
              inDb: dbConn.update user
              respSuc fmt"Successfully changed user '{username}' rank to '{rank}'"
            except DBError:
              respErr fmt"Cannot save user: {getCurrentExceptionMsg()}"
          else:
            respSuc fmt"The user '{username}' already have the rank '{rank}'"

proc r_getUser*(ctx: Context) {.async.} =
  ## Get all user data using POST
  ctx.setContentJsonHeader
  ctx.forceHttpMethod HttpPost
  ctx.minRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.ifContains(["username"], ifContainsDefaultErr):
        let username = node{"username"}.getStr
        var user = User.get username
        if user.username.len == 0:
          respErr invalidUsername
        else:
          respSucJson user.toJson

proc r_editUser*(ctx: Context) {.async.} =
  ## Edit user data using POST
  ctx.setContentJsonHeader
  ctx.forceHttpMethod HttpPost
  ctx.minRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.ifContains(["username"], ifContainsDefaultErr):
        let username = node{"username"}.getStr
        var user = User.get username
        if user.username.len == 0:
          respErr invalidUsername
        else:
          respSucJson user.toJson
