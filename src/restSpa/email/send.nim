import pkg/mcmail

import restSpa/config

proc sendMail*(to, subject, body: string; mime = "html"; test = true): bool =
  ## Tries to send an email `to` destination, the `body can be HTML when `mime`
  ## is "html"
  ##
  ## Enable `test` mode to prevent sending and just printing on stdout
  ## 
  ## FIX EMAIL SENDING
  result = true
  var mailer: EmailConfigType
  withConf:
    mailer = EmailConfigType(
      username: smtpUser,
      password: smtpPass,
      serverUrl: smtpServer,
      port: smtpPort,
      msgFrom: smtpFrom,
      tls: smtpTls
    )
  let emailMsg = EmailMessage(
    msgTo: @[to],
    msgCc: @[],
    msgSubject: subject,
    msgBody: body,
  )
  if not test:
    let res = mailer.sendEmail(emailMsg, mime)
    result = $res.code == "success"
    # if not result:
    #   echo res.message
  else:
    echo emailMsg

when isMainModule:
  echo sendMail(
    to = "user@example.com",
    subject = "subject",
    body = "<h1>Title</h1>",
    # test = true
  )
