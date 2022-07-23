import pkg/mcmail

import restSpa/config

from restSpa/email/activateAccount import nil
export activateAccount

let mailer = EmailConfigType(
  username: smtpUser,
  password: smtpPass,
  # serverUrl: "45.63.107.209",
  serverUrl: smtpServer,
  port: smtpPort,
  msgFrom: smtpFrom,
)

proc sendMail*(to, subject, body: string; mime = "html"; test = true): bool =
  ## Tries to send an email `to` destination, the `body can be HTML when `mime`
  ## is "html"
  ##
  ## Enable `test` mode to prevent sending and just printing on stdout
  result = true
  let emailMsg = EmailMessage(
    msgTo: @[to],
    msgCc: @[],
    msgSubject: subject,
    msgBody: body,
  )
  if not test:
    let res = sendEmail(mailer, emailMsg, mime)
    result = $res.code == "success"
    # if not result:
    #   echo res.message
  else:
    echo emailMsg

when isMainModule:

  echo sendMail(
    to = "henry@oxyoy.com",
    subject = "subject",
    body = "<h1>body</h1>",
    # test = true
  )
