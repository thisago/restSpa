const internalDbPrefix* = "internal_"

# session
const sess_username* = "username"

# activation
const activationCodeLen* = 6

# error messages
const
  ifContainsAllErr* = "Please provide $1"
  ifContainsAtLeastErr* = "Please provide at least $1"
  ifContainsInvalidReq* = "Invalid request"
  
  userNotExists* = "User not exists"

  needLogin* = "User not logged in. Please signin"
  needLogoff* = "User logged in. Please logoff"

  rankNotMeet* = "Permission denied"

  invalidPassword* = "Invalid password"
  invalidActivCode* = "Invalid activation code"
  userAlreadyActivated* = "User already activated"
  successActivation* = "User successfully activated"

# user getting in DB
const
  userIdentifiers* = {
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

import std/locks

var confLock*: Lock
initLock confLock

# {.push guard: confLock.} # Why push isn't working?
let
  env = loadPrologueEnv ".env"

  dbHost* = env.getOrDefault("dbHost", ":memory:")
  dbUser* = env.getOrDefault("dbUser", "")
  dbPass* = env.getOrDefault("dbPass", "")

  address* = parseUri env.getOrDefault("address", "http://localhost:8080")
  (haveSsl*, host*, port*) = parseAddress address

  appName* = env.getOrDefault("appName", "restSpa")
  settings* = newSettings(
    appName = appName,
    debug = env.getOrDefault("debug", true),
    port = Port port,
    secretKey = env.getOrDefault("secretKey", ""),
    address = host
  )

  smtpServer* = env.getOrDefault("smtpServer", "")
  smtpPort* = env.getOrDefault("smtpPort", 587)
  smtpTls* = env.getOrDefault("smtpTls", true)
  smtpFrom* = env.getOrDefault("smtpFrom", "")
  smtpUser* = env.getOrDefault("smtpUser", "")
  smtpPass* = env.getOrDefault("smtpPass", "")

  errorLog* = env.getOrDefault("errorLog", "error.log")
  rollingLog* = env.getOrDefault("rollingLog", "rolling.log")

  hashExpiringHours* = env.getOrDefault("hashExpiringHours",
      2) ## How much hours to expire the hash used in links

# {.pop.}

template withConf*(body: untyped) =
  ## Dirt trick to bypass gcsafe check, if I use locks, then echo doesn't works
  {.gcsafe.}:
    # withLock confLock:
    body
