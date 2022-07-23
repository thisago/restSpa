# Package

version       = "0.12.0"
author        = "Thiago Navarro"
description   = "SPA & REST template using prologue, norm and karax"
license       = "mit"
srcDir        = "src"
bin           = @["restSpa"]
binDir = "build"


# Dependencies

requires "nim >= 1.6.4"


# Backend
requires "prologue", "norm", "mcmail"

# Backend and frontend
requires "karax"

# Tasks

task genDocs, "Generate documentation":
  exec "rm -r docs && nim doc -d:usestd --project -d:ssl --out:docs ./src/restSpa.nim"
