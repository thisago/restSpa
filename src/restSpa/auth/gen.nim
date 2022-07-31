## Base: https://github.com/nim-lang/nimforum/blob/master/src/auth.nim
from std/base64 import nil
from std/strformat import fmt
from std/strutils import split
import std/random

# import pkg/bcrypt
import pkg/hmac

import restSpa/utils

proc genIdentHash*(username, password, salt, epoch: string): string =
  ## Generates a hash that can be used as single use pass
  hmac_sha256(salt, username & password & epoch).toHex()

proc randomSalt: string =
  result = ""
  for i in 0..127:
    var r = rand(225)
    if r >= 32 and r <= 126:
      result.add(chr(rand(225)))

proc devRandomSalt: string =
  when defined(posix):
    result = ""
    var f = open("/dev/urandom")
    var randomBytes: array[0..127, char]
    discard f.readBuffer(addr(randomBytes), 128)
    for i in 0..127:
      if ord(randomBytes[i]) >= 32 and ord(randomBytes[i]) <= 126:
        result.add(randomBytes[i])
    f.close()
  else:
    result = randomSalt()

proc genSalt*: string =
  ## Creates a salt using a cryptographically secure random number generator.
  ##
  ## Ensures that the resulting salt contains no ``\0``.
  try:
    result = devRandomSalt()
  except IOError:
    result = randomSalt()

proc genAuthHash*(username, password, salt: string; epoch = $nowUnix()): string =
  ## Generates the complete auth hash with epoch encoded as base64
  let ident = genIdentHash(username, password, salt, epoch)
  result = base64.encode fmt"{ident}:{epoch}"
  echo "hash = ", result

proc unpackAuthHash*(hash: string): tuple[ident, epoch: string] =
  ## Generates the complete auth hash with epoch encoded as base64
  let res = base64.decode(hash).split ":"
  if res.len == 2:
    result = (res[0], res[1])
