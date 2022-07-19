import pkg/prologue

import restSpa/routes/home
import restSpa/routes/api/auth

import restSpa/routes/api/admin

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
  ("api/admin", @[
    pattern("/setRank", r_setRank, HttpPost, "setRank"),
    pattern("/getUser", r_getUser, HttpPost, "getUser"),
    pattern("/editUser", r_editUser, HttpPost, "editUser"),
  ]),
]

let defaultRoutes* = @[
  (Http404, r_404)
]
