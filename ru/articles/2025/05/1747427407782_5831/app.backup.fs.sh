#!/usr/bin/env -S bash -eu
# -------------------------------------------------------------------------------------------------------------------- #
#
#
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera
# @license    MIT
# @version    0.1.0
# @link
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )" # Source directory.
SRC_NAME="$( basename "$( readlink -f "${BASH_SOURCE[0]}" )" )" # Source name.
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf" # Loading configuration file.

# Parameters.
FS_SRC=("${FS_SRC[@]}"); readonly FS_SRC
FS_DST="${FS_DST:?}"; readonly FS_DST
ENC_PASS="${ENC_PASS:?}"; readonly ENC_PASS
SYNC_ON="${SYNC_ON:?}"; readonly SYNC_ON
SYNC_HOST="${SYNC_HOST:?}"; readonly SYNC_HOST
SYNC_USER="${SYNC_USER:?}"; readonly SYNC_USER
SYNC_PASS="${SYNC_PASS:?}"; readonly SYNC_PASS
SYNC_DST="${SYNC_DST:?}"; readonly SYNC_DST
SYNC_DEL="${SYNC_DEL:?}"; readonly SYNC_DEL
SYNC_RSF="${SYNC_RSF:?}"; readonly SYNC_RSF
SYNC_PED="${SYNC_PED:?}"; readonly SYNC_PED
SYNC_CVS="${SYNC_CVS:?}"; readonly SYNC_CVS

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION
# -------------------------------------------------------------------------------------------------------------------- #

run() { backup && sync && clean; }

# -------------------------------------------------------------------------------------------------------------------- #
# FS: BACKUP
# -------------------------------------------------------------------------------------------------------------------- #

backup() {
  local ts; ts="$( _timestamp )"
  local tree; tree="${FS_DST}/$( _tree )"
  local file; file="$( hostname -f ).${ts}.tar.xz.gpg"
  for i in "${!FS_SRC[@]}"; do [[ -e "${FS_SRC[i]}" ]] || unset 'FS_SRC[i]'; done
  [[ ! -d "${tree}" ]] && mkdir -p "${tree}"; cd "${tree}" || _err "Directory '${tree}' not found!"
  tar -cf - "${FS_SRC[@]}" | xz | _enc "${tree}/${file}" && _sum "${tree}/${file}"
}

# -------------------------------------------------------------------------------------------------------------------- #
# FS: SYNC
# Sending file system backup to remote storage.
# -------------------------------------------------------------------------------------------------------------------- #

sync() {
  (( ! "${SYNC_ON}" )) && return 0
  local opts; opts=('--archive' '--quiet')
  (( "${SYNC_DEL}" )) && opts+=('--delete')
  (( "${SYNC_RSF}" )) && opts+=('--remove-source-files')
  (( "${SYNC_PED}" )) && opts+=('--prune-empty-dirs')
  (( "${SYNC_CVS}" )) && opts+=('--cvs-exclude')
  rsync "${opts[@]}" -e "sshpass -p '${SYNC_PASS}' ssh -p ${SYNC_PORT:-22}" \
    "${FS_DST}/" "${SYNC_USER:-root}@${SYNC_HOST}:${SYNC_DST}/"
}

# -------------------------------------------------------------------------------------------------------------------- #
# FS: CLEAN
# Cleaning the file system.
# -------------------------------------------------------------------------------------------------------------------- #

clean() {
  find "${FS_DST}" -type 'f' -mtime "+${FS_DAYS:-30}" -print0 | xargs -0 rm -f --
  find "${FS_DST}" -mindepth 1 -type 'd' -not -name 'lost+found' -empty -delete
}

# -------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------< COMMON FUNCTIONS >------------------------------------------------ #
# -------------------------------------------------------------------------------------------------------------------- #

_timestamp() {
  date -u '+%Y-%m-%d.%H-%M-%S'
}

_tree() {
  echo "$( date -u '+%Y' )/$( date -u '+%m' )/$( date -u '+%d' )"
}

_enc() {
  local out; out="${1}"
  local pass; pass="${ENC_PASS}"
  gpg --batch --passphrase "${pass}" --symmetric --output "${out}" \
    --s2k-cipher-algo "${ENC_S2K_CIPHER:-AES256}" \
    --s2k-digest-algo "${ENC_S2K_DIGEST:-SHA512}" \
    --s2k-count "${ENC_S2K_COUNT:-65536}"
}

_sum() {
  local in; in="${1}"
  local out; out="${in}.sum"
  sha256sum "${in}" | sed 's| .*/|  |g' | tee "${out}" > '/dev/null'
}

_err() {
  echo >&2 "[$( date +'%Y-%m-%dT%H:%M:%S%z' )]: $*"; exit 1
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< RUNNING SCRIPT >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

run && exit 0 || exit 1
