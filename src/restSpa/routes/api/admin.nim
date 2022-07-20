## Admin privilege actions
from std/strformat import fmt
from std/strutils import parseEnum
import pkg/prologue

# import restSpa/db
import restSpa/db/models/user
import restSpa/db

import restSpa/routes/utils

using
  ctx: Context

proc r_getUser*(ctx) {.async.} =
  ## Get all user data using POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifMinRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.withUser:
        respSucJson usr.toJson

proc r_editUser*(ctx) {.async.} =
  ## Edit user data using POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifMinRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.withUser:
        # convert `rank` to `internal_rank`, and block editing by internal values
        node.delInternals
        if node.hasKey "rank":
          try:
            let rank = parseEnum[UserRank](node{"rank"}.getStr)
            node.delete "rank"
            node{"internal_rank"} = % ord rank
          except ValueError:
            respErr "Invalid user rank"
            return

        # update the user by using JSON node
        if not usr[].updateFields(node, blacklist = cantEditUserFields):
          respErr "Please provide some value to edit"
        else:
          update usr # save
          respSucJson usr.toJson # send to client

proc r_delUser*(ctx) {.async.} =
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifMinRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.withUser:
        echo usr[]
        inDb: dbConn.delete usr
        respSuc fmt"Successfully deleted '{usr.username}'"
