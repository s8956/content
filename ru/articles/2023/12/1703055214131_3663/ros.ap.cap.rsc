# @package    MikroTik / RouterOS
# @author     z17CX <mail@z17.cx>
# @copyright  2023 Library Online
# @license    MIT
# @version    0.1.0
# @link
# -------------------------------------------------------------------------------------------------------------------- #

/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh port=22022
set api disabled=yes
set winbox port=9090
set api-ssl disabled=yes

/system clock
set time-zone-name=Europe/Moscow

/system identity
set name="GW-AP01"

/system ntp client
set enabled=yes

/system ntp server
set enabled=yes manycast=yes multicast=yes

/system ntp client servers
add address=time.cloudflare.com

/tool bandwidth-server
set enabled=no

/tool mac-server
set allowed-interface-list=none

/tool mac-server ping
set enabled=no

/user
set [find name="admin"] password="cDFymu2aML"
