from std/strformat import fmt

import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user
import restSpa/db

proc r_delUser*(ctx: Context) {.async.} =
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifMinRank urAdmin:
    ctx.withParams(mergeGet = false):
      node.withUser:
        # echo usr[]
        inDb: dbConn.delete usr
        respSuc fmt"Successfully deleted '{usr.username}'"
