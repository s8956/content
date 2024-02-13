Работу {{< tag "Postfix" >}} можно проверить при помощи {{< tag "Telnet" >}}, подключившись к 25 порту. При успешном подключении, должен прийти ответ с кодом 220.

```terminal
telnet localhost 25

Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
220 mail.zimbra.local ESMTP Postfix
Helo mail.zimbra.local
250 mail.zimbra.local
MAIL FROM:<admin@zimbra.local>
250 2.1.0 Ok
RCPT TO:<user@zimbra.local>
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
Subject: My Test Email
This is the body of the Email
.
250 2.0.0 Ok: queued as 194869C1AB
quit
221 2.0.0 Bye
Connection closed by foreign host.
```

```terminal
telnet mail.zimbra.local 25

220 mail.zimbra.local ESMTP Postfix
ehlo mail.zimbra.local
250-mail.zimbra.local
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-STARTTLS
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN
MAIL FROM:<admin@zimbra.local>
250 2.1.0 Ok
RCPT TO:<user@zimbra.local>
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
Subject: My Test Email
This is the body of the EMAIL Message!
.
250 2.0.0 Ok: queued as 538BB9C1AD
```
