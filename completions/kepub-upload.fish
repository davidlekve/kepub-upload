# Fish completions for kepub-upload

complete -c kepub-upload -s r -l remote  -d 'rclone remote name' -x -a '(rclone listremotes 2>/dev/null | string trim -c ":")'
complete -c kepub-upload -s p -l path    -d 'remote directory' -r
complete -c kepub-upload -s k -l keep    -d 'keep converted files locally'
complete -c kepub-upload -s n -l dry-run -d 'convert but do not upload'
complete -c kepub-upload -l no-color     -d 'disable colored output'
complete -c kepub-upload -l list-formats -d 'list supported formats'
complete -c kepub-upload -s V -l version -d 'show version'
complete -c kepub-upload -s h -l help    -d 'show help'
