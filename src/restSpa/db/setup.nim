from restSpa/db import DbConn, createTables
from restSpa/db/models/user import newUser

proc setup*(conn: DbConn) =
  ## Creates all tables
  conn.createTables(newUser())
