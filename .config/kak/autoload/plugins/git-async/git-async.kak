define-command -params 1.. \
    -docstring %{
        git-async [<arguments>]: asynchronous git helper
        Available commands:
            update-diff
            update-diff-via-git
                - uses `git diff` instead of plain `diff`
    } -shell-script-candidates %{
    if [ $kak_token_to_complete -eq 0 ]; then
        printf %s\\n \
            update-diff \
            update-diff-via-git \
        ;
    fi
  } \
  git-async %{ nop %sh{ {
    eval_in_client () {
        printf "eval -client '%s' '%s'" "$kak_client" "$1" | kak -p "${kak_session}"
    }

    cd_bufdir() {
        dirname_buffer="${kak_buffile%/*}"
        cd "${dirname_buffer}" 2>/dev/null || {
            printf 'fail Unable to change the current working directory to: %s\n' "${dirname_buffer}"
            exit 1
        }
    }

    diff_buffer_against_index() {
        buffile_relative=${kak_buffile#"$(git rev-parse --show-toplevel)/"}

        fifo=$(mktemp -u /tmp/kak-buffer-fifo-XXXXXX)
        mkfifo "$fifo"

        eval_in_client 'exec -draft "%%<a-|>tee > '"$fifo"'<ret>"'
        # eval_in_client "eval -no-hooks write \"$fifo\""

        git show ":${buffile_relative}" |
            diff - "$fifo" "$@" |
            awk -v buffile_relative="$buffile_relative" '
                NR == 1 { print "--- a/" buffile_relative }
                NR == 2 { print "+++ b/" buffile_relative }
                NR > 2
            '

        rm -f "$fifo"
    }

    diff_buffer_against_index_via_git() {
        buffile_relative=${kak_buffile#"$(git rev-parse --show-toplevel)/"}

        fifo_buffer=$(mktemp -u /tmp/kak-diff-fifo-XXXXXX)
        mkfifo "$fifo_buffer"
        fifo_git=$(mktemp -u /tmp/kak-diff-fifo-XXXXXX)
        mkfifo "$fifo_git"

        eval_in_client 'exec -draft "%%<a-|>tee > '"$fifo_buffer"'<ret>"'
        git show "$rev:${buffile_relative}" > "$fifo_git" &

        git diff --no-index "$@" -- "$fifo_git" "$fifo_buffer" |
            awk -v buffile_relative="$buffile_relative" '
                NR == 1 { print "--- a/" buffile_relative }
                NR == 2 { print "+++ b/" buffile_relative }
                NR > 2
            '

        rm -f "$fifo_buffer"
        rm -f "$fifo_git"
    }

    update_diff() {
        (
            cd_bufdir
            diff_buffer_against_index${1} -U0 | perl -e '
            use utf8;
            $flags = $ENV{"kak_timestamp"};
            $add_char = $ENV{"kak_opt_git_diff_add_char"};
            $del_char = $ENV{"kak_opt_git_diff_del_char"};
            $top_char = $ENV{"kak_opt_git_diff_top_char"};
            $mod_char = $ENV{"kak_opt_git_diff_mod_char"};
            foreach $line (<STDIN>) {
                if ($line =~ /@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))?/) {
                    $from_line = $1;
                    $from_count = ($2 eq "" ? 1 : $2);
                    $to_line = $3;
                    $to_count = ($4 eq "" ? 1 : $4);

                    if ($from_count == 0 and $to_count > 0) {
                        for $i (0..$to_count - 1) {
                            $line = $to_line + $i;
                            $flags .= " $line|\{green\}$add_char";
                        }
                    }
                    elsif ($from_count > 0 and $to_count == 0) {
                        if ($to_line == 0) {
                            $flags .= " 1|\{red\}$top_char";
                        } else {
                            $flags .= " $to_line|\{red\}$del_char";
                        }
                    }
                    elsif ($from_count > 0 and $from_count == $to_count) {
                        for $i (0..$to_count - 1) {
                            $line = $to_line + $i;
                            $flags .= " $line|\{blue\}$mod_char";
                        }
                    }
                    elsif ($from_count > 0 and $from_count < $to_count) {
                        for $i (0..$from_count - 1) {
                            $line = $to_line + $i;
                            $flags .= " $line|\{blue\}$mod_char";
                        }
                        for $i ($from_count..$to_count - 1) {
                            $line = $to_line + $i;
                            $flags .= " $line|\{green\}$add_char";
                        }
                    }
                    elsif ($to_count > 0 and $from_count > $to_count) {
                        for $i (0..$to_count - 2) {
                            $line = $to_line + $i;
                            $flags .= " $line|\{blue\}$mod_char";
                        }
                        $last = $to_line + $to_count - 1;
                        $flags .= " $last|\{blue+u\}$mod_char";
                    }
                }
            }
            print "set-option buffer git_diff_flags $flags\n"
        ' )
    }

    case "$1" in
    update-diff) eval_in_client "$(update_diff)" ;;
    update-diff-via-git) eval_in_client "$(update_diff _via_git)" ;;
    *)
        printf "fail unknown git-async command '%s'\n" "$1"
        exit
        ;;
    esac
    } > /dev/null 2>&1 < /dev/null & }
}
