# Changelog

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
