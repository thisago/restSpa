const internalDbPrefix* = "internal_"

const
  sess_username* = "username"


# error messages
const
  cannotFindUser* = "Cannot find the user"

  ifContainsAllErr* = "Please provide $1"
  ifContainsAtLeastErr* = "Please provide at least $1"
  ifContainsInvalidReq* = "Invalid request"

  needLogin* = "User not logged in. Please signin"
  needLogoff* = "User logged in. Please logoff"

  rankNotMeet* = "Permition denied"

# user getting in DB
const
  userIdentificators* = {
    "_username": "username",
    "_email": "email"
  }
