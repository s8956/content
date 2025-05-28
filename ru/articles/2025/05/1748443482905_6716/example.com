$TTL 3600
;
@                 IN  SOA     example.com. postmaster.example.com. (
                              2024061000  ; Serial
                              1h          ; Refresh
                              10m         ; Retry
                              1d          ; Expire
                              1h )        ; Negative Cache TTL
;
@                 IN  NS      ns01.example.com.
@                 IN  NS      ns02.example.com.
@                 IN  A       192.168.1.2
@                 IN  MX  10  mail.example.com.
ns01              IN  A       192.168.1.2
ns02              IN  A       192.168.1.2
mail              IN  A       192.168.1.2
;
@                 IN  TXT     "v=spf1 ip4:192.168.1.2 ~all"
_dmarc            IN  TXT     "v=DMARC1;p=none;ruf=mailto:postmaster@example.com;aspf=r;pct=100;rua=mailto:postmaster@example.com"
dkim._domainkey   IN  TXT     ("v=DKIM1; p=")
