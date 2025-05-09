#!/usr/bin/env -S bash -eu
# -------------------------------------------------------------------------------------------------------------------- #
# POSTGRESQL: BACKUP OF POSTGRESQL DATABASES.
# A script for backing up PostgreSQL databases.
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera
# @license    MIT
# @version    0.1.0
# @link       https://lib.onl/ru/2025/05/57f8f8c0-b963-5708-b310-129ea98a2423/
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )" # Source directory.
SRC_NAME="$( basename "$( readlink -f "${BASH_SOURCE[0]}" )" )" # Source name.
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf" # Loading configuration file.

# Parameters.
SYNC="${SYNC:?}"; readonly SYNC
SYNC_HOST="${SYNC_HOST:?}"; readonly SYNC_HOST
SYNC_PORT="${SYNC_PORT:?}"; readonly SYNC_PORT
SYNC_USER="${SYNC_USER:?}"; readonly SYNC_USER
SYNC_PASS="${SYNC_PASS:?}"; readonly SYNC_PASS
SYNC_DST="${SYNC_DST:?}"; readonly SYNC_DST
SYNC_SRC="${SYNC_SRC:?}"; readonly SYNC_SRC
SQL_DATA="${SQL_DATA:?}"; readonly SQL_DATA
SQL_HOST="${SQL_HOST:?}"; readonly SQL_HOST
SQL_PORT="${SQL_PORT:?}"; readonly SQL_PORT
SQL_USER="${SQL_USER:?}"; readonly SQL_USER
SQL_DB=("${SQL_DB[@]:?}"); readonly SQL_DB

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION
# -------------------------------------------------------------------------------------------------------------------- #

run() { sql_backup && { (( "${SYNC}" )) && fs_sync; }; }

sql_backup() {
  local id; id="$( _id )"

  for i in "${SQL_DB[@]}"; do
    local ts; ts="$( _timestamp )"
    local dump; dump="${i}.${id}.${ts}.sql"
    { [[ ! -d "${SQL_DATA}" ]] && mkdir -p "${SQL_DATA}"; } && cd "${SQL_DATA}" \
      && pg_dump --host="${SQL_HOST}" --port="${SQL_PORT}" --username="${SQL_USER}" \
      --no-password --dbname="${i}" --file="${dump}" \
      --clean --if-exists --no-owner --no-privileges --quote-all-identifiers \
      && xz "${dump}" && rm -f "${dump}"
  done
}

fs_sync() {
  rsync -a --delete --quiet \
    -e "sshpass -p '${SYNC_PASS}' ssh -p ${SYNC_PORT}" \
    "${SQL_DATA}/" "${SYNC_USER}@${SYNC_HOST}:${SYNC_DST}/"
}

# fs_mount() {
#   { [[ ! -d "${SYNC_SRC}" ]] && mkdir -p "${SYNC_SRC}"; } \
#     && echo "${SYNC_PASS}" | sshfs -p "${SYNC_PORT}" "${SYNC_USER}@${SYNC_HOST}:${SYNC_DST}" "${SYNC_SRC}" \
#       -o 'password_stdin'
# }

# fs_umount() {
#   umount "${SYNC_SRC}"
# }

# -------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------< COMMON FUNCTIONS >------------------------------------------------ #
# -------------------------------------------------------------------------------------------------------------------- #

_id() {
  date -u '+%s'
}

_timestamp() {
  date -u '+%Y-%m-%d.%H-%M-%S'
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< RUNNING SCRIPT >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

run && exit 0 || exit 1
