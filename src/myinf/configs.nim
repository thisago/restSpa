from std/os import getEnv

const
  dbHost* = getEnv "dbHost"
  dbUser* = getEnv "dbUser"
  dbPass* = getEnv "dbPass"
