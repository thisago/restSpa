import std/logging

import prologue
import prologue/middlewares/utils
import prologue/middlewares/signedCookieSession

import myinf/routes
import myinf/db
import myinf/db/setup


proc main =
  inDb: setup dbConn
    
  let
    env = loadPrologueEnv ".env"
    settings = newSettings(
      appName = env.getOrDefault("appName", "Prologue"),
      debug = env.getOrDefault("debug", true),
      port = Port env.getOrDefault("port", 8080),
      secretKey = env.getOrDefault("secretKey", ""),
    )

  proc setLoggingLevel =
    if settings.debug:
      addHandler(newConsoleLogger())
      logging.setLogFilter(lvlDebug)
    
  var app = newApp(
    settings = settings,
    startup = @[
      initEvent(setLoggingLevel)
    ]
  )

  app.use(@[debugRequestMiddleware(), sessionMiddleware(settings)])

  for r in routesDefinition:
    app.addRoute(r.routes, r.path)
  app.run()

when isMainModule:
  main()
