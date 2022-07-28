# Package

version       = "0.14.0"
author        = "Thiago Navarro"
description   = "SPA & REST template using Prologue, Norm and Karax"
license       = "mit"
srcDir        = "src"
bin           = @["restSpa"]
binDir = "build"


# Dependencies

requires "nim >= 1.6.4"


# Backend
requires "prologue", "norm", "bcrypt", "hmac"
requires "https://github.com/abbeymart/mcmail-nim"

# Backend and frontend
requires "karax"

# Tasks

task genDocs, "Generate documentation":
  exec "rm -r docs && nim doc -d:usestd --project -d:ssl --out:docs ./src/restSpa.nim"
