# from std/logging import nil
from std/times import getTime, toUnix


proc nowUnix*: int64 =
  ## Returns the unix time of now
  getTime().toUnix

from std/uri import `$`
from restSpa/config import address

proc url*(path: string): string =
  var link = address
  link.path = path
  result = $link
