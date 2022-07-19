from std/json import `$`, `%*`, `%`, `{}=`, delete
# from std/times import `$`, fromUnix

import pkg/norm/[
  model,
  pragmas
]

from restSpa/utils import nowUnix
from restSpa/db/utils as dbUtils import getFromDb
import restSpa/db

type
  User* = ref object of Model
    ## User DB model
    username* {.unique.}: string
    email* {.unique.}: string
    password*: string

    internalRank*: int

    registerDate*, lastLoginDate*: int64
    registerIp*, lastLoginIp*: string

  UserRank* = enum
    urGhost = 0, ## Ghost is a user that cannot do anything, a unverified user
    urUser,  ## Default user privileges
    urAdmin  ## All privileges

func rank*(user: User): UserRank =
  ## User.rank getter
  UserRank(user.internalRank)
func `rank=`*(user: var User; rank: UserRank) =
  ## User.rank setter
  user.internalRank = int rank


proc newUser*(username, email, password: string; registerIp: string; rank = urGhost; registerDate = nowUnix()): User =
  ## Creates new `User`
  new result
  result.username = username
  result.email = email
  result.password = password # TODO: hash password
  result.rank = rank
  result.registerIp = registerIp
  result.registerDate = registerDate


proc newUser*: User =
  ## Creates new blank `User`
  newUser(
    username = "",
    email = "",
    password = "",
    registerIp = "",
    rank = urGhost,
    registerDate = 0
  )

proc toJson*(user: User): string =
  ## COnverts the user to a JSON notation
  var node = %*user
  node{"rank"} = %user.rank
  # node{"lastLoginDate"} = % $user.lastLoginDate.fromUnix
  # node{"registerDate"} = % $user.registerDate.fromUnix
  node.delete "internalRank"
  result = $node

## DB

proc get*(self: type User; username: string; fields: varargs[string] = []): User =
  ## Get the user in db which have the username or email same as `username`
  ##
  ## `fields` not working!!
  var queryFields = @["username", "email"]
  if fields.len > 0:
    raise newException(ValueError, "`fields` not working!")
    queryFields = @fields
  User.getFromDb(newUser(), queryFields, username)

proc update*(user: var User; loginIp = "") =
  ## Updates the user in db
  ##
  ## To set new login, use `loginIp`
  user.lastLoginIp = loginIp
  user.lastLoginDate = nowUnix()
  inDb: dbConn.update user
