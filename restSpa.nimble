# Package

version       = "0.3.0"
author        = "Thiago Navarro"
description   = "SPA & REST template using prologue, norm and karax"
license       = "Proprietary"
srcDir        = "src"
bin           = @["restSpa"]
binDir = "build"


# Dependencies

requires "nim >= 1.7.1"

# Backend
requires "prologue", "norm"
