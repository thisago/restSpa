import pkg/prologue

import restSpa/utils

proc r_404*(ctx: Context) {.async.} =
  ## Default 404 page
  resp "<h1>404 Not Found</h1>", Http404
