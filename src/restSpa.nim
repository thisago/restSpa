import std/logging

import pkg/prologue
import pkg/prologue/middlewares/utils
import pkg/prologue/middlewares/signedCookieSession

import restSpa/config
import restSpa/routes
import restSpa/db
import restSpa/db/setup

proc main =
  inDb:
    dbConn = open(dbHost, dbUser, dbPass, "")
    setup dbConn

  proc setLoggingLevel(settings: Settings; errorLog, rollingLog: string): auto =
    result = proc =
      addHandler newFileLogger(errorLog, levelThreshold = lvlError)
      addHandler newRollingFileLogger rollingLog
      addHandler(newConsoleLogger())
      if settings.debug:
        logging.setLogFilter(lvlDebug)
      else:
        logging.setLogFilter(lvlInfo)

  var app = newApp(
    settings = settings,
    startup = @[
      initEvent(settings.setLoggingLevel(errorLog, rollingLog))
    ]
  )

  app.use(@[debugRequestMiddleware(), sessionMiddleware(settings)])

  for r in routesDefinition:
    app.addRoute(r.routes, r.path)
  for (code, cb) in defaultRoutes:
    app.registerErrorHandler(code, cb)

  app.run()

when isMainModule:
  main()
else:
  {.fatal: "This module cannot be imported.".}
