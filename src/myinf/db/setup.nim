from myinf/db import DbConn, createTables
from myinf/db/models/user import newUser

proc setup*(conn: DbConn) =
  conn.createTables(newUser())
