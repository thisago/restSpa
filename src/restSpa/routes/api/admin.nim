## Admin privilege actions
from std/strformat import fmt
from std/strutils import parseEnum
import pkg/prologue

import restSpa/db
import restSpa/db/models/user

import restSpa/routes/utils

proc r_getUser*(ctx: Context) {.async.} =
  ## Get all user data using POST
  ctx.setContentJsonHeader
  ctx.forceHttpMethod HttpPost
  ctx.ifMinRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.withUser:
        respSucJson usr.toJson

proc r_editUser*(ctx: Context) {.async.} =
  ## Edit user data using POST
  ctx.setContentJsonHeader
  ctx.forceHttpMethod HttpPost
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

        usr[].updateFields( # update the user by using JSON node
          node,
          blacklist = [
            "registerDate",
            "lastLoginDate",
            "registerIp",
            "lastLoginIp"
          ]
        )
        update usr # save
        respSucJson usr.toJson # send to client
