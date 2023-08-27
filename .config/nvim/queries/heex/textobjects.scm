; tags
(tag) @tag.outer
(tag (start_tag) . (_) @tag.inner . (end_tag))
((tag (start_tag) . (_) @_start (_) @_end . (end_tag)) (#make-range! "tag.inner" @_start @_end))

(component) @tag.outer
(component (start_component) . (_) @tag.inner . (end_component))
((component (start_component) . (_) @_start (_) @_end . (end_component)) (#make-range! "tag.inner" @_start @_end))

(slot) @tag.outer
(slot (start_slot) . (_) @tag.inner . (end_slot))
((slot (start_slot) . (_) @_start (_) @_end . (end_slot)) (#make-range! "tag.inner" @_start @_end))


; tag attributes
(attribute) @parameter.outer

; e.g. :if={...}
(special_attribute) @parameter.outer
(special_attribute (expression (expression_value) @parameter.inner))

; e.g. id={...}
(attribute (expression (expression_value) @parameter.inner))

; e.g. class="..."
(attribute (quoted_attribute_value (attribute_value) @parameter.inner))
