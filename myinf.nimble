# Package

version       = "0.2.0"
author        = "Thiago Navarro"
description   = "MyInf.co"
license       = "Proprietary"
srcDir        = "src"
bin           = @["myinf"]
binDir = "build"


# Dependencies

requires "nim >= 1.7.1"

# Backend
requires "prologue", "norm", "dotenv"
