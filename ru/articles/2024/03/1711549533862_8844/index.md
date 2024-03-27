---
# -------------------------------------------------------------------------------------------------------------------- #
# General settings.
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Как проверить DNS записи домена?'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'network'
  - 'linux'
  - 'windows'
tags:
  - 'dns'
  - 'dig'
  - 'drill'
  - 'nslookup'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# Date settings.
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-03-27T17:25:34+03:00'
publishDate: '2024-03-27T17:25:34+03:00'
expiryDate: ''
lastMod: '2024-03-27T17:25:34+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# Meta settings.
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'bd4f198b907ebc14f0c6a7c032891ce085bf80aa'
uuid: 'bd4f198b-907e-5c14-90c6-a7c032891ce0'
slug: 'bd4f198b-907e-5c14-90c6-a7c032891ce0'

draft: 1
---



<!--more-->

## Общая информация

### Dig

```
dig example.com
```

```terminal {os="linux", hl="text"}
dig google.com
```

### Drill

```
drill example.com
```

```terminal {os="linux",hl="text"}
drill google.com

;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 45117
;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; QUESTION SECTION:
;; google.com.  IN      A

;; ANSWER SECTION:
google.com.     184     IN      A       216.58.210.142

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:

;; Query time: 3 msec
;; SERVER: 10.1.0.1
;; WHEN: Wed Mar 27 17:41:27 2024
;; MSG SIZE  rcvd: 44
```

### NSLookUp

```
nslookup example.com
```

```terminal {os="windows",hl="text"}
nslookup google.com
```

## Отдельные записи DNS домена

### Dig

```
dig mx example.com
```

```terminal {os="linux",hl="text"}
dig mx google.com
```

### Drill

```
drill mx example.com
```

```terminal {os="linux",hl="text"}
drill mx google.com

;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 51703
;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 5
;; QUESTION SECTION:
;; google.com.  IN      MX

;; ANSWER SECTION:
google.com.     30      IN      MX      10 smtp.google.com.

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:
smtp.google.com.        30      IN      A       142.250.150.27
smtp.google.com.        30      IN      A       64.233.161.27
smtp.google.com.        30      IN      A       64.233.161.26
smtp.google.com.        30      IN      A       64.233.162.27
smtp.google.com.        30      IN      A       142.250.150.26

;; Query time: 4 msec
;; SERVER: 10.1.0.1
;; WHEN: Wed Mar 27 17:41:53 2024
;; MSG SIZE  rcvd: 136
```

### NSLookUp

```
nslookup -type=mx example.com
```

```terminal {os="windows",hl="text"}
nslookup -type=mx google.com

Server:  gw01.lan
Address:  10.1.0.1

Non-authoritative answer:
google.com      MX preference = 10, mail exchanger = smtp.google.com

smtp.google.com internet address = 173.194.221.27
smtp.google.com internet address = 173.194.222.27
smtp.google.com internet address = 173.194.222.26
smtp.google.com internet address = 74.125.205.27
smtp.google.com internet address = 173.194.220.26
```

## Трассировка

### Dig

```
dig +trace example.com
```

```terminal {os="linux",hl="text"}
dig +trace google.com
```

### Drill

```
drill -TD example.com
```

```terminal {os="linux",hl="text"}
drill -TD google.com

Warning: No trusted keys were given. Will not be able to verify authenticity!
;; Domain: .
;; Signature ok but no chain to a trusted key or ds record
[S] . 172800 IN DNSKEY 256 3 8 ;{id = 5613 (zsk), size = 2048b}
. 172800 IN DNSKEY 257 3 8 ;{id = 20326 (ksk), size = 2048b}
. 172800 IN DNSKEY 256 3 8 ;{id = 30903 (zsk), size = 2048b}
Checking if signing key is trusted:
New key: .      172800  IN      DNSKEY  256 3 8 AwEAAentCcIEndLh2QSK+pHFq/PkKCwioxt75d7qNOUuTPMo0Fcte/NbwDPbocvbZ/eNb5RV/xQdapaJASQ/oDLsqzD0H1+JkHNuuKc2JLtpMxg4glSE4CnRXT2CnFTW5IwOREL+zeqZHy68OXy5ngW5KALbevRYRg/q2qFezRtCSQ0knmyPwgFsghVYLKwi116oxwEU5yZ6W7npWMxt5Z+Qs8diPNWrS5aXLgJtrWUGIIuFfuZwXYziGRP/z3o1EfMo9zZU19KLopkoLXX7Ls/diCXdSEdJXTtFA8w0/OKQviuJebfKscoElCTswukVZ1VX5gbaFEo2xWhHJ9Uo63wYaTk= ;{id = 30903 (zsk), size = 2048b}
[S] com. 86400 IN DS 19718 13 2 8acbb0cd28f41250a80a491389424d341522d946b0da0c0291f2d3d771d7805a
;; Domain: com.
;; Signature ok but no chain to a trusted key or ds record
[S] com. 86400 IN DNSKEY 256 3 13 ;{id = 4534 (zsk), size = 256b}
com. 86400 IN DNSKEY 257 3 13 ;{id = 19718 (ksk), size = 256b}
[S] Existence denied: google.com. DS
;; No ds record for delegation
;; Domain: google.com.
;; No DNSKEY record found for google.com.
[U] google.com. 300     IN      A       108.177.14.102
google.com.     300     IN      A       108.177.14.113
google.com.     300     IN      A       108.177.14.101
google.com.     300     IN      A       108.177.14.138
google.com.     300     IN      A       108.177.14.100
google.com.     300     IN      A       108.177.14.139
;;[S] self sig OK; [B] bogus; [T] trusted; [U] unsigned
```

