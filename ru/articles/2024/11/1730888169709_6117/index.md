---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Jigasi: The following addresses failed: RFC 6120 A/AAAA Endpoint'
description: ''
images:
  - 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a'
categories:
  - 'linux'
  - 'network'
tags:
  - 'jigasi'
  - 'jitsi'
  - 'systemd'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-11-06T13:16:13+03:00'
publishDate: '2024-11-06T13:16:13+03:00'
lastMod: '2024-11-06T13:16:13+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '45ffdbeb37ec3ed2d3cd347df5e3d07b660573da'
uuid: '45ffdbeb-37ec-5ed2-b3cd-347df5e3d07b'
slug: '45ffdbeb-37ec-5ed2-b3cd-347df5e3d07b'

draft: 1
---



<!--more-->

После перезагрузки сервера, **Jigasi** не может приглашать локальные телефоны. Ошибка:

```terminal
cat /var/log/jitsi/jicofo.log

2024-11-05 11:36:06.116 INFO: [33] SipGateway.registrationStateChanged#120: REG STATE CHANGE ProtocolProviderServiceSipImpl(SIP:5154@172.17.12.12) -> RegistrationStateChangeEvent[ oldState=Unregistered; newState=RegistrationState=Registering; userRequest=false; reasonCode=-1; reason=null]
2024-11-05 11:36:06.179 INFO: [43] SipGateway.registrationStateChanged#120: REG STATE CHANGE ProtocolProviderServiceSipImpl(SIP:5154@172.17.12.12) -> RegistrationStateChangeEvent[ oldState=Registering; newState=RegistrationState=Registered; userRequest=false; reasonCode=-1; reason=null]
2024-11-05 11:36:06.180 WARNING: [43] SipHealthPeriodicChecker.create#170: No health check started, no HEALTH_CHECK_SIP_URI prop.
2024-11-05 11:36:06.231 SEVERE: [40] net.java.sip.communicator.impl.protocol.jabber.ProtocolProviderServiceJabberImpl.connectAndLogin: Failed to connect to XMPP service for:ProtocolProviderServiceJabberImpl(Jabber:jigasi@auth.cf.vpostal.ru)
org.jivesoftware.smack.SmackException$EndpointConnectionException: The following addresses failed: 'RFC 6120 A/AAAA Endpoint + [127.0.0.1/127.0.0.1:5222] (127.0.0.1/127.0.0.1:5222)' failed because: java.net.ConnectException: Connection refused
        at org.jivesoftware.smack.SmackException$EndpointConnectionException.from(SmackException.java:334)
        at org.jivesoftware.smack.tcp.XMPPTCPConnection.connectUsingConfiguration(XMPPTCPConnection.java:664)
        at org.jivesoftware.smack.tcp.XMPPTCPConnection.connectInternal(XMPPTCPConnection.java:849)
        at org.jivesoftware.smack.AbstractXMPPConnection.connect(AbstractXMPPConnection.java:525)
        at net.java.sip.communicator.impl.protocol.jabber.ProtocolProviderServiceJabberImpl.connectAndLogin(ProtocolProviderServiceJabberImpl.java:1307)
        at net.java.sip.communicator.impl.protocol.jabber.ProtocolProviderServiceJabberImpl.connectAndLogin(ProtocolProviderServiceJabberImpl.java:967)
        at net.java.sip.communicator.impl.protocol.jabber.ProtocolProviderServiceJabberImpl.initializeConnectAndLogin(ProtocolProviderServiceJabberImpl.java:792)
        at net.java.sip.communicator.impl.protocol.jabber.ProtocolProviderServiceJabberImpl.register(ProtocolProviderServiceJabberImpl.java:494)
        at org.jitsi.jigasi.util.RegisterThread.run(RegisterThread.java:59)
2024-11-05 11:36:36.255 WARNING: [14] org.jivesoftware.smackx.ping.PingManager.pingServerIfNecessary: XMPPTCPConnection[not-authenticated] (0) was not authenticated
```

Возможно, Jigasi запускается раньше других сервисов. Чтобы Jigasi запустился в необходимое время, был написан unit-переопределитель стандартной конфигурации **systemd**. Создаём файл `/etc/systemd/system/jigasi.service.d/override.conf` со строками:

```ini
[Unit]
After=jitsi-videobridge2.service
```

Таким образом, переменную `After` из стандартной конфигурации Jigasi мы переопределяем на свою и говорим Jigasi, чтобы та ждала загрузки unit'а `jitsi-videobridge2.service` и только после этого сама запускалась.

Сам же unit `jitsi-videobridge2.service` содержит такие строки:

```ini
[Unit]
Description=Jitsi Videobridge
After=network-online.target
Wants=network-online.target
```

Согласно переменным `After=network-online.target` и `Wants=network-online.target`, unit ждёт активности сети и после этого загружается.

Объединив всё это, получаем цепочку последовательных, зависимых друг от друга, вызовов:

1. Активность сети.
2. Модуль `jitsi-videobridge2.service`.
3. Модуль `jigasi.service`.