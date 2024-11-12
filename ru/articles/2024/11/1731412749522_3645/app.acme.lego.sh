#!/usr/bin/env -S bash -eu
# -------------------------------------------------------------------------------------------------------------------- #
# ACME: CERTIFICATE
# Script for generating a certificate using Lego.
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera
# @license    MIT
# @version    0.1.0
# @link       https://lib.onl/ru/2024/11/1f5924fa-7a3d-574e-a15d-8a41208fe10d/
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"; readonly SRC_DIR # Script directory.
SRC_NAME="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"; readonly SRC_NAME # Script name.
SRC_DOMAIN="${1:?}"; readonly SRC_DOMAIN # Domain name.
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf" # Loading main configuration file.
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.${SRC_DOMAIN}.conf" # Loading domain configuration file.

# Environment variables.
export LEGO_PATH="${SRC_DIR:?}"
export LEGO_SERVER="${ACME_SERVER:?}"
export LEGO_PFX_PASSWORD="${ACME_PFX_PASSWORD:?}"
export LEGO_PFX_FORMAT="${ACME_PFX_FORMAT:?}"

# Parameters.
ACME_COMMAND="${2:?}"; readonly ACME_COMMAND
ACME_EMAIL="${ACME_EMAIL:?}"; readonly ACME_EMAIL
ACME_PATH="${ACME_PATH:?}"; readonly ACME_PATH
ACME_METHOD="${ACME_METHOD:?}"; readonly ACME_METHOD
ACME_HTTP_PORT="${ACME_HTTP_PORT:?}"; readonly ACME_HTTP_PORT
ACME_HTTP_PROXY_HEADER="${ACME_HTTP_PROXY_HEADER:?}"; readonly ACME_HTTP_PROXY_HEADER
ACME_HTTP_WEBROOT="${ACME_HTTP_WEBROOT?}"; readonly ACME_HTTP_WEBROOT
ACME_TLS_PORT="${ACME_TLS_PORT:?}"; readonly ACME_TLS_PORT
ACME_KEY_TYPE="${ACME_KEY_TYPE:?}"; readonly ACME_KEY_TYPE
ACME_CRT_TIMEOUT="${ACME_CRT_TIMEOUT:?}"; readonly ACME_CRT_TIMEOUT
ACME_SERVICES=("${ACME_SERVICES[@]:?}"); readonly ACME_SERVICES
ACME_DOMAINS=("${ACME_DOMAINS[@]:?}"); readonly ACME_DOMAINS
ACME_DNS="${ACME_DNS:?}"; readonly ACME_DNS

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION
# -------------------------------------------------------------------------------------------------------------------- #

run() { lego "${ACME_COMMAND}"; }

# -------------------------------------------------------------------------------------------------------------------- #
# LEGO
# Let's Encrypt client and ACME library written in Go.
# -------------------------------------------------------------------------------------------------------------------- #

lego() {
  local command; command="${1}"
  local options
  options=(
    '--accept-tos'
    '--key-type' "${ACME_KEY_TYPE}"
    '--email' "${ACME_EMAIL}"
    '--cert.timeout' "${ACME_CRT_TIMEOUT}"
    '--pem'
    '--pfx'
  )

  case "${ACME_METHOD}" in
    'dns')
      options+=('--dns' "${ACME_DNS}")
      ;;
    'http')
      options+=('--http' '--http.port' "${ACME_HTTP_PORT}" '--http.proxy-header' "${ACME_HTTP_PROXY_HEADER}")
      [[ -n "${ACME_HTTP_WEBROOT}" ]] && options+=('--http.webroot' "${ACME_HTTP_WEBROOT}")
      ;;
    'tls')
      options+=('--tls' '--tls.port' "${ACME_TLS_PORT}")
      ;;
    *)
      echo 'TYPE is not supported!'; exit 1
      ;;
  esac

  for i in "${ACME_DOMAINS[@]}"; do options+=('--domains' "${i}"); done

  if "${SRC_DIR}/lego" "${options[@]}" "${command}"; then
    [[ ! -d "${ACME_PATH}" ]] && mkdir -p "${ACME_PATH}"
    cp -f "${LEGO_PATH}/certificates/"{*.crt,*.key,*.pem,*.pfx} "${ACME_PATH}" \
      && chmod 644 "${ACME_PATH}/"{*.crt,*.key,*.pem,*.pfx}
    for s in "${ACME_SERVICES[@]}"; do _service "${s}" && systemctl reload "${s}"; done
  fi
}

# -------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------< COMMON FUNCTIONS >------------------------------------------------ #
# -------------------------------------------------------------------------------------------------------------------- #

# Checking service availability.
_service() {
  local s; s="${1}"
  { systemctl list-units --full -all | grep -Fq "${s}"; } && return 0
  return 1
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< RUNNING SCRIPT >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

run && exit 0 || exit 1
