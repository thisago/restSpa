import std/logging

import prologue
import prologue/middlewares/utils
import prologue/middlewares/signedCookieSession

import restSpa/routes
import restSpa/db
import restSpa/db/setup

proc main =
  inDb: setup dbConn

  let
    env = loadPrologueEnv ".env"
    settings = newSettings(
      appName = env.getOrDefault("appName", "Prologue"),
      debug = env.getOrDefault("debug", true),
      port = Port env.getOrDefault("port", 8080),
      secretKey = env.getOrDefault("secretKey", ""),
      address = env.getOrDefault("address", "")
    )

  proc setLoggingLevel =
    addHandler newFileLogger(env.getOrDefault("errorLog", "error.log"), levelThreshold = lvlError)
    addHandler newRollingFileLogger env.getOrDefault("rollingLog", "rolling.log")
    addHandler(newConsoleLogger())
    if settings.debug:
      logging.setLogFilter(lvlDebug)
    else:
      logging.setLogFilter(lvlInfo)

  var app = newApp(
    settings = settings,
    startup = @[
      initEvent(setLoggingLevel)
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
