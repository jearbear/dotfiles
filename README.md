# git-async.kak
An asynchronous git command for Kakoune. Currently only has the ability to update the `git-diff` highlighter (a.k.a. the git gutter).

> Requires [git.kak](https://github.com/mawww/kakoune/blob/master/rc/tools/git.kak), which is in the [rc](https://github.com/mawww/kakoune/blob/master/rc/tools/git.kak) that will come with most installations of Kakoune

- [installation](#installation)

# explanation
The way to enable the git gutter in Kakoune is generally something like this in your `kakrc`:
```kakscript
add-highlighter global/git-diff flag-lines Default git_diff_flags

hook global -group git-gutter-hooks BufCreate .* %{
  try %{ git show-diff }
}
hook global -group git-gutter-hooks FocusIn .* %{
  try %{ git update-diff }
}
hook global -group git-gutter-hooks BufReload .* %{
  try %{ git update-diff }
}
hook global -group git-gutter-hooks BufWritePost .* %{
  try %{ git update-diff }
}
hook global -group git-gutter-hooks NormalIdle .* %{
  try %{ git update-diff }
}
```

However, the `NormalIdle` hook can make the editor sluggish if the diffing doesn't run very quickly. This can happen on large files, or when accessing files over a network.

This plugin adds a command, `git-async update-diff`, that immediately puts the shell process that does all the work into the background, returning control to Kakoune. This means that although the diffing itself doesn't happen faster, it does not make the whole editor sluggish, only the git gutter.

# installation
> with any installation method, the `add-highlighter global/git-diff` command needs to come after the `line-numbers` highlighter is added. If the `git-diff` highlighter is added before `line-numbers`, the diff symbols will appear to the right of the line number separator

## manual
- put `git-async.kak` in your `autoload` directory

Put this in `kakrc`:
```kakscript
add-highlighter global/git-diff flag-lines Default git_diff_flags

hook global -group git-gutter-hooks BufCreate .* %{
  try %{ git show-diff }
}
hook global -group git-gutter-hooks FocusIn .* %{
  try %{ git-async update-diff }
}
hook global -group git-gutter-hooks BufReload .* %{
  try %{ git-async update-diff }
}
hook global -group git-gutter-hooks BufWritePost .* %{
  try %{ git-async update-diff }
}
hook global -group git-gutter-hooks NormalIdle .* %{
  try %{ git-async update-diff }
}
```

## via kak-bundle
To install via [kak-bundle](https://github.com/jdugan6240/kak-bundle):
- put this in `kakrc`:
```kakscript
bundle git-async.kak 'https://github.com/evannjohnson/git-async.kak' %{
  add-highlighter global/git-diff flag-lines Default git_diff_flags

  hook global -group git-gutter-hooks BufCreate .* %{
    try %{ git show-diff }
  }
  hook global -group git-gutter-hooks FocusIn .* %{
    try %{ git-async update-diff-via-git }
  }
  hook global -group git-gutter-hooks BufReload .* %{
    try %{ git-async update-diff-via-git }
  }
  hook global -group git-gutter-hooks BufWritePost .* %{
    try %{ git-async update-diff-via-git }
  }
  hook global -group git-gutter-hooks NormalIdle .* %{
    try %{ git-async update-diff-via-git }
  }
}
```

- open Kakoune and run `bundle-install git-async.kak`
- restart Kakoune

## using `git diff` instead of plain `diff`
- `git-async update-diff-via-git` does the same thing as `git-async update-diff`, it updates the `git-diff` highlighter. The difference is that under the hood it uses `git diff` to perform the diff, instead of getting the content to diff with `git show` and then piping into plain `diff`, which is what `update-diff` does. This can result in better detection of which lines are changed vs. new in some scenarios.
