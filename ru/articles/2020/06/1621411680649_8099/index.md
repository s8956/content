---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Первая запись'
description: ''
images:
  - 'https://images.unsplash.com/photo-1581043144435-ebcd25885809'
categories:
  - 'blog'
tags:
  - 'misc'
authors:
  - 'KaiKimera'

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2020-06-02T09:20:21+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '6a305138a151d43911d8e2feeed3999186004e22'
uuid: '6a305138-a151-5439-91d8-e2feeed39991'
slug: '6a305138-a151-5439-91d8-e2feeed39991'

draft: 0
---

Привет!

<!--more-->

Это первая запись для тестирования конфигурации и возможностей данного блога. Запись для тестирования функциональности и корректности шаблонов.

```
!
! The MIT License (MIT)
!
! Copyright (c) 2016 Jason Adsit
!
! Permission is hereby granted, free of charge, to any person obtaining a copy
! of this software and associated documentation files (the "Software"), to deal
! in the Software without restriction, including without limitation the rights
! to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
! copies of the Software, and to permit persons to whom the Software is
! furnished to do so, subject to the following conditions:
!
! The above copyright notice and this permission notice shall be included in all
! copies or substantial portions of the Software.
!
! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
! AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
! OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
! SOFTWARE.
!
!
! Email:   jason.l.adsit@gmail.com
! Twitter: @CipherScruples
! WebSite: http://cipher.sexy
! GitHub:  https://github.com/jasonadsit/NetworkDeviceConfigs
!
!
! Project: Basic Cisco Router Configuration
!
! Notes:   Wherever you see variables beginning with "$", replace them with
!          values that are relevant to your environment.
!
!          Comments use the usual Cisco "!" followed by "###" as an eye-catcher.
!
!
version 15.1
service nagle
no service pad
service tcp-keepalives-in
service tcp-keepalives-out
!
service timestamps debug datetime msec localtime show-timezone year
service timestamps log datetime msec localtime show-timezone year
!
! ### Don't forget to secure you passwords in the config!
!
service password-encryption
!
hostname $hostname
!
boot-start-marker
boot system flash $imageFileName.bin
boot-end-marker
!
shell processing full
!
logging userinfo
no logging buffered
logging rate-limit console 2
logging console informational
!
aaa new-model
aaa local authentication attempts max-fail 5
!
aaa authentication login default local
aaa authentication ppp default local
aaa authorization console
aaa authorization exec default local if-authenticated 
aaa authorization commands 15 default local if-authenticated 
aaa authorization network default local if-authenticated 
!
aaa session-id common
!
clock timezone PST -8 0
clock summer-time PDT recurring
!
no ip source-route
!
ip cef
!
! ### Exclude some address space for static use.
!
ip dhcp excluded-address 192.168.1.1 192.168.1.99
ip dhcp excluded-address 192.168.1.200 192.168.1.254
ip dhcp excluded-address 10.4.0.1 10.4.0.99
ip dhcp excluded-address 10.4.0.200 10.4.0.255
!
ip dhcp pool LAN4
 network 192.168.1.0 255.255.255.0
 default-router 192.168.1.1 
 domain-name cipher.sexy
 dns-server 75.75.75.75 8.8.8.8 
!
ip dhcp pool DMZ4
 network 10.4.0.0 255.255.255.0
 default-router 10.4.0.1 
 domain-name cipher.sexy
 dns-server 75.75.75.75 8.8.8.8 
!
no ip bootp server
!
ip domain retry 3
ip domain timeout 2
ip name-server 2001:558:FEED::1
ip name-server 8.8.8.8
ip name-server 75.75.75.75
!
ip multicast-routing 
ip multicast netflow output-counters
ip multicast netflow rpf-failure
!
ipv6 unicast-routing
ipv6 cef
!
! ### The DHCPv6 pool is just for giving hosts ipv6 DNS config.
! ### Addressing for ipv6 is handled by SLAAC
!
ipv6 dhcp pool DHCPv6
 dns-server 2001:4860:4860::8888
 dns-server 2001:558:FEED::2
!
ipv6 multicast-routing
!
password encryption aes
!
! ### For the following archive config to work, you must first create the
! ### directory. (see below)
!
! ### mkdir flash:/backup
!
archive
 log config
  logging enable
  logging size 1000
  hidekeys
 path flash:/backup/
 maximum 14
 rollback filter adaptive
 rollback retry timeout 600
 time-period 10080
!
! ### Object group used to control access to vty lines
! ### Mine is somewhat permissive. I log in from all over.
! ### It's just to keep a few d-bags out :-)
!
object-group network BLACKBALLED 
 host 1.1.1.1
 host 2.2.2.2
!
username $username privilege 15 secret 0 $password
!
! ### Resilient Config rocks
! ### [http://bit.ly/1VKLkAc]
!
secure boot-image
secure boot-config
!
ip ftp source-interface GigabitEthernet0/0.101
ip ftp username $ftpUser
ip ftp password 0 $ftpPassword
!
ip ssh maxstartups 10
ip ssh authentication-retries 5
ip ssh version 2
!
! ### This config was written on IOS 15.1 so we can't turn off keyboard
! ### authentication. If you have newer IOS, disable keyboard auth once
! ### you've set up keys. (see below)
!
! ### ip ssh server authenticate user publickey
! ### no ip ssh server authenticate user keyboard
!
ip ssh pubkey-chain
  username $username
   key-hash ssh-rsa $keyFingerPrint $keyComment
  quit
!
ip scp server enable
! 
interface GigabitEthernet0/0
 no ip address
 duplex auto
 speed auto
!
interface GigabitEthernet0/0.100
 description NATIVE
 encapsulation dot1Q 100 native
!
interface GigabitEthernet0/0.101
 description LAN
 encapsulation dot1Q 101
 ip address 192.168.1.1 255.255.255.0
 ip nat inside
 ip virtual-reassembly in
 ip virtual-reassembly out
 ipv6 address prefix-from-COMCAST ::1/64
 ipv6 enable
 ipv6 nd other-config-flag
 ipv6 dhcp server DHCPv6
!
interface GigabitEthernet0/0.104
 description DMZ
 encapsulation dot1Q 104
 ip address 10.4.0.1 255.255.255.0
 ip nat inside
 ip virtual-reassembly in
 ip virtual-reassembly out
 ipv6 address prefix-from-COMCAST ::1:0:0:0:1/64
 ipv6 enable
 ipv6 nd other-config-flag
 ipv6 dhcp server DHCPv6
!
! ### Took me forever to figure out a working ipv6 config.
! ### I finally got a /60 :-)
!
interface GigabitEthernet0/1
 description COMCAST
 ip address dhcp
 ip nbar protocol-discovery
 ip flow ingress
 ip flow egress
 ip nat outside
 ip virtual-reassembly in
 ip virtual-reassembly out
 duplex auto
 speed auto
 ipv6 address dhcp
 ipv6 enable
 ipv6 dhcp client pd hint ::/60
 ipv6 dhcp client pd prefix-from-COMCAST
 no cdp enable
!
ip forward-protocol nd
ip forward-protocol udp bootpc
no ip http server
no ip http secure-server
!
! ### I don't generally point my end hosts to the router for dns.
! ### This is just in case I need to test something in DNS.
!
ip dns view default
 logging
 domain name cipher.sexy
 domain list cipher.sexy
 domain multicast cipher.sexy
 domain timeout 2
 domain retry 3
 domain name-server  8.8.4.4
 domain resolver source-interface GigabitEthernet0/1
 domain round-robin
 dns forwarder 75.75.75.75
 dns forwarder 8.8.4.4
 dns forwarder 156.154.71.1
 dns forwarding source-interface GigabitEthernet0/1
ip dns server
ip dns spoofing 75.75.75.75
ip pim bidir-enable
!
! ### I hate NAT, but Comcast will only give me one ipv4 address :-(
! ### Maybe someday ipv6 will save us, but I doubt it. People are flawed.
!
ip nat inside source list 1 interface GigabitEthernet0/1 overload
!
! ### Here's one example NAT rule for letting Minecraft through to an internal server.
!
ip nat inside source static tcp 192.168.1.99 25565 interface GigabitEthernet0/1 25565
!
! ### The following static default route is because I'm exchanging routes with
! ### my service provider. If I was, this config would be a lot longer.
!
ip route 0.0.0.0 0.0.0.0 GigabitEthernet0/1
!
! ### This is a static host route to access the web console on my modem. 
!
ip route 192.168.100.1 255.255.255.255 GigabitEthernet0/1
!
!
ip access-list extended VTY_LINES
 deny   ip object-group BLACKBALLED any log
 permit ip any any
!
ip radius source-interface GigabitEthernet0/0.101 
!
logging history size 500
logging origin-id hostname
logging facility syslog
logging source-interface GigabitEthernet0/0.101
!
! ### Define the networks allowed for NAT
!
access-list 1 permit 192.168.1.0 0.0.0.255
access-list 1 permit 10.4.0.0 0.0.0.255
!
! ### My ipv6 default route
! ### This was pointing to a he.net tunnel before Comcast finally
! ### gave me native dual-stack.
! ### Shout-out to Chris Tuska [https://www.linkedin.com/in/christuska]
! ### His forum posts did wonders for my success in getting native ipv6 working.
!
ipv6 route ::/0 GigabitEthernet0/1
!
ipv6 access-list VTY_LINES_V6
 permit ipv6 any any log
!
sip-ua 
 no transport udp
 no transport tcp
!
line con 0
 logging synchronous
line vty 0 15
 access-class VTY_LINES in
 ipv6 access-class VTY_LINES_V6 in
 logging synchronous
 transport input ssh
 transport output ssh
!
ntp source GigabitEthernet0/1
ntp master 3
ntp update-calendar
ntp server 216.66.0.142
ntp server ntp1.glb.nist.gov
ntp server 216.218.254.202
end
!
! ### If you have questions or comments, feel free to hit me up online.
! ### It's by no means flawless. It's just a starting point.
!
! ### Cheers,
!
! ### Jason
!
```

