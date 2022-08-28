from std/strutils import parseEnum

import pkg/prologue

import restSpa/routeUtils
import restSpa/db/models/user

proc r_editUser*(ctx: Context) {.async.} =
  ## Edit user data using POST
  ctx.forceHttpMethod HttpPost
  ctx.setContentJsonHeader
  ctx.ifMinRank urAdmin:
    ctx.withParams(get = false, path = false):
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
