import pkg/norm/model

type
  User* = ref object of Model
    ## User DB model
    username*, email*, password*: string

proc newUser*(username, email, password: string): User =
  ## Creates new `User`
  new result
  result.username = username
  result.email = email
  result.password = password # encrypt

proc newUser*: User =
  ## Creates new blank `User`
  newUser("", "", "")
