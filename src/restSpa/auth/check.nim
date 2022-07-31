import std/times
from std/strutils import parseInt

import restSpa/auth/gen
from restSpa/config import hashExpiringHours
from restSpa/db/models/user import User

proc verifyAuthHash*(
  usr: User;
  hash: string
): tuple[success: bool; error: string] =
  ## Check if the ident hash is valid
  result = (true, "")
  let (ident, epoch) = hash.unpackAuthHash
  if ident.len == 0 or epoch.len == 0:
    return (false, "Hash is broken")

  let newIdent = genIdentHash(usr.username, usr.password, usr.salt, epoch)
  echo genAuthHash(usr.username, usr.password, usr.salt, epoch)

  let diff = getTime() - epoch.parseInt.fromUnix()
  if diff.inHours > hashExpiringHours:
    result = (false, "Link expired")
  if newIdent != ident:
    result = (false, "Hash is broken")
