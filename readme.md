# restSpa

SPA & REST template using Prologue, Norm and Karax

## Stack

- Nim (Programming language)
- Norm (ORM)
- Prologue (Backend framework)
- Karax (Frontend framework)

## Features

- User manipulation in a SQLite DB
- `.env` configs
- REST API
- SPA
- 100% in Nim

## Setup

1. Uncomment `.env` in [.gitignore](.gitignore)
2. Replace all `respSpa` to your project name
3. Change the `secretKey` in [.env](.env)

- In production disable the `debug` in [.env](.env)

## TODO

- [ ] Hash the password
- [ ] Add user permission levels
- [ ] Add delete user route (for moderators?)
- [ ] Add route to get the logged user data
- [ ] Add login logging table
- [ ] Add last ip in `User`
- [ ] Add tests

---

## License

MIT
