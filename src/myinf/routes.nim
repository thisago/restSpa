import pkg/prologue

import myinf/routes/helloWorld

type Route = tuple
  path: string
  routes: seq[UrlPattern]

const routesDefinition*: seq[Route] = @[
  ("", @[
    pattern("/", r_helloWorld, HttpGet, "Hello World"),
  ]),
]
