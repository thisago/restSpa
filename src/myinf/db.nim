import myinf/configs

import std/[
  options,
  logging
]

import pkg/norm/sqlite
export sqlite

import std/locks
export locks

addHandler newConsoleLogger(fmtStr = "")

var dbLock*: Lock
initLock dbLock
let dbConn* {.guard: dbLock.} = open(
  dbHost,
  dbUser,
  dbPass,
  ""
)

template inDb*(body: untyped) =
  # {.gcsafe.}:
  block:
    withLock dbLock:
      body
