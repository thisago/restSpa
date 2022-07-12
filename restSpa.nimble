# Package

version       = "0.5.0"
author        = "Thiago Navarro"
description   = "SPA & REST template using prologue, norm and karax"
license       = "mit"
srcDir        = "src"
bin           = @["restSpa"]
binDir = "build"


# Dependencies

requires "nim >= 1.7.1"

# Backend
requires "prologue", "norm"