### Drill

```
drill -T example.com
```

```terminal {os="linux",hl="text"}
drill -T google.com

.       518400  IN      NS      a.root-servers.net.
.       518400  IN      NS      b.root-servers.net.
.       518400  IN      NS      c.root-servers.net.
.       518400  IN      NS      d.root-servers.net.
.       518400  IN      NS      e.root-servers.net.
.       518400  IN      NS      f.root-servers.net.
.       518400  IN      NS      g.root-servers.net.
.       518400  IN      NS      h.root-servers.net.
.       518400  IN      NS      i.root-servers.net.
.       518400  IN      NS      j.root-servers.net.
.       518400  IN      NS      k.root-servers.net.
.       518400  IN      NS      l.root-servers.net.
.       518400  IN      NS      m.root-servers.net.
com.    172800  IN      NS      m.gtld-servers.net.
com.    172800  IN      NS      j.gtld-servers.net.
com.    172800  IN      NS      f.gtld-servers.net.
com.    172800  IN      NS      l.gtld-servers.net.
com.    172800  IN      NS      g.gtld-servers.net.
com.    172800  IN      NS      c.gtld-servers.net.
com.    172800  IN      NS      k.gtld-servers.net.
com.    172800  IN      NS      b.gtld-servers.net.
com.    172800  IN      NS      d.gtld-servers.net.
com.    172800  IN      NS      h.gtld-servers.net.
com.    172800  IN      NS      a.gtld-servers.net.
com.    172800  IN      NS      i.gtld-servers.net.
com.    172800  IN      NS      e.gtld-servers.net.
google.com.     172800  IN      NS      ns2.google.com.
google.com.     172800  IN      NS      ns1.google.com.
google.com.     172800  IN      NS      ns3.google.com.
google.com.     172800  IN      NS      ns4.google.com.
google.com.     300     IN      A       108.177.14.139
google.com.     300     IN      A       108.177.14.102
google.com.     300     IN      A       108.177.14.138
google.com.     300     IN      A       108.177.14.100
google.com.     300     IN      A       108.177.14.101
google.com.     300     IN      A       108.177.14.113
```

## Запись PTR домена

### Dig

```
dig +short -x IP_ADDRESS
```

```terminal {os="linux",hl="text"}
dig +short -x 108.177.14.100
```

### Drill

```
drill -x IP_ADDRESS
```

```terminal {os="linux",hl="text"}
drill -x 108.177.14.100

;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 55533
;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; QUESTION SECTION:
;; 100.14.177.108.in-addr.arpa. IN      PTR

;; ANSWER SECTION:
100.14.177.108.in-addr.arpa.    14366   IN      PTR     lt-in-f100.1e100.net.

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:

;; Query time: 3 msec
;; SERVER: 10.1.0.1
;; WHEN: Wed Mar 27 17:44:49 2024
;; MSG SIZE  rcvd: 79
```

### NSLookUp

```
nslookup -debug IP_ADDRESS
```

```terminal {os="windows",hl="text"}
nslookup -debug 108.177.14.100

------------
Got answer:
    HEADER:
        opcode = QUERY, id = 1, rcode = NOERROR
        header flags:  response, want recursion, recursion avail.
        questions = 1,  answers = 1,  authority records = 0,  additional = 1

    QUESTIONS:
        1.0.1.10.in-addr.arpa, type = PTR, class = IN
    ANSWERS:
    ->  1.0.1.10.in-addr.arpa
        name = gw01.lan
        ttl = 86400 (1 day)
    ADDITIONAL RECORDS:
    ->  gw01.lan
        internet address = 10.1.0.1
        ttl = 86400 (1 day)

------------
Server:  gw01.lan
Address:  10.1.0.1

------------
Got answer:
    HEADER:
        opcode = QUERY, id = 2, rcode = NOERROR
        header flags:  response, want recursion, recursion avail.
        questions = 1,  answers = 1,  authority records = 0,  additional = 0

    QUESTIONS:
        100.14.177.108.in-addr.arpa, type = PTR, class = IN
    ANSWERS:
    ->  100.14.177.108.in-addr.arpa
        name = lt-in-f100.1e100.net
        ttl = 14305 (3 hours 58 mins 25 secs)

------------
Name:    lt-in-f100.1e100.net
Address:  108.177.14.100
```
