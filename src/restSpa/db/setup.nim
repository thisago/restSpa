import restSpa/db
from restSpa/db/models/user import newUser, UserRank, User

proc setup*(conn: DbConn) =
  ## Creates all tables
  conn.createTables(newUser())

  block createAdmin:
    var user = newUser(
      username = "admin",
      email = "admin@localhost",
      password = "admin",
      registerIp = "",
      rank = urAdmin
    )
    conn.insert user
