#!/bin/bash

set -e

PROJECT_PATH=/home/pet/Work/repos/movies-waybar

update_movies() {
  cd ${PROJECT_PATH}
  npm run scrape
  npm run fill
}

update_movies