#!/bin/bash

CONFIG_FOLDER="$(realpath ~/.config/movies-cwb-ags-bar)"
mkdir -p "${CONFIG_FOLDER}"

get_config() {
  if [ ! -f "${CONFIG_FOLDER}/config.json" ]; then
    init_default_config
  fi

  jq -c . "${CONFIG_FOLDER}/config.json"
}

init_default_config() {
  cat > "${CONFIG_FOLDER}/config.json" <<EOF
{
  "dbFile": "${CONFIG_FOLDER}/movies.db",
  "barDaysAheadToCheck": 10,
  "barTopMargin": 30,
  "barRightMargin": 128,
  "barPollInterval": 30
}
EOF
}