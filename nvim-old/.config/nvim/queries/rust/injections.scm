;; extends

(macro_invocation
  macro: [
    (identifier) @macro_name (#any-of? @macro_name "query" "query_as" "query_scalar" "query!" "query_as!" "query_scalar!")
    (scoped_identifier
      path: (identifier) @path (#eq? @path "sqlx")
      name: (identifier) @macro_name (#any-of? @macro_name "query" "query_as" "query_scalar" "query!" "query_as!" "query_scalar!"))
  ]
  (token_tree
    [
      (string_literal (string_content) @injection.content)
      (raw_string_literal (string_content) @injection.content)
    ])
  (#set! injection.language "sql")
  ; make it win against the default Rust-in-macro highlighting
  (#set! injection.priority 150))
