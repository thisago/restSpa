from restSpa/auth/gen import genIdentHash

template verifyIdentHash*(usr: untyped; ident: string; epoch: int64): bool =
  ## Check if the ident hash is valid
  result = false
  let newIdent = genIdentHash(usr.username, usr.salt, epoch, usr.salt)
