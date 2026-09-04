set disassembly-flavor intel
set confirm off

set history save on
set history filename ~/.gdb_history
set history size unlimited
set history remove-duplicates unlimited

set pagination off
set print pretty on

source ~/.gdb-dashboard

alias -a ds = dashboard
alias -a ew = dashboard expressions watch
alias -a uw = dashboard expressions unwatch

dashboard -layout source assembly expressions breakpoints variables
dashboard -style syntax_highlighting ""
dashboard -style style_selected_1 "1;32"
dashboard -style style_selected_2 "2;32"
dashboard -style style_critical "31"
