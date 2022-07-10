import pkg/prologue

proc r_helloWorld*(ctx: Context) {.async.} =
  resp "<h1>Hello, Prologue!</h1>"
