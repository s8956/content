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
FS_ON="${FS_ON:?}"; readonly FS_ON
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
MAIL_ON="${MAIL_ON:?}"; readonly MAIL_ON
MAIL_TO="${MAIL_TO:?}"; readonly MAIL_TO

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION
# -------------------------------------------------------------------------------------------------------------------- #

run() {
  (( ! "${FS_ON}" )) && return 0
  fs_backup && fs_sync && fs_clean
}

# -------------------------------------------------------------------------------------------------------------------- #
# FS: BACKUP
# -------------------------------------------------------------------------------------------------------------------- #

fs_backup() {
  local ts; ts="$( _timestamp )"
  local dir; dir="${FS_DST}/$( _dir )"
  local file; file="$( hostname -f ).${ts}.tar.xz.enc"
  for i in "${!FS_SRC[@]}"; do [[ -e "${FS_SRC[i]}" ]] || unset 'FS_SRC[i]'; done
  [[ ! -d "${dir}" ]] && mkdir -p "${dir}"; cd "${dir}" || exit 1
  tar -cf - "${FS_SRC[@]}" | xz | _enc "${dir}/${file}" && _sum "${dir}/${file}"
}

# -------------------------------------------------------------------------------------------------------------------- #
# FS: SYNC
# Sending file system backup to remote storage.
# -------------------------------------------------------------------------------------------------------------------- #

fs_sync() {
  (( ! "${SYNC_ON}" )) && return 0
  local opts; opts=('--archive' '--quiet')
  (( "${SYNC_DEL}" )) && opts+=('--delete')
  (( "${SYNC_RSF}" )) && opts+=('--remove-source-files')
  (( "${SYNC_PED}" )) && opts+=('--prune-empty-dirs')
  (( "${SYNC_CVS}" )) && opts+=('--cvs-exclude')
  rsync "${opts[@]}" -e "sshpass -p '${SYNC_PASS}' ssh -p ${SYNC_PORT:-22}" \
    "${FS_DST}/" "${SYNC_USER:-root}@${SYNC_HOST}:${SYNC_DST}/" \
    && _mail "$( hostname -f ) / SYNC" 'The database files are synchronized!' 'SUCCESS'
}

# -------------------------------------------------------------------------------------------------------------------- #
# FS: CLEAN
# Cleaning the file system.
# -------------------------------------------------------------------------------------------------------------------- #

fs_clean() {
  find "${FS_DST}" -type 'f' -mtime "+${FS_DAYS:-30}" -print0 | xargs -0 rm -f --
  find "${FS_DST}" -mindepth 1 -type 'd' -not -name 'lost+found' -empty -delete
}

# -------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------< COMMON FUNCTIONS >------------------------------------------------ #
# -------------------------------------------------------------------------------------------------------------------- #

_timestamp() {
  date -u '+%Y-%m-%d.%H-%M-%S'
}

_dir() {
  echo "$( date -u '+%Y' )/$( date -u '+%m' )/$( date -u '+%d' )"
}

_enc() {
  local out; out="${1}"
  local pass; pass="${ENC_PASS}"
  openssl enc -aes-256-cbc -salt -pbkdf2 -out "${out}" -pass "pass:${pass}"
}

_sum() {
  local in; in="${1}"
  local out; out="${in}.sum"
  sha256sum "${in}" | sed 's| .*/|  |g' | tee "${out}" > '/dev/null'
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< RUNNING SCRIPT >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

run && exit 0 || exit 1
