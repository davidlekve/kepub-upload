_kepub_upload() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="-r --remote -p --path -k --keep -n --dry-run --no-color --list-formats -V --version -h --help"

  case "$prev" in
    -r|--remote)
      if command -v rclone &>/dev/null; then
        mapfile -t COMPREPLY < <(compgen -W "$(rclone listremotes 2>/dev/null | tr -d ':')" -- "$cur")
      fi
      return
      ;;
    -p|--path)
      return
      ;;
  esac

  if [[ "$cur" == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return
  fi

  # Complete ebook files and directories for navigation
  mapfile -t COMPREPLY < <(compgen -f -X '!*.@(epub|pdf|kepub.epub)' -- "$cur")
  mapfile -t -O "${#COMPREPLY[@]}" COMPREPLY < <(compgen -d -- "$cur")
}

complete -F _kepub_upload kepub-upload
