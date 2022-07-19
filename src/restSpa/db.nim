import pkg/norm/sqlite
export sqlite

import std/locks
export locks

var dbLock*: Lock
initLock dbLock

var dbConn* {.guard: dbLock.}: DbConn

template inDb*(body: untyped) =
  {.gcsafe.}:
    withLock dbLock:
      body
