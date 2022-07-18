# from std/logging import nil
from times import getTime, toUnix

proc nowUnix*: int64 =
  ## Returns the unix time of now
  getTime().toUnix
