declare-option str color_rosewater 'rgb:f5e0dc'
declare-option str color_flamingo 'rgb:f2cdcd'
declare-option str color_pink 'rgb:f5c2e7'
declare-option str color_mauve 'rgb:cba6f7'
declare-option str color_red 'rgb:f38ba8'
declare-option str color_maroon 'rgb:eba0ac'
declare-option str color_peach 'rgb:fab387'
declare-option str color_yellow 'rgb:f9e2af'
declare-option str color_green 'rgb:a6e3a1'
declare-option str color_teal 'rgb:94e2d5'
declare-option str color_sky 'rgb:89dceb'
declare-option str color_sapphire 'rgb:74c7ec'
declare-option str color_blue 'rgb:89b4fa'
declare-option str color_lavender 'rgb:b4befe'
declare-option str color_text 'rgb:cdd6f4'
declare-option str color_subtext1 'rgb:bac2de'
declare-option str color_subtext0 'rgb:a6adc8'
declare-option str color_overlay2 'rgb:9399b2'
declare-option str color_overlay1 'rgb:7f849c'
declare-option str color_overlay0 'rgb:6c7086'
declare-option str color_surface2 'rgb:585b70'
declare-option str color_surface1 'rgb:45475a'
declare-option str color_surface0 'rgb:313244'
declare-option str color_base 'rgb:1e1e2e'
declare-option str color_mantle 'rgb:181825'
declare-option str color_crust 'rgb:11111b'
declare-option str color_base_yellow 'rgb:464245'

set-face global title  "%opt{color_text}+b"
set-face global header "%opt{color_subtext0}+b"
set-face global bold   "%opt{color_maroon}+b"
set-face global italic "%opt{color_maroon}+i"
set-face global mono   "%opt{color_green}"
set-face global block  "%opt{color_sapphire}"
set-face global link   "%opt{color_blue}"
set-face global bullet "%opt{color_peach}"
set-face global list   "%opt{color_peach}"

set-face global Default                    "%opt{color_text},%opt{color_base}"
set-face global PrimarySelection           "%opt{color_text},%opt{color_surface2}"
set-face global SecondarySelection         "%opt{color_text},%opt{color_surface2}"
set-face global PrimaryCursor              "default,default+r"
set-face global SecondaryCursor            "default,default+r"
set-face global PrimaryCursorEol           "default,%opt{color_mauve}"
set-face global SecondaryCursorEol         "default,%opt{color_mauve}"
set-face global CursorLine	           "default,%opt{color_surface0}"
set-face global CursorLineInsertMode	   "default,%opt{color_base_yellow}"
set-face global LineNumbers                "%opt{color_overlay1},%opt{color_base}"
set-face global LineNumberCursor           "%opt{color_rosewater},%opt{color_surface2}+b"
set-face global LineNumbersWrapped         "%opt{color_rosewater},%opt{color_surface2}"
set-face global MenuForeground             "%opt{color_text},%opt{color_surface1}"
set-face global MenuBackground             "%opt{color_subtext0},%opt{color_surface0}"
set-face global MenuInfo                   "%opt{color_overlay1},%opt{color_surface0}"
set-face global Information                "%opt{color_text},%opt{color_mantle}"
set-face global Error                      "%opt{color_red},%opt{color_mantle}"
set-face global StatusLine                 "%opt{color_text},%opt{color_mantle}"
set-face global StatusLineMode             "%opt{color_crust},%opt{color_mauve}"
set-face global StatusLineInfo             "%opt{color_mauve},%opt{color_mantle}"
set-face global StatusLineValue            "%opt{color_crust},%opt{color_yellow}"
set-face global StatusCursor               "%opt{color_crust},%opt{color_rosewater}"
set-face global Prompt                     "%opt{color_mauve},%opt{color_mantle}"
set-face global MatchingChar               "%opt{color_maroon},%opt{color_base}"
set-face global Whitespace                 "%opt{color_surface1},%opt{color_base}+f"
set-face global WrapMarker                 Whitespace
set-face global BufferPadding              "%opt{color_base},%opt{color_base}"

set-face global value         "%opt{color_peach}"
set-face global type          "%opt{color_blue}"
set-face global variable      "%opt{color_text}"
set-face global module        "%opt{color_lavender}"
set-face global function      "%opt{color_blue}"
set-face global string        "%opt{color_green}"
set-face global keyword       "%opt{color_mauve}"
set-face global operator      "%opt{color_sky}"
set-face global attribute     "%opt{color_green}"
set-face global comment       "%opt{color_overlay0}"
set-face global documentation comment
set-face global meta          "%opt{color_mauve}"
set-face global builtin       "%opt{color_text}"
set-face global class       "%opt{color_blue}"
set-face global constant "%opt{color_peach}"


# Tree-sitter is too unperformant rn

