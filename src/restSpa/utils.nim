# from std/logging import nil
from std/times import getTime, toUnix
from std/json import JsonNode, keys, delete
import restSpa/config

proc nowUnix*: int64 =
  ## Returns the unix time of now
  getTime().toUnix

from std/uri import `$`
from restSpa/config import address

proc url*(path: string): string =
  var link = address
  link.path = path
  result = $link

func delInternals*(node: var JsonNode) =
  ## Deletes all DB internals fields from a JSON node
  const internalDbPrefixLen = internalDbPrefix.len
  for key in node.keys:
    if key.len > internalDbPrefixLen:
      if key[0..<internalDbPrefixLen] == internalDbPrefix:
        node.delete key
