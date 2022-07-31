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
          respSucJson "success"
        else:
          respErrJson check.error
