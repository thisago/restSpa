# Changelog

## Version 0.21.0 (Aug 31, 2022)

- Added URL decoding at `routeUtils.withParams`

---

## Version 0.20.0 (Aug 28, 2022)

- Added a config to change error responses kind: if `logicInApi` the response
  will be a JSON
- Fixed compiling error
- Fixed GET request fake error at `routeUtils.withParams`

---
## Version 0.19.0 (Aug 28, 2022)

- Added option to merge path parameters at `routeUtils.withParams`

---

## Version 0.18.0 (Aug 22, 2022)

- Added `GET /api/resend/{kind}`

---

## Version 0.17.0 (Aug 16, 2022)

- Added a requirement to specify the user password at user verification
- Fixed login password hashing
- Fixed corrupted session trick

---

## Version 0.16.0 (Aug 14, 2022)

- Changed user activation to a code
- API response is now a object, `ResponseKind`
- Added string values to `UserRank` and `ResponseKind` enum
- Fixed `db/utils.getFromDb`
- Hash user password

---

## Version 0.15.0 (Jul 31 2022)

- Sending (not sending, just printing) activation email when new user was created
- Added `POST /api/activate` to activate account
- Fixed ident hash generation and checking
- Fixed error whe session is broken

---

## Version 0.14.0 (Jul 28 2022)

- Separated all routes to a individual file (Fix [#3](https://github.com/thisago/restSpa/issues/3))
- Removed some debug `echo`s
- Moved route utils to parent dir. The `routes` dir can have only routes

---

## Version 0.13.0 (Jul 23 2022)

- Added salt and ident generation
- Added ident check
- Added salt to user db
- Removed salt and password from data sended to admin in `/api/admin/getUser` route
- Use `delInternals` in `user.toJson` to avoid repeat

---

## Version 0.12.0 (Jul 23 2022)

- Moved env getting to `restSpa/config.nim`
- Added option to change all urls to `https`
- Added email sending (untested)
- Added activate mail template

---

## Version 0.11.0 (Jul 20 2022)

- Added an error when no fields to edit was provided at `POST /api/admin/editUser` route
- Added `POST /api/delUser` route to delete the logged user
- Renamed module `restSpa/routes/api/auth.nim` to `user.nim`
- Added `POST /api/admin/delUser` to delete any user (admin)
- Refactored login route using newly added abstractions
- Removed the full user sending in sign up
- Added `POST logOut route`

---

## Version 0.10.1 (Jul 20 2022)

- Removed `debugEcho` from `delInternals`
- Moved the blacklisted editing fields of `User` to [restSpa/db/models/user.nim](src/restSpa/db/models/user.nim) just to be able to see in docs

---

## Version 0.10.0 (Jul 19 2022)

- Added `editUser` admin route to edit any user data
- Added `deleteUser` admin a route to delete any user
- Fixed urlencoded api handling
- Added to `ifContains` support to check if have all fields or at least one
- Removed route `setRank` because `editUser` can do it
- Added `updateFields` to update a object giving a JSON node, supports blacklist fields
- Changed `doAssert` to just `assert` in `forceHttpMethod` because it just need to check in development
- Added `delInternals` func to delete all DB internal values from JSON node
- Added `withUser` to abstract the user getting from request
- Added `getUsing` to get some DB row using a specific value/column
- Moved all error messages from [utils.nim](src/restSpa/routes/utils.nim)

---

## Version 0.9.0 (Jul 18 2022)

- Updated docs
- Updated readme
- Fixed db env config getting

---

## Version 0.8.0 (Jul 18 2022)

- Added `getUser` admin route to get all user data
- Added min rank verification
- Automatically creates the admin
- Fixed `ifContains` error formatting
- Added `registerIp` and `lastLoginIp` to `User`
- Added `registerDate` and `lastLoginDate` to `User`

---

## Version 0.7.0 (Jul 17 2022)

- Fixed user rank
- Added `setRank` to admin privilege routes in API
- Fixed `withParams` calling
- Added to utils
  - `getSession` - Tries to get a session value
  - `ifLogin` - Runs the code if user have login
  - `ifRank` - Runs the code if user have correct rank

---

## Version 0.6.0 (Jul 13 2022)

- Added user rank
- Added docs

---

## Version 0.5.0 (Jul 12 2022)

- Added rolling and error file logging (can config in [.env](.env))
- Added auto support to forms and `application/x-www-form-urlencoded` body format and seamless integration using `ctx.withParams:`
- Fixed routes names
- Added compile-time option to disable form auto parsing
- Added custom 404 page

---

## Version 0.4.0 (Jul 11 2022)

- Added session based login

---

## Version 0.3.0 (Jul 11 2022)

- Replaced helloWorld to home route
- Using the prologue env parser instead of dotenv module
- Added more .env configs
- Added debug logging
- Added API
  - Added register route
- Added utilities

---

## Version 0.2.0 (Jul 10 2022)

- DB
  - Added db connection
  - Added user model
  - Added setup
- added Hello world route
- Added routes file
- Added env loader in `configs.nim`

---

## Version 0.1.0 (Jul 9 2022)

- Init
- Added hello world in prologue
- Added .env file
- Added readme and config.nims
- Added binPath in nimble
