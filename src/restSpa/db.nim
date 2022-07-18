import restSpa/configs

import pkg/norm/sqlite
export sqlite

import std/locks
export locks

var dbLock*: Lock
initLock dbLock

let dbConn* {.guard: dbLock.} = open(
  dbHost,
  dbUser,
  dbPass,
  ""
)

template inDb*(body: untyped) =
  {.gcsafe.}:
    withLock dbLock:
      body
