$TTL 86400
;
@                 IN  SOA     ns01.example.com. root.example.com. (
                              2024061000  ; Serial
                              10m         ; Refresh
                              1h          ; Retry
                              1w          ; Expire
                              6m )        ; Negative Cache TTL
; NS
@                 IN  NS      ns01.example.com.
@                 IN  NS      ns02.example.com.
ns01              IN  A       192.168.1.2
ns02              IN  A       192.168.1.3
; MAIN
@                 IN  A       192.168.1.5
www               IN  CNAME   @
; MX
@                 IN  MX  10  mail.example.com.
mail              IN  A       192.168.1.6
; TXT
@                 IN  TXT     "v=spf1 include:_spf.google.com include:_spf.yandex.net include:_spf.mail.ru ~all"
_dmarc            IN  TXT     "v=DMARC1; p=none; rua=mailto:postmaster@example.com; ruf=mailto:postmaster@example.com; adkim=r; aspf=r"
dkim._domainkey   IN  TXT     "v=DKIM1; p=TOKEN"
