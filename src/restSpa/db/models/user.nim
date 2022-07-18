import pkg/norm/[
  model,
  pragmas
]

type
  User* = ref object of Model
    ## User DB model
    username* {.unique.}: string
    email* {.unique.}: string
    password*: string

    internalRank*: int

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


proc newUser*(username, email, password: string): User =
  ## Creates new `User`
  new result
  result.username = username
  result.email = email
  result.password = password # encrypt
  result.rank = urGhost

proc newUser*: User =
  ## Creates new blank `User`
  newUser("", "", "")
