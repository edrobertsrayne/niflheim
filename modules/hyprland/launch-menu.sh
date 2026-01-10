#!/usr/bin/env bash
set -euo pipefail

BACK_TO_EXIT=false

back_to() {
  local parent_menu="${1:-}"

  if [[ "$BACK_TO_EXIT" == "true" ]]; then
    exit 0
  elif [[ -n "$parent_menu" ]]; then
    "$parent_menu"
  else
    show_main_menu
  fi
}

menu() {
  local prompt="${1:-}"
  local options="${2:-}"
  local extra="${3:-}"
  local preselect="${4:-}"

  read -r -a args <<<"$extra"

  if [[ -n "$preselect" ]]; then
    local index
    index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
    if [[ -n "$index" ]]; then
      args+=("-c" "$index")
    fi
  fi

  echo -e "$options" | walker --dmenu --width 295 --height 600 -p "$prompt..." "${args[@]}"
}

terminal() {
  xdg-terminal-exec --app-id=com.niflheim.niflheim "$@"
}

terminal_present() {
  launch-presentation-terminal "$1"
}

show_capture_menu() {
  case $(menu "Capture" "󰹑  Grab the whole screen\n  Grab the current window\n󰗆  Grab an area\n  Grab a colour") in
  *area*) take-screenshot area ;;
  *window*) take-screenshot active ;;
  *screen*) take-screenshot output ;;
  *colour*)
    pkill -x hyprpicker || hyprpicker -a
    ;;
  *) back_to show_main_menu ;;
  esac
}

show_learn_menu() {
  case $(menu "Learn" "  Keybindings\n󱄅  Nixos Search\n  home-manager\n  nvf\n  Bash") in
  *Keybindings*) show-keybindings ;;
  *Nixos*) launch-webapp "https://search.nixos.org/options" ;;
  *home-manager*) launch-webapp "https://nix-community.github.io/home-manager/options.xhtml" ;;
  *nvf*) launch-webapp "https://notashelf.github.io/nvf/options.html" ;;
  *Bash*) launch-webapp "https://devhints.io/bash" ;;
  *) back_to show_main_menu ;;
  esac
}

show_system_menu() {
  case $(menu "System" "  Lock\n󰤄  Suspend\n󰜉  Restart\n󰐥  Shutdown") in
  *Lock*) hyprlock ;;
  *Suspend*) systemctl suspend ;;
  *Restart*) systemctl reboot --no-wall ;;
  *Shutdown*) systemctl poweroff --no-wall ;;
  *) back_to show_main_menu ;;
  esac
}

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n󰧑  Learn\n  Capture\n  Edit Config\n󰃢  Clean\n  Rebuild\n  About\n  System")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) walker -p "Launch..." ;;
  *capture*) show_capture_menu ;;
  *learn*) show_learn_menu ;;
  *config*) launch-editor "$HOME"/.niflheim ;;
  *rebuild*) terminal_present "nh os switch" ;;
  *clean*) terminal_present "nh clean all" ;;
  *about*) xdg-terminal-exec --app-id=com.niflheim.niflheim -e bash -c 'fastfetch; read -n 1 -s' ;;
  *system*) wlogout ;;
  esac
}

if [[ -n "${1:-}" ]]; then
  BACK_TO_EXIT=true
  go_to_menu "$1"
else
  show_main_menu
fi
