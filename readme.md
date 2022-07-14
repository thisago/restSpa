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

## Routes

### API

The API understands the body type as JSON, url-encoded and forms.

#### `POST /api/signin` - Login
Example:
```
GET /api/signin HTTP/1.1
Content-Type: application/json

{
  "username": "john",
  "password": "doe",
}
```

#### `POST /api/signup` - Signup
Example:
```
GET /api/signup HTTP/1.1
Content-Type: application/json

{
  "username": "john",
  "email": "johndoe@example.com",
  "password": "doe",
}
```

---

## Setup

1. Uncomment `.env` in [.gitignore](.gitignore)
2. Replace all `respSpa` to your project name
3. Change the `secretKey` in [.env](.env)

### Notes

- In production disable the `debug` in [.env](.env)

---

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
