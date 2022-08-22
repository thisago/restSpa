from std/json import `$`, `%*`, `%`, `{}=`, delete

import pkg/norm/[
  model,
  pragmas
]

from restSpa/utils import nowUnix, delInternals
from restSpa/db/utils as dbUtils import getFromDb
import restSpa/db
from restSpa/auth/gen import genSalt, hashPassword

type
  User* = ref object of Model
    ## User DB model
    username* {.unique.}: string
    email* {.unique.}: string
    password*, salt*: string

    internal_rank*: int

    registerDate*, lastLoginDate*: int64
    registerIp*, lastLoginIp*: string

  UserRank* = enum
    urDisabled = "disabled",  ## Disabled user is same as a non-existent user
    urGhost = "ghost",        ## Ghost is a user that cannot do anything, a unverified user
    urUser = "user",          ## Default user privileges
    urAdmin = "admin"         ## All privileges

const
  cantEditUserFields* = [ ## All fields that can't be edited by anyone
    "registerDate",       ## (even admin). Plus the internal fields that is
    "lastLoginDate",      ## automatically removed using `delInternals`
    "registerIp",
    "lastLoginIp",
  ]
  cantSeeUserFields* = [ ## All fields that can't be saw by anyone
    "password",
    "salt",
  ]

func rank*(user: User): UserRank =
  ## User.rank getter
  UserRank(user.internal_rank)
func `rank=`*(user: var User; rank: UserRank) =
  ## User.rank setter
  user.internal_rank = ord rank


proc newUser*(
  username, email, password, registerIp: string;
  rank = urGhost;
  registerDate = nowUnix()
): User =
  ## Creates new `User`
  new result
  result.username = username
  result.email = email
  result.salt = genSalt()
  result.password = result.salt.hashPassword password
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
  ## Converts the user to a JSON notation
  var node = %*user
  node{"rank"} = %user.rank
  # node{"lastLoginDate"} = % $user.lastLoginDate.fromUnix
  # node{"registerDate"} = % $user.registerDate.fromUnix
  for key in cantSeeUserFields:
    node.delete key
  node.delInternals
  result = $node

## DB

from restSpa/db import dbConn

proc get*(self: type User; username: string; fields: varargs[string] = []): User =
  ## Get the user in db which have the username or email same as `username`
  ##
  ## `fields` not working!!
  var queryFields = @["username", "email"]
  if fields.len > 0:
    # raise newException(ValueError, "`fields` not working!")
    queryFields = @fields
  User.getFromDb(newUser(), queryFields, username)

proc update*(user: var User; loginIp = "") =
  ## Updates the user in db
  ##
  ## To set new login, use `loginIp`
  user.lastLoginIp = loginIp
  user.lastLoginDate = nowUnix()
  inDb: dbConn.update user

func passwordIs*(self: User; pass: string): bool =
  ## Checks if the plain text password is same as hashed from DB
  self.password == self.salt.hashPassword pass
