import pkg/prologue
import pkg/dotenv


import myinf/routes
import myinf/db
import myinf/db/setup

proc main =
  dotenv.load()

  inDb: setup dbConn
    
  let app = newApp()
  for r in routesDefinition:
    app.addRoute(r.routes, r.path)
  app.run()

when isMainModule:
  main()
