export PATH=$PATH:$ZSH_CUSTOM/bin

function battery_charge {
  echo `battery` 2>/dev/null
}
