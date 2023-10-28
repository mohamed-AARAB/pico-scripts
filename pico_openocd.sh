#!/bin/bash

run_script=false

bashrc_alias=$(grep --no-ignore-case -F "alias picocd=" ~/.bashrc | awk "NR==1{print;exit}")

if [[ $bashrc_alias ]]; then
  run_script=true
else
# create an alias of this script if the user approves
  echo "picocd alias is not defined for this script"
  read -p "Do you want it to be defined? [y|n] : " -r answer
  if [[ "$answer" = "y" ]]; then
    ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    cat >> ~/.bashrc << EOL

# pico opencd launch script alias
alias picocd=$ABSOLUTE_PATH
EOL
    echo "Alias picocd was defined for this script"
  elif [[ "$answer" = "n" ]]; then
    echo "Alias will not be created"
  else
    echo "Invalid answer; alias won't be created"
  fi

  read -p 'run the script? [y|n] : ' -r answer
  if [[ "$answer" = "y" ]]; then
    run_script=true
  fi
fi

if [[ "$run_script" = true ]]; then
  sudo openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c "adapter speed 5000" -s tcl
fi
