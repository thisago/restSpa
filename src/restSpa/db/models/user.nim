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
    rank*: UserRanks

  UserRanks* = enum
    urGhost, ## Ghost is a user that cannot do anything, a unverified user
    urUser,  ## Default user privileges
    urAdmin  ## All privileges

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
