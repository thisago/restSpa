from std/os import getEnv

const
  dbHost* = getEnv "DB_HOST"
  dbUser* = getEnv "DB_USER"
  dbPass* = getEnv "DB_PASS"
