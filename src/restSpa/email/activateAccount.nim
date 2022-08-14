from std/strformat import fmt
from std/os import `/`

import pkg/karax / [karaxdsl, vdom]

import restSpa/config
from restSpa/utils import url
import restSpa/email/send

proc render*(username, code: string): string {.gcsafe.} =
  withConf:
    let vnode = buildHtml(tdiv):
      h1: text fmt"Hello {username}!"
      p: text fmt"Thanks joining in {appName}"
      p:
        text "Please activate your account by clicking "
        a(href = url "activate" / username / code): text "here"
        text "."
    result = $vnode

proc send*(to, username, code: string; test = true): bool =
  ## Sends the account activation email
  withConf:
    result = sendMail(
      to = to,
      subject = fmt"Account Activation - {appName}",
      body = render(username, code),
      test = test
    )
  echo render(username, code)

when isMainModule:
  echo render("user", "activationCode")
