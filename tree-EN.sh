#!/bin/bash
trap "tput reset; tput cnorm; exit" 2

clear
tput civis

lin=2
col=$(($(tput cols) / 2))
c=$((col - 1))
color=0

tput setaf 2
tput bold

# -----------------------------
# TREE
# -----------------------------
for ((i = 1; i < 20; i += 2)); do
  tput cup $lin $col
  for ((j = 1; j <= i; j++)); do
    echo -n "*"
  done
  ((lin++))
  ((col--))
done

tput sgr0
tput setaf 3

# -----------------------------
# TRUNK
# -----------------------------
for ((i = 1; i <= 2; i++)); do
  tput cup $((lin++)) $c
  echo "mWm"
done

new_year=$(date +%Y)
((new_year++))

tput setaf 1
tput bold
tput cup $lin $((c - 6))
echo "MERRY CHRISTMAS"
tput cup $((lin + 1)) $((c - 10))
echo "And lots of J*BS in $new_year"

((c++))
k=1

# Arrays for blinking lights
declare -A line column

# -----------------------------
# LIGHTS & DECORATIONS
# -----------------------------
while true; do
  for ((i = 1; i <= 35; i++)); do

    # ========== TURN OFF OLD LIGHT ==========
    if ((k > 1)); then
      oldkey=$(((k - 1) * 100 + i))
      if [[ -n ${line[$oldkey]} ]]; then
        tput setaf 2
        tput bold
        tput cup ${line[$oldkey]} ${column[$oldkey]}
        echo "*"
        unset line[$oldkey]
        unset column[$oldkey]
      fi
    fi

    # ========== NEW LIGHT POSITION ==========
    li=$((RANDOM % 9 + 3))
    start=$((c - li + 2))
    co=$(((RANDOM % (li - 2)) * 2 + 1 + start))

    # Draw the new light
    tput setaf $color
    tput bold
    tput cup $li $co
    echo -n "o"

    key=$((k * 100 + i))
    line[$key]=$li
    column[$key]=$co

    color=$(((color + 1) % 8))

    # ========== FLASHING TEXT ==========
    sh=1
    for l in J '*' B S; do
      tput cup $((lin + 1)) $((c + sh))
      echo -n "$l"
      ((sh++))
      sleep 0.01
    done

  done

  # alternate buffer (1 → 2 → 1 → …)
  k=$((k % 2 + 1))
done
