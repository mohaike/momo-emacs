#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"

sh "${CURRENT_PATH}/momo_check_tool.sh" 123456 brew the_silver_searcher
