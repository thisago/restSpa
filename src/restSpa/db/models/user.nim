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

proc newUser*(username, email, password: string): User =
  ## Creates new `User`
  new result
  result.username = username
  result.email = email
  result.password = password # encrypt

proc newUser*: User =
  ## Creates new blank `User`
  newUser("", "", "")
