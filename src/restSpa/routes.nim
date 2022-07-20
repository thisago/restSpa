import pkg/prologue

import restSpa/routes/home
import restSpa/routes/api/user

import restSpa/routes/api/admin

import restSpa/routes/default/notFound

type
  Route = tuple
    path: string
    routes: seq[UrlPattern]

const
  routesDefinition*: seq[Route] = @[
    ("", @[
      pattern("/", r_home, HttpGet, "home"),
    ]),
    ("api", @[
      pattern("/signin", r_signIn, HttpPost, "signin"),
      pattern("/signup", r_signUp, HttpPost, "signup"),
      pattern("/delUser", user.r_delUser, HttpPost, "user_delUser"),
      pattern("/logout", r_logout, HttpPost, "logout"),
    ]),
    ("api/admin", @[
      pattern("/getUser", r_getUser, HttpPost, "getUser"),
      pattern("/editUser", r_editUser, HttpPost, "editUser"),
      pattern("/delUser", admin.r_delUser, HttpPost, "admin_delUser"),
    ]),
  ]

  defaultRoutes* = @[
    (Http404, r_404)
  ]
