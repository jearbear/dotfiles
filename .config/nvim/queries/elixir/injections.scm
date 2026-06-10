((sigil
   (sigil_name) @_name
   (quoted_content) @injection.content)
 (#eq? @_name "CSS") (#set! injection.language "css"))

((sigil
   (sigil_name) @_name
   (quoted_content) @injection.content)
 (#eq? @_name "JS") (#set! injection.language "js"))
