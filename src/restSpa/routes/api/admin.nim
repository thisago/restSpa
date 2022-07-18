## Admin privilege actions
from std/strformat import fmt
from std/strutils import parseEnum
import pkg/prologue

import restSpa/db
import restSpa/db/models/user

import restSpa/utils

proc r_setRank*(ctx: Context) {.async.} =
  ## Set user rank using POST
  ctx.setContentJsonHeader
  ctx.forceHttpMethod HttpPost
  ctx.ifRank urAdmin:
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
          respErr "Invalid username or email"
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
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
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
        respErr "Invalid username or email"
      else:
        user.rank = rank
        try:
          inDb: dbConn.update user
          respSuc fmt"Successfully changed user {username} rank to "
        except DBError:
          respErr fmt"Cannot save user: {getCurrentExceptionMsg()}"