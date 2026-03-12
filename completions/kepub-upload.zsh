#compdef kepub-upload

_kepub_upload() {
  local -a remotes

  _arguments -s \
    '(-r --remote)'{-r,--remote}'[rclone remote name]:remote:->remotes' \
    '(-p --path)'{-p,--path}'[remote directory]:path:' \
    '(-k --keep)'{-k,--keep}'[keep converted files locally]' \
    '(-n --dry-run)'{-n,--dry-run}'[convert but do not upload]' \
    '--no-color[disable colored output]' \
    '--list-formats[list supported formats]' \
    '(-V --version)'{-V,--version}'[show version]' \
    '(-h --help)'{-h,--help}'[show help]' \
    '*:ebook file:_files -g "*.(epub|pdf|kepub.epub)"'

  case "$state" in
    remotes)
      if (( $+commands[rclone] )); then
        remotes=("${(@f)$(rclone listremotes 2>/dev/null | tr -d ':')}")
        _describe 'remote' remotes
      fi
      ;;
  esac
}

_kepub_upload "$@"
