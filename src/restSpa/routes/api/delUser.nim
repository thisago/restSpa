from std/strformat import fmt

import pkg/prologue

import restSpa/routeUtils
import restSpa/db


proc r_delUser*(ctx: Context) {.async.} =
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifLogin true: # if logged
    inDb: dbConn.delete loggedUsr
    respSuc fmt"Successfully deleted '{loggedUsr.username}'"
