import pkg/prologue

import restSpa/routes/home
# import restSpa/routes/activate as getActivate

import restSpa/routes/api/[
  signIn,
  signUp,
  logout,
  activate,
]
import restSpa/routes/api/delUser as usrDelUser

import restSpa/routes/api/admin/[
  getUser,
  editUser,
  delUser
]

import restSpa/routes/default/notFound

type
  Route = tuple
    path: string
    routes: seq[UrlPattern]

const
  routesDefinition*: seq[Route] = @[
    ("", @[
      pattern("/", r_home, HttpGet, "home"),
      # pattern("/activate/{username}/{code}", getActivate.r_activate, HttpGet, "activate"),
    ]),
    ("api", @[
      pattern("/signin", r_signIn, HttpPost, "api_signin"),
      pattern("/signup", r_signUp, HttpPost, "api_signup"),
      pattern("/delUser", usrDelUser.r_delUser, HttpPost, "api_delUser"),
      pattern("/logout", r_logout, HttpPost, "api_logout"),
      pattern("/activate", activate.r_activate, HttpPost, "api_activate"),
    ]),
    ("api/admin", @[
      pattern("/getUser", r_getUser, HttpPost, "api_admin_getUser"),
      pattern("/editUser", r_editUser, HttpPost, "api_admin_editUser"),
      pattern("/delUser", delUser.r_delUser, HttpPost, "api_admin_delUser"),
    ]),
  ]

  defaultRoutes* = @[
    (Http404, r_404)
  ]
