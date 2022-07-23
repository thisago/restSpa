const internalDbPrefix* = "internal_"

const
  sess_username* = "username"


# error messages
const
  userNotExists* = "User not exists"

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

from std/uri import Uri, parseUri
from std/strutils import parseInt

import pkg/prologue

func parseAddress(url: Uri): tuple[hasSsl: bool; host: string; port: int] =
  ## Parses the address into `haveSsl`, `host` and `port`
  result.hasSsl = url.scheme == "https"
  result.host = url.hostname
  result.port = if url.port.len == 0: 80 else: parseInt url.port

let
  env = loadPrologueEnv ".env"

  dbHost* = env.getOrDefault("dbHost", ":memory:")
  dbUser* = env.getOrDefault("dbUser", "")
  dbPass* = env.getOrDefault("dbPass", "")

  address* = parseUri env.getOrDefault("address", "http://localhost:8080")
  (haveSsl*, host*, port*) = parseAddress address

  settings* = newSettings(
    appName = env.getOrDefault("appName", "Prologue"),
    debug = env.getOrDefault("debug", true),
    port = Port port,
    secretKey = env.getOrDefault("secretKey", ""),
    address = host
  )

  smtpUser* = env.getOrDefault("smtpUser", "")
  smtpFrom* = env.getOrDefault("smtpFrom", "")
  smtpPass* = env.getOrDefault("smtpPass", "")
  smtpPort* = env.getOrDefault("smtpPort", 587)
  smtpServer* = env.getOrDefault("smtpServer", "")

  errorLog* = env.getOrDefault("errorLog", "error.log")
  rollingLog* = env.getOrDefault("rollingLog", "rolling.log")
