#!/bin/bash

function print_msg() {
  local mensaje="$1"
  local borde="+"$(printf -- '-%.0s' $(seq 1 $(( ${#mensaje} + 20 ))))"+"
  local relleno=$(printf -- ' %.0s' $(seq 1 $(( ${#mensaje} + 20 ))))
  
  printf "${borde}\n"
  printf "|%s|\n" "${relleno}"
  printf "|          %s          |\n" "$mensaje"
  printf "|%s|\n" "${relleno}"
  printf "${borde}\n"
  printf "\n"
}
