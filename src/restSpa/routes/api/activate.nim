import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user
# import restSpa/db

from restSpa/auth/check import verifyAuthHash

proc r_activate*(ctx: Context) {.async.} =
  ## Activate the user with POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.withParams(mergeGet = false):
    node.ifContains(all = ["username", "hash"]):
      node.withUser(usr, {"username": "username"}):
        echo node{"hash"}.getStr
        let check = verifyAuthHash(usr, node{"hash"}.getStr)
        if check.success:
          if usr.rank == urGhost:
            usr.rank = urUser
            update usr
            respSucJson "Successfully activated user"
          else:
            respErrJson "User already activated"
        else:
          respErrJson check.error
