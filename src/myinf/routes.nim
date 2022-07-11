import pkg/prologue

import myinf/routes/home
import myinf/routes/api/auth

type Route = tuple
  path: string
  routes: seq[UrlPattern]

const routesDefinition*: seq[Route] = @[
  ("", @[
    pattern("/", r_home, HttpGet, "Homepage"),
  ]),
  ("api", @[
    pattern("/signin", r_signIn, HttpPost, "Sign In API"),
    pattern("/signup", r_signUp, HttpPost, "Sign Up API"),
  ]),
]
