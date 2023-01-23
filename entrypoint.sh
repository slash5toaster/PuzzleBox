#!/usr/bin/env bash

# entrypoint for usability

# if no parameter return help
if [[ ${#@} -le 0 ]]; then
    puzzlebox --help
elif [[ ${@} == "bash" ]]; then
    bash
else
    puzzlebox ${@}
fi