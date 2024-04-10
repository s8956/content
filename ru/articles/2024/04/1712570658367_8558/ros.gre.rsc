# @package    MikroTik / RouterOS / GRE
# @author     Kai Kimera <mail@kai.kim>
# @copyright  2024 Library Online
# @license    MIT
# @version    0.1.0
# @link       https://lib.onl/ru/articles/2024/04/326618af-d950-5001-8114-57c66bb8a5af/
# -------------------------------------------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------------------------------------------- #
# Общие настройки.
# -------------------------------------------------------------------------------------------------------------------- #

# Название интерфейса GRE локального маршрутизатора.
:local greName "gre-gw1-gw2"

# Секретная фраза IPsec.
:local ipsSecret "PassWord"

# -------------------------------------------------------------------------------------------------------------------- #
# Локальный маршрутизатор.
# -------------------------------------------------------------------------------------------------------------------- #

# Внешний IP-адрес локального маршрутизатора в интернете.
:local greLocalWanIP "1.1.1.1"

# IP-адрес интерфейса GRE локального маршрутизатора.
:local greLocalInterfaceIP "10.255.255.1/24"

# Адрес сети GRE локального маршрутизатора.
:local greLocalNetwork "10.255.255.0"

# -------------------------------------------------------------------------------------------------------------------- #
# Удалённый маршрутизатор.
# -------------------------------------------------------------------------------------------------------------------- #

# Внешний IP-адрес удалённого маршрутизатора в интернете.
:local greRemoteWanIP "2.2.2.2"

# IP-адрес интерфейса GRE удалённого маршрутизатора.
:local greRemoteInterfaceIP "10.255.255.2"

# Адрес сети удалённого маршрутизатора.
:local greRemoteNetwork "10.2.0.0/16"

# Название домена удалённого маршрутизатора.
:local greRemoteHost "gw2.example.com"

# -------------------------------------------------------------------------------------------------------------------- #

/interface gre add allow-fast-path=no ipsec-secret="$ipsSecret" name="$greName" \
  local-address=$greLocalWanIP remote-address=$greRemoteWanIP \
  comment="HOST: $greRemoteHost"

/ip address add address=$greLocalInterfaceIP interface="$greName" network=$greLocalNetwork \
  comment="[GRE] $greName"

/ip route add distance=1 dst-address=$greRemoteNetwork gateway=$greRemoteInterfaceIP \
  comment="[GRE] HOST: $greRemoteHost"
