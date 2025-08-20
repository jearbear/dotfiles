; tags
(jsx_element) @tag.outer
; tag with single child
(jsx_element (jsx_opening_element) . (_) @tag.inner . (jsx_closing_element))
; tag with multiple children
((jsx_element (jsx_opening_element) . (_) @_start (_) @_end . (jsx_closing_element)) (#make-range! "tag.inner" @_start @_end))

(jsx_self_closing_element) @tag.outer
