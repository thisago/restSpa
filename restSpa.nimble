# Package

version       = "0.21.0"
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
requires "https://github.com/thisago/mcmail-nim", "util"

# Backend and frontend
requires "karax"

# Tasks

task genDocs, "Generate documentation":
  exec "rm -r docs; nim doc -d:usestd --git.commit:master --git.url:https://github.com/thisago/restSpa --project -d:ssl --out:docs ./src/restSpa.nim"