```rpm
%global rawhide_release 41
%global updates_testing_enabled 0

Summary:        Fedora package repositories
Name:           fedora-repos
Version:        41
Release:        0.1%{?eln:.eln%{eln}}
License:        MIT
URL:            https://fedoraproject.org/

Provides:       fedora-repos(%{version}) = %{release}
Requires:       system-release(%{version})
Obsoletes:      fedora-repos < 33-0.7
Obsoletes:      fedora-repos-modular < 39-0.3
%if %{rawhide_release} == %{version}
Requires:       fedora-repos-rawhide = %{version}-%{release}
%endif
Requires:       fedora-gpg-keys >= %{version}-%{release}
BuildArch:      noarch
# Required by %%check
BuildRequires:  gnupg sed rpm

Source1:        archmap
Source2:        fedora.repo
Source3:        fedora-updates.repo
Source4:        fedora-updates-testing.repo
Source5:        fedora-rawhide.repo
Source6:        fedora-cisco-openh264.repo
Source7:        fedora-updates-archive.repo
Source8:        fedora-eln.repo

Source10:       RPM-GPG-KEY-fedora-7-primary
Source11:       RPM-GPG-KEY-fedora-8-primary
Source12:       RPM-GPG-KEY-fedora-8-primary-original
Source13:       RPM-GPG-KEY-fedora-9-primary
Source14:       RPM-GPG-KEY-fedora-9-primary-original
Source15:       RPM-GPG-KEY-fedora-9-secondary
Source16:       RPM-GPG-KEY-fedora-10-primary
Source17:       RPM-GPG-KEY-fedora-11-primary
Source18:       RPM-GPG-KEY-fedora-12-primary
Source19:       RPM-GPG-KEY-fedora-13-primary
Source20:       RPM-GPG-KEY-fedora-13-secondary
Source21:       RPM-GPG-KEY-fedora-14-primary
Source22:       RPM-GPG-KEY-fedora-14-secondary
Source23:       RPM-GPG-KEY-fedora-15-primary
Source24:       RPM-GPG-KEY-fedora-15-secondary
Source25:       RPM-GPG-KEY-fedora-16-primary
Source26:       RPM-GPG-KEY-fedora-16-secondary
Source27:       RPM-GPG-KEY-fedora-17-primary
Source28:       RPM-GPG-KEY-fedora-17-secondary
Source29:       RPM-GPG-KEY-fedora-18-primary
Source30:       RPM-GPG-KEY-fedora-18-secondary
Source31:       RPM-GPG-KEY-fedora-19-primary
Source32:       RPM-GPG-KEY-fedora-19-secondary
Source33:       RPM-GPG-KEY-fedora-20-primary
Source34:       RPM-GPG-KEY-fedora-20-secondary
Source35:       RPM-GPG-KEY-fedora-21-primary
Source36:       RPM-GPG-KEY-fedora-21-secondary
Source37:       RPM-GPG-KEY-fedora-22-primary
Source38:       RPM-GPG-KEY-fedora-22-secondary
Source39:       RPM-GPG-KEY-fedora-23-primary
Source40:       RPM-GPG-KEY-fedora-23-secondary
Source41:       RPM-GPG-KEY-fedora-24-primary
Source42:       RPM-GPG-KEY-fedora-24-secondary
Source43:       RPM-GPG-KEY-fedora-25-primary
Source44:       RPM-GPG-KEY-fedora-25-secondary
Source45:       RPM-GPG-KEY-fedora-26-primary
Source46:       RPM-GPG-KEY-fedora-26-secondary
Source47:       RPM-GPG-KEY-fedora-27-primary
Source48:       RPM-GPG-KEY-fedora-28-primary
Source49:       RPM-GPG-KEY-fedora-29-primary
Source50:       RPM-GPG-KEY-fedora-30-primary
Source51:       RPM-GPG-KEY-fedora-31-primary
Source52:       RPM-GPG-KEY-fedora-32-primary
Source53:       RPM-GPG-KEY-fedora-33-primary
Source54:       RPM-GPG-KEY-fedora-34-primary
Source55:       RPM-GPG-KEY-fedora-35-primary
Source56:       RPM-GPG-KEY-fedora-36-primary
Source57:       RPM-GPG-KEY-fedora-37-primary
Source58:       RPM-GPG-KEY-fedora-38-primary
Source59:       RPM-GPG-KEY-fedora-39-primary
Source60:       RPM-GPG-KEY-fedora-40-primary
Source61:       RPM-GPG-KEY-fedora-41-primary
Source62:       RPM-GPG-KEY-fedora-42-primary

# When bumping Rawhide to fN, create N+1 key (and update archmap). (This
# ensures users have the next future key installed and referenced, even if they
# don't update very often. This will smooth out Rawhide N->N+1 transition for them).

Source150:      RPM-GPG-KEY-fedora-iot-2019
Source151:      fedora.conf
Source152:      fedora-compose.conf

# ima certs
Source500:      fedora-38-ima.cert
Source501:      fedora-38-ima.der
Source502:      fedora-38-ima.pem
Source503:      fedora-39-ima.cert
Source504:      fedora-39-ima.der
Source505:      fedora-39-ima.pem

%description
Fedora package repository files for yum and dnf along with gpg public keys.

%package rawhide
Summary:        Rawhide repo definitions
Requires:       fedora-repos = %{version}-%{release}
Obsoletes:      fedora-repos-rawhide < 33-0.7
Obsoletes:      fedora-repos-rawhide-modular < 39-0.3

%description rawhide
This package provides the rawhide repo definitions.

%package archive
Summary:        Fedora updates archive package repository
Requires:       fedora-repos = %{version}-%{release}

%description archive
This package provides the repo definition for the updates archive repo.
It is a package repository that contains any RPM that has made it to
stable in Bodhi and been available in the Fedora updates repo in the past.

%package -n fedora-gpg-keys
Summary:        Fedora RPM keys
Requires:       filesystem >= 3.18-6

%description -n fedora-gpg-keys
This package provides the RPM signature keys.


%package ostree
Summary:        OSTree specific files

%description ostree
This package provides ostree specfic files like remote config from
where client's system will pull OSTree updates.


%package eln
Summary:        ELN repo definitions
Requires:       fedora-gpg-keys >= %{version}-%{release}
Requires:       system-release(%{version})

%description eln
This package provides repository files for ELN (Enterprise Linux Next)
packages. Note that these packages are experimental and should not be used
in a production environment.


%prep

%build

%install
# Install the keys
install -d -m 755 $RPM_BUILD_ROOT/etc/pki/rpm-gpg
install -m 644 %{_sourcedir}/RPM-GPG-KEY* $RPM_BUILD_ROOT/etc/pki/rpm-gpg/

# Link the primary/secondary keys to arch files, according to archmap.
# Ex: if there's a key named RPM-GPG-KEY-fedora-19-primary, and archmap
#     says "fedora-19-primary: i386 x86_64",
#     RPM-GPG-KEY-fedora-19-{i386,x86_64} will be symlinked to that key.
pushd $RPM_BUILD_ROOT/etc/pki/rpm-gpg/
# Also add a symlink for Rawhide and ELN keys
ln -s RPM-GPG-KEY-fedora-%{rawhide_release}-primary RPM-GPG-KEY-fedora-rawhide-primary
ln -s RPM-GPG-KEY-fedora-%{rawhide_release}-primary RPM-GPG-KEY-fedora-eln-primary
for keyfile in RPM-GPG-KEY*; do
    # resolve symlinks, so that we don't need to keep duplicate entries in archmap
    real_keyfile=$(basename $(readlink -f $keyfile))
    key=${real_keyfile#RPM-GPG-KEY-} # e.g. 'fedora-20-primary'
    if ! grep -q "^${key}:" %{_sourcedir}/archmap; then
        echo "ERROR: no archmap entry for $key"
        exit 1
    fi
    arches=$(sed -ne "s/^${key}://p" %{_sourcedir}/archmap)
    for arch in $arches; do
        # replace last part with $arch (fedora-20-primary -> fedora-20-$arch)
        ln -s $keyfile ${keyfile%%-*}-$arch # NOTE: RPM replaces %% with %
    done
done
# and add symlink for compat generic location
ln -s RPM-GPG-KEY-fedora-%{version}-primary RPM-GPG-KEY-%{version}-fedora
popd

# Install the ima keys
install -d -m 755 $RPM_BUILD_ROOT/etc/keys/ima
install -m 644 %{_sourcedir}/fedora*ima.* $RPM_BUILD_ROOT/etc/keys/ima/

# Install repo files
install -d -m 755 $RPM_BUILD_ROOT/etc/yum.repos.d
for file in %{_sourcedir}/fedora*repo ; do
  install -m 644 $file $RPM_BUILD_ROOT/etc/yum.repos.d
done

# Enable or disable repos based on current release cycle state.
%if 0%{?eln}
rawhide_enabled=0
stable_enabled=0
testing_enabled=0
archive_enabled=0
eln_enabled=1
%elif %{rawhide_release} == %{version}
rawhide_enabled=1
stable_enabled=0
testing_enabled=0
archive_enabled=0
eln_enabled=0
%else
rawhide_enabled=0
stable_enabled=1
testing_enabled=%{updates_testing_enabled}
archive_enabled=1
eln_enabled=0
%endif
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora-rawhide*.repo; do
    sed -i "s/^enabled=AUTO_VALUE$/enabled=${rawhide_enabled}/" $repo || exit 1
done
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora{,-updates}.repo; do
    sed -i "s/^enabled=AUTO_VALUE$/enabled=${stable_enabled}/" $repo || exit 1
done
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora-updates-testing.repo; do
    sed -i "s/^enabled=AUTO_VALUE$/enabled=${testing_enabled}/" $repo || exit 1
done
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora-updates-archive.repo; do
    sed -i "s/^enabled=AUTO_VALUE$/enabled=${archive_enabled}/" $repo || exit 1
done
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora-eln*.repo; do
    sed -i "s/^enabled=AUTO_VALUE$/enabled=${eln_enabled}/" $repo || exit 1
done

# Adjust Rawhide repo files to include Rawhide+1 GPG key.
# This is necessary for the period when Rawhide gets bumped to N+1 and packages
# start to be signed with a newer key. Without having the key specified in the
# repo file, the system would consider the new packages as untrusted.
rawhide_next=$((%{rawhide_release}+1))
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora-rawhide*.repo; do
    sed -i "/^gpgkey=/ s@AUTO_VALUE@file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-${rawhide_next}-\$basearch@" \
        $repo || exit 1
done

# Set appropriate metadata_expire in base repo files (6h before Final, 7d after)
%if "%{release}" < "1"
expire_value='6h'
%else
expire_value='7d'
%endif
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora.repo; do
    sed -i "/^metadata_expire=/ s/AUTO_VALUE/${expire_value}/" \
        $repo || exit 1
done

# Install ostree remote config
install -d -m 755 $RPM_BUILD_ROOT/etc/ostree/remotes.d/
install -m 644 %{_sourcedir}/fedora.conf $RPM_BUILD_ROOT/etc/ostree/remotes.d/
install -m 644 %{_sourcedir}/fedora-compose.conf $RPM_BUILD_ROOT/etc/ostree/remotes.d/


%check
# Make sure all repo variables were substituted
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/*.repo; do
    if grep -q AUTO_VALUE $repo; then
        echo "ERROR: Repo $repo contains an unsubstituted placeholder value"
        exit 1
    fi
done

# Make sure correct repos were enabled/disabled
enabled_repos=()
disabled_repos=()

%if 0%{?eln}
enabled_repos+=(fedora-eln)
disabled_repos+=(fedora fedora-updates fedora-updates-archive \
  fedora-updates-testing)
%elif %{rawhide_release} == %{version}
enabled_repos+=(fedora-rawhide fedora-cisco-openh264)
disabled_repos+=(fedora fedora-updates fedora-updates-archive \
  fedora-updates-testing)
%else
enabled_repos+=(fedora fedora-updates fedora-updates-archive)
disabled_repos+=(fedora-rawhide)
%if %{updates_testing_enabled}
enabled_repos+=(fedora-updates-testing)
%else
disabled_repos+=(fedora-updates-testing)
%endif
%endif

for repo in ${enabled_repos[@]}; do
    if ! grep -q 'enabled=1' $RPM_BUILD_ROOT/etc/yum.repos.d/${repo}.repo; then
        echo "ERROR: Repo $repo should have been enabled, but it isn't"
        exit 1
    fi
done
for repo in ${disabled_repos[@]}; do
    if grep -q 'enabled=1' $RPM_BUILD_ROOT/etc/yum.repos.d/${repo}.repo; then
        echo "ERROR: Repo $repo should have been disabled, but it isn't"
        exit 1
    fi
done

# Make sure updates-testing is not enabled in a Final (stable) release
%if "%{release}" >= "1"
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora-updates-testing.repo; do
    if grep -q 'enabled=1' $repo; then
        echo "ERROR: Repo $repo should be disabled in a stable release, but it isn't"
        exit 1
    fi
done
%endif

# Make sure metadata_expire was correctly set
%if "%{release}" < "1"
expire_value='6h'
%else
expire_value='7d'
%endif
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora.repo; do
    lines=$(grep '^metadata_expire=' $repo | sort | uniq)
    if [ "$(echo "$lines" | wc -l)" -ne 1 ]; then
        echo "ERROR: Non-matching metadata_expire lines in $repo: $lines"
        exit 1
    fi
    if test "$lines" != "metadata_expire=${expire_value}"; then
        echo "ERROR: Wrong metadata_expire value in $repo: $lines"
        exit 1
    fi
done

# Make sure the Rawhide+1 key wasn't forgotten to be created
rawhide_next=$((%{rawhide_release}+1))
test -n "$rawhide_next" || exit 1
if ! test -f $RPM_BUILD_ROOT/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-${rawhide_next}-primary; then
    echo "ERROR: GPG key for Fedora ${rawhide_next} is not present"
    exit 1
fi

# Make sure the Rawhide+1 key is present in Rawhide repo files
for repo in $RPM_BUILD_ROOT/etc/yum.repos.d/fedora-rawhide*.repo; do
    gpg_lines=$(grep '^gpgkey=' $repo)
    if test -z "$gpg_lines"; then
        echo "ERROR: No gpgkey= lines in $repo"

        exit 1
    fi
    while IFS= read -r line; do
        if ! echo "$line" | grep -q "RPM-GPG-KEY-fedora-${rawhide_next}"; then
            echo "ERROR: Fedora ${rawhide_next} GPG key missing in $repo"
            exit 1
        fi
    done <<< "$gpg_lines"
done

# Check arch keys exists on supported architectures, and RPM considers
# them valid
TMPRING=$(mktemp)
DBPATH=$(mktemp -d)
for VER in %{version} %{rawhide_release} ${rawhide_next}; do
  echo -n > "$TMPRING"
  for ARCH in $(sed -ne "s/^fedora-${VER}-primary://p" %{_sourcedir}/archmap)
  do
    gpg --no-default-keyring --keyring="$TMPRING" \
      --import $RPM_BUILD_ROOT%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-fedora-$VER-$ARCH
    rpm --dbpath "$DBPATH" --import $RPM_BUILD_ROOT%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-fedora-$VER-$ARCH --test
  done
  # Ensure some arch key was imported
  gpg --no-default-keyring --keyring="$TMPRING" --list-keys | grep -A 2 '^pub\s'
done
rm -f "$TMPRING"

%files
%dir /etc/yum.repos.d
%config(noreplace) /etc/yum.repos.d/fedora.repo
%config(noreplace) /etc/yum.repos.d/fedora-cisco-openh264.repo
%config(noreplace) /etc/yum.repos.d/fedora-updates.repo
%config(noreplace) /etc/yum.repos.d/fedora-updates-testing.repo

%files archive
%config(noreplace) /etc/yum.repos.d/fedora-updates-archive.repo

%files rawhide
%config(noreplace) /etc/yum.repos.d/fedora-rawhide.repo


%files -n fedora-gpg-keys
%dir /etc/pki/rpm-gpg
/etc/pki/rpm-gpg/RPM-GPG-KEY-*
/etc/keys/ima/fedora*ima*


%files ostree
%dir /etc/ostree/remotes.d/
/etc/ostree/remotes.d/fedora.conf
/etc/ostree/remotes.d/fedora-compose.conf

%files eln
%config(noreplace) /etc/yum.repos.d/fedora-eln.repo


%changelog
* Tue Feb 13 2024 Samyak Jain <samyak.jn11@gmail.com> - 41-0.1
- Setup for rawhide being F41

* Wed Sep 27 2023 Sandro Bonazzola <sbonazzo@redhat.com> - 40-0.2
- Allow ELN installation without Rawhide repos

* Tue Aug 08 2023 Samyak Jain <samyak.jn11@gmail.com> - 40-0.1
- Setup for rawhide being F40

* Fri Jul 21 2023 Peter Robinson <pbrobinson@fedoraproject.org> - 39-0.4
- Update IMA keys location for kernel/dracut

* Mon Jul 10 2023 Miro Hrončok <mhroncok@redhat.com> - 39-0.3
- Drop fedora-repos-modular and fedora-repos-rawhide-modular packages
- https://fedoraproject.org/wiki/Changes/RetireModularity

* Sat Feb 18 2023 Kevin Fenzi <kevin@scrye.com> - 39-0.2
- Include IMA public certs.

* Wed Feb 08 2023 Tomas Hrcka <thrcka@redhat.com> - 39-0.1
- Setup for rawhide being F39

* Wed Jan 25 2023 Tomas Hrcka <thrcka@redhat.com> - 38-0.4
- Add RPM-GPG-KEY-fedora-40-primary

* Tue Aug 16 2022 Adam Williamson <awilliam@redhat.com> - 38.0-3
- Fix RPM-GPG-KEY-fedora-39-primary (dustymabe)

* Tue Aug 09 2022 Tomas Hrcka <thrcka@redhat.com> - 38-0.2
- Drop armhfp from archmap on f38,f39

* Tue Aug 09 2022 Tomas Hrcka <thrcka@redhat.com> - 38-0.1
- Setup for rawhide being F38
- Adding F39 key

* Wed Jun 08 2022 Stephen Gallagher <sgallagh@redhat.com> - 37-0.3
- ELN: don't enable layered product repos by default

* Wed May 25 2022 Stephen Gallagher <sgallagh@redhat.com> - 37-0.2
- Rework Fedora ELN repositories

* Tue Feb 08 2022 Tomas Hrcka <thrcka@redhat.com> - 37-0.1
- Setup for rawhide being F37
- Adding F38 key

* Tue Aug 17 2021 Tomas Hrcka <thrcka@redhat.com> - 36-0.3
- Remove spurious space in RPM-GPG-KEY-fedora-37-primary (cgwalters)

* Tue Aug 10 2021 Tomas Hrcka <thrcka@redhat.com> - 36-0.2
- Setup for rawhide being F36

* Wed Apr 28 2021 Dusty Mabe <dusty@dustymabe.com> - 35-0.4
- Enable the updates archive repo on non-rawhide.

* Fri Feb 19 2021 Petr Menšík <pemensik@redhat.com> - 35-0.3
- Check arch key imports during build (#1872248)

* Wed Feb 17 2021 Mohan Boddu <mboddu@bhujji.com> - 35-0.2
- Support $releasever=rawhide on Rawhide (kparal)
- Make archmap entries mandatory, except symlinks (kparal)
- Fixing F36 key

* Tue Feb 09 2021 Tomas Hrcka <thrcka@redhat.com> - 35-0.1
- Setup for rawhide being F35

* Tue Feb 09 2021 Mohan Boddu <mboddu@bhujji.com> - 34-0.10
- Fixing archmap for F35

* Thu Feb 04 2021 Mohan Boddu <mboddu@bhujji.com> - 34-0.9
- Adding F35 key

* Wed Oct 14 2020 Stephen Gallagher <sgallagh@redhat.com> - 34-0.8
- ELN: Drop dependency on fedora-repos-rawhide-modular

* Tue Oct 13 2020 Stephen Gallagher <sgallagh@redhat.com> - 34-0.7
- Ensure that the ELN GPG key always points at the Rawhide key

* Tue Oct 13 2020 Stephen Gallagher <sgallagh@redhat.com> - 34-0.6
- Drop the fedora-eln-modular.repo

* Thu Oct 08 2020 Stephen Gallagher <sgallagh@redhat.com> - 34-0.5
- Update the ELN repos for the BaseOS and AppStream split

* Mon Oct 05 2020 Dusty Mabe <dusty@dustymabe.com> - 34-0.4
- Add the fedora-repos-archive subpackage.

* Fri Aug 21 2020 Miro Hrončok <mhroncok@redhat.com> - 34-0.3
- Fix a copy-paste error in eln repo name
- Drop fedora-modular from base package since it's in the modular subpackage
- Fixes: rhbz#1869150

* Wed Aug 19 2020 Stephen Gallagher <sgallagh@redhat.com> - 34-0.2
- Enable rebuilding of fedora-repos in ELN
- Drop unused modularity-specific release information

* Mon Aug 10 2020 Tomas Hrcka <thrcka@redhat.com> - 34-0.1
- Setup for rawhide being F34

* Thu Aug 06 2020 Mohan Boddu <mboddu@bhujji.com> - 33-0.9
- Adding F34 key

* Tue Jun 30 2020 Stephen Gallagher <sgallagh@redhat.com> - 33-0.8
- Add optional repositories for ELN

* Mon Jun 29 21:10:15 CEST 2020 Igor Raits <ignatenkobrain@fedoraproject.org> - 33-0.7
- Split modular repos to the separate packages

* Mon Jun 01 2020 Dusty Mabe <dusty@dustymabe.com> - 33-0.6
- Add fedora compose ostree repo to fedora-repos-ostree

* Mon Apr 13 2020 Stephen Gallagher <sgallagh@redhat.com> - 33-0.5
- Add the release to the fedora-repos(NN) Provides:

* Thu Apr 09 2020 Kalev Lember <klember@redhat.com> - 33-0.4
- Switch to metalink for fedora-cisco-openh264 and disable repo gpgcheck
  (#1768206)
- Use the same metadata_expire time for fedora-cisco-openh264 and -debuginfo
- Remove enabled_metadata key for fedora-cisco-openh264

* Sat Feb 22 2020 Neal Gompa <ngompa13@gmail.com> - 33-0.3
- Enable fedora-cisco-openh264 repo by default

* Wed Feb 19 2020 Adam Williamson <awilliam@redhat.com> - 33-0.2
- Restore baseurl lines, but with example domain

* Tue Feb 11 2020 Mohan Boddu <mboddu@bhujji.com> - 33-0.1
- Setup for rawhide being F33

* Tue Feb 11 2020 Mohan Boddu <mboddu@bhujji.com> - 32-0.4
- Remove baseurl download.fp.o (puiterwijk)
- Enabling dnf countme

* Tue Jan 28 2020 Mohan Boddu <mboddu@bhujji.com> - 32-0.3
- Adding F33 key

* Mon Aug 19 2019 Kevin Fenzi <kevin@scrye.com> - 32-0.2
- Fix f32 key having extra spaces.

* Tue Aug 13 2019 Mohan Boddu <mboddu@bhujji.com> - 32-0.1
- Adding F32 key
- Setup for rawhide being f32

* Tue Mar 12 2019 Vít Ondruch <vondruch@redhat.com> - 31-0.3
- Allow to use newer GPG keys, so Rawhide can be updated after branch.

* Thu Mar 07 2019 Sinny Kumari <skumari@redhat.com> - 31-0.2
- Create fedora-repos-ostree sub-package

* Tue Feb 19 2019 Tomas Hrcka <thrcka@redhat.com> - 31-0.1
- Setup for rawhide being f31

* Mon Feb 18 2019 Mohan Boddu <mboddu@bhujji.com> - 30-0.4
- Adding F31 key

* Sat Jan 05 2019 Kevin Fenzi <kevin@scrye.com> - 30-0.3
- Add fedora-7-primary to archmap. Fixes bug #1531957
- Remove failovermethod option in repos (augenauf(Florian H))

* Tue Nov 13 2018 Mohan Boddu <mboddu@bhujji.com> - 30-0.2
- Adding fedora-iot-2019 key
- Enable skip_if_unavailable for cisco-openh264 repo

* Tue Aug 14 2018 Mohan Boddu <mboddu@bhujji.com> - 30-0.1
- Setup for rawhide being f30
```