# set-face global ts_attribute                    "%opt{color_yellow}"
# set-face global ts_comment                      "%opt{color_overlay0}+i"
# set-face global ts_comment_unused               "%opt{color_overlay0}+is"
# set-face global ts_conceal                      "%opt{color_mauve}+i"
# set-face global ts_constant                     "%opt{color_peach}"
# set-face global ts_constant_builtin_boolean     "%opt{color_sky}"
# set-face global ts_constant_character           "%opt{color_yellow}"
# set-face global ts_constant_macro               "%opt{color_mauve}"
# set-face global ts_constructor                  "%opt{color_sky}"
# set-face global ts_diff_plus                    "%opt{color_green}"
# set-face global ts_diff_minus                   "%opt{color_red}"
# set-face global ts_diff_delta                   "%opt{color_blue}"
# set-face global ts_diff_delta_moved             "%opt{color_mauve}"
# set-face global ts_error                        "%opt{color_red}+b"
# set-face global ts_function                     "%opt{color_blue}"
# set-face global ts_function_builtin             "%opt{color_blue}+i"
# set-face global ts_function_macro               "%opt{color_mauve}"
# set-face global ts_hint                         "%opt{color_blue}+b"
# set-face global ts_info                         "%opt{color_teal}+b"
# set-face global ts_keyword                      "%opt{color_mauve}"
# set-face global ts_keyword_conditional          "%opt{color_mauve}+i"
# set-face global ts_keyword_control_conditional  "%opt{color_mauve}+i"
# set-face global ts_keyword_control_directive    "%opt{color_mauve}+i"
# set-face global ts_keyword_control_import       "%opt{color_mauve}+i"
# set-face global ts_keyword_directive            "%opt{color_mauve}+i"
# set-face global ts_keyword_storage              "%opt{color_mauve}"
# set-face global ts_keyword_storage_modifier     "%opt{color_mauve}"
# set-face global ts_keyword_storage_modifier_mut "%opt{color_mauve}"
# set-face global ts_keyword_storage_modifier_ref "%opt{color_teal}"
# set-face global ts_label                        "%opt{color_sky}+i"
# set-face global ts_markup_bold                  "%opt{color_peach}+b"
# set-face global ts_markup_heading               "%opt{color_red}"
# set-face global ts_markup_heading_1             "%opt{color_red}"
# set-face global ts_markup_heading_2             "%opt{color_mauve}"
# set-face global ts_markup_heading_3             "%opt{color_green}"
# set-face global ts_markup_heading_4             "%opt{color_yellow}"
# set-face global ts_markup_heading_5             "%opt{color_pink}"
# set-face global ts_markup_heading_6             "%opt{color_teal}"
# set-face global ts_markup_heading_marker        "%opt{color_peach}+b"
# set-face global ts_markup_italic                "%opt{color_pink}+i"
# set-face global ts_markup_list_checked          "%opt{color_green}"
# set-face global ts_markup_list_numbered         "%opt{color_blue}+i"
# set-face global ts_markup_list_unchecked        "%opt{color_teal}"
# set-face global ts_markup_list_unnumbered       "%opt{color_mauve}"
# set-face global ts_markup_link_label            "%opt{color_blue}"
# set-face global ts_markup_link_url              "%opt{color_teal}+u"
# set-face global ts_markup_link_uri              "%opt{color_teal}+u"
# set-face global ts_markup_link_text             "%opt{color_blue}"
# set-face global ts_markup_quote                 "%opt{color_overlay1}"
# set-face global ts_markup_raw                   "%opt{color_green}"
# set-face global ts_markup_strikethrough         "%opt{color_overlay1}+s"
# set-face global ts_namespace                    "%opt{color_blue}+i"
# set-face global ts_operator                     "%opt{color_sky}"
# set-face global ts_property                     "%opt{color_sky}"
# set-face global ts_punctuation                  "%opt{color_overlay1}"
# set-face global ts_punctuation_special          "%opt{color_sky}"
# set-face global ts_special                      "%opt{color_blue}"
# set-face global ts_spell                        "%opt{color_mauve}"
# set-face global ts_string                       "%opt{color_green}"
# set-face global ts_string_regex                 "%opt{color_pink}"
# set-face global ts_string_regexp                "%opt{color_pink}"
# set-face global ts_string_escape                "%opt{color_flamingo}"
# set-face global ts_string_special               "%opt{color_blue}"
# set-face global ts_string_special_path          "%opt{color_green}"
# set-face global ts_string_special_symbol        "%opt{color_mauve}"
# set-face global ts_string_symbol                "%opt{color_red}"
# set-face global ts_tag                          "%opt{color_mauve}"
# set-face global ts_tag_error                    "%opt{color_red}"
# set-face global ts_text                         "%opt{color_text}"
# set-face global ts_text_title                   "%opt{color_mauve}"
# set-face global ts_type                         "%opt{color_green}"
# set-face global ts_type_enum_variant            "%opt{color_sky}"
# set-face global ts_type_enum_variant_builtin    "%opt{color_sky}+i"
# set-face global ts_variable                     "%opt{color_text}"
# set-face global ts_variable_builtin             "%opt{color_red}"
# set-face global ts_variable_other_member        "%opt{color_teal}"
# set-face global ts_variable_parameter           "%opt{color_maroon}+i"
# set-face global ts_warning                      "%opt{color_yellow}+b"
