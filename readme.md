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
- Boilerplate free
- A lot of abstractions

## Routes

### API

The API understands the body type as JSON, url-encoded and forms. Just specify
the `Content-Type`

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

#### `POST /api/admin/getUser` - Get all the user data (**admin**)
Example:
```
POST /api/admin/getUser HTTP/1.1
Content-Type: application/json
cookie: session=<ADMIN SESSION>

{
  "username": "admin"
}
```

#### `POST /api/admin/editUser` - Get all the user data (**admin**)
Example:
```
POST /api/admin/getUser HTTP/1.1
Content-Type: application/json
cookie: session=<ADMIN SESSION>

{
  "id": "0",
  "email
}
```

---

## Setup

1. Uncomment `.env` in [.gitignore](.gitignore)
2. Replace all `respSpa` to your project name (including files/dirs names and inside files)
3. Change the `secretKey` in [.env](.env)

### Notes

- In production disable the `debug` in [.env](.env)

---

## TODO

- [ ] Hash the password
- [x] Add user permission levels
- [ ] Add a route to delete user (for moderators?)
- [ ] Add route to get the logged user data
- [ ] Add login logging table
- [x] Add last ip in `User`
- [ ] Add tests
- [ ] Support `id` for querying (`User`s)

---

## License

MIT
