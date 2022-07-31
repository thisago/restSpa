from std/strformat import fmt
from std/os import `/`

import pkg/karax / [karaxdsl, vdom]

from restSpa/config import appName
from restSpa/utils import url

proc render*(username, code: string): string =
  let vnode = buildHtml(tdiv):
    h1: text fmt"Hello {username}!"
    p: text fmt"Thanks joining in {appName}"
    p:
      text "Please activate your account by clicking "
      a(href = url "activate" / code): text "here"
      text "."
  result = $vnode

when isMainModule:
  echo render("user", "activationCode")
