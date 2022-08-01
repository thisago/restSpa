# restSpa

SPA & REST template using Prologue, Norm and Karax

The template is not ready yet, but you can follow all changes on [changelog](changelog.md)

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
```http
GET /api/signin HTTP/1.1
Content-Type: application/json

{
  "username": "user",
  "password": "pass"
}
```

#### `POST /api/signup` - Create new account
Example:
```http
GET /api/signup HTTP/1.1
Content-Type: application/json

{
  "username": "user",
  "email": "user@localhost",
  "password": "pass",
}
```

#### `POST /api/logout`
Example:
```http
GET /api/logout HTTP/1.1
Cookie: session=<LOGGED SESSION>
```

#### `POST /api/delUser` - Delete current user
Example:
```http
GET /api/delUser HTTP/1.1
Cookie: session=<LOGGED SESSION>
```

#### `POST /api/activate` - Activate the user
Example:
```http
GET /api/activate HTTP/1.1
Content-Type: application/json

{
  "username": "user",
  "hash": "verification code",
}
```

---

**Admin**

#### `POST /api/admin/getUser` - Get any user data (**admin**)
Example:
```http
POST /api/admin/getUser HTTP/1.1
Content-Type: application/json
Cookie: session=<ADMIN SESSION>

{
  "_username": "user" // Get using username
  // "_email": "user@localhost" // Get using email
}
```

#### `POST /api/admin/editUser` - Edit any user (**admin**)
Example: (can edit multiple fields at same time too)
```http
POST /api/admin/getUser HTTP/1.1
Content-Type: application/json
Cookie: session=<ADMIN SESSION>

{
  "_username": "admin", // Edit using username
  // "_email": "admin@localhost", // Edit using email
  "rank": "urUser" // Can edit almost any field, in this case, we are removing admin privileges
}
```

#### `POST /api/admin/delUser` - Delete any user (**admin**)
Example:
```http
POST /api/admin/getUser HTTP/1.1
Content-Type: application/json
Cookie: session=<ADMIN SESSION>

{
  "_username": "user", // Delete using username
  // "_email": "user@localhost", // Delete using email
}
```

---

**Any API request can be made with `application/json`,**
**`application/x-www-form-urlencoded` and `multipart/form-data`**
**content types, just specify the `Content-Type` header**

---

## Setup

1. Uncomment `.env` in [.gitignore](.gitignore)
2. Replace all `respSpa` to your project name (including files/dirs names and inside files)
3. Change the `secretKey` in [.env](.env)
4. Change the `version`, `description` and `author` in [nimble file](restSpa.nimble) - Don't forget the credits ;)

### Notes

- In production disable the `debug` in [.env](.env)


## Style-guide and good practices

- All procs starting with `r_` is a route
- All routes calls `forceHttpMethod` that checks if the route is called using
  the correct HTTP method (useful in development and helps identify the routes
  by reading the code)
- In a `if` statement, try to put the error/fallback in the last
- Imports sequence is: std, pkg and local (current project)
- Each route file can have just one route
- in `routes` dir can have just routes because the filename is same as route name

---

## TODO

- [ ] Hash the password
- [x] Add user permission levels
- [ ] Add a route to delete user (for moderators?)
- [ ] Add route to get the logged user data
- [ ] Add login logging table
- [x] Add last ip in `User`
- [ ] **Add tests**
- [ ] Support `id` for querying (`User`s)
- [x] Add an error when no fields to edit was provided at `/api/admin/editUser` route
- [ ] Frontend (break it in smaller tasks)
- [ ] Fix email sending
- [x] Add user activation
- [ ] Add user password reset
- [ ] Add honeypots or captcha
- [ ] Low priority: Add a temp block to multiple requests at same time to prevent DoS
- [ ] Block use of certain usernames and add filters. Like special chars
- [ ] Add a route to request new email validation (or don't expire the link)
- [ ] Fix API to be REST (Resources: [IBM](https://www.ibm.com/cloud/learn/rest-apis), [RestfulAPI](https://restfulapi.net/))
  - [ ] Statelessness - Remove session verification at API, use some API key

---

## License

MIT
