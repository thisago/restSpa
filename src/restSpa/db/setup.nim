from restSpa/db import DbConn, createTables
from restSpa/db/models/user import newUser

proc setup*(conn: DbConn) =
  conn.createTables(newUser())
