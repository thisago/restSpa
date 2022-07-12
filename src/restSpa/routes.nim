import pkg/prologue

import restSpa/routes/home
import restSpa/routes/api/auth

import restSpa/routes/default/notFound

type
  Route = tuple
    path: string
    routes: seq[UrlPattern]

const routesDefinition*: seq[Route] = @[
  ("", @[
    pattern("/", r_home, HttpGet, "home"),
  ]),
  ("api", @[
    pattern("/signin", r_signIn, HttpPost, "signin"),
    pattern("/signup", r_signUp, HttpPost, "signup"),
  ]),
]

let defaultRoutes* = @[
  (Http404, r_404)
]
