#!/bin/bash
# abduco-dmenu.sh
# choose the abduco session from dmenu and reattach it
dmenu_l="12"
term="xterm"

session_list=()
session_names=()
readarray -t sessions_list < <(abduco)

i=1 # 0 is always a header in abduco output
number_of_sessions=$((${#sessions_list[@]}-1))

while [[ $i -le $number_of_sessions ]]; do
  session_description=
  session_description="${sessions_list[$i]}"
  i=$(($i+1))
  # if session is detached, add its name to the list
  # in the 'if' line the blank is space
  # in the 'else' line it's tab 
  if [[ "${session_description%% *}" == "*" ]]; then
    continue
  else
    session_names+=("${session_description##*	}")
  fi
done

chosen_session=$(printf '%s\n' "${session_names[@]}" | dmenu -l $dmenu_l "$@")
if [[ "$chosen_session" ]] ; then
  $term -e abduco -a "$chosen_session" & disown
  exit 0
else 
  exit 1
fi
