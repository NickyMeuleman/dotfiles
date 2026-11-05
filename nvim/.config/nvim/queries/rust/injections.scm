; copy of https://github.com/nvim-treesitter/nvim-treesitter/blob/main/runtime/queries/rust/injections.scm
; because I edited the first #not-any-of call to include sqlx queries
(macro_invocation
  macro: [
    (scoped_identifier
      name: (_) @_macro_name)
    (identifier) @_macro_name
  ]
  (token_tree) @injection.content
  (#not-any-of? @_macro_name
  "slint" "html" "json" "xml"
  "query" "query_as" "query_scalar"
  "query_unchecked" "query_as_unchecked" "query_scalar_unchecked"
  "query_file" "query_file_as" "query_file_scalar")
  (#set! injection.language "rust")
  (#set! injection.include-children))

(macro_invocation
  macro: [
    (scoped_identifier
      name: (_) @injection.language)
    (identifier) @injection.language
  ]
  (token_tree) @injection.content
  (#any-of? @injection.language "slint" "html" "json" "xml")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children))

(macro_definition
  (macro_rule
    left: (token_tree_pattern) @injection.content
    (#set! injection.language "rust")))

(macro_definition
  (macro_rule
    right: (token_tree) @injection.content
    (#set! injection.language "rust")))

([
  (line_comment)
  (block_comment)
] @injection.content
  (#set! injection.language "comment"))

(call_expression
  function: (scoped_identifier
    path: (identifier) @_regex
    (#any-of? @_regex "Regex" "RegexBuilder")
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (raw_string_literal
      (string_content) @injection.content))
  (#set! injection.language "regex"))

(call_expression
  function: (scoped_identifier
    path: (scoped_identifier
      (identifier) @_regex
      (#any-of? @_regex "Regex" "RegexBuilder") .)
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (raw_string_literal
      (string_content) @injection.content))
  (#set! injection.language "regex"))

(call_expression
  function: (scoped_identifier
    path: (identifier) @_regex
    (#any-of? @_regex "RegexSet" "RegexSetBuilder")
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (array_expression
      (raw_string_literal
        (string_content) @injection.content)))
  (#set! injection.language "regex"))

(call_expression
  function: (scoped_identifier
    path: (scoped_identifier
      (identifier) @_regex
      (#any-of? @_regex "RegexSet" "RegexSetBuilder") .)
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (array_expression
      (raw_string_literal
        (string_content) @injection.content)))
  (#set! injection.language "regex"))

((block_comment) @injection.content
  (#match? @injection.content "/\\*!([a-zA-Z]+:)?re2c")
  (#set! injection.language "re2c"))

; sqlx macro where SQL is the first argument eg. sqlx::query!("sql")
(macro_invocation
  macro: (scoped_identifier
    path: (identifier) @_macro_path
    name: (identifier) @_macro_name)
  (token_tree
    .
    [
    (string_literal
      ((string_content) @injection.content))
    (raw_string_literal
      ((string_content) @injection.content))
    ])
  (#eq? @_macro_path "sqlx")
  (#any-of? @_macro_name "query" "query_unchecked" "query_scalar" "query_scalar_unchecked")
  (#set! injection.language "sql"))

; sqlx macro where SQL is right after the first comma eg. sqlx::query_as!(Type, "sql", ...)
(macro_invocation
  macro: (scoped_identifier
    path: (identifier) @_macro_path
    name: (identifier) @_macro_name)
  (token_tree
    "," .
    [
      (string_literal
        (string_content) @injection.content)
      (raw_string_literal
        (string_content) @injection.content)
    ])
  (#eq? @_macro_path "sqlx")
  (#any-of? @_macro_name "query_as" "query_as_unchecked")
  (#set! injection.language "sql"))

; sqlx runtime API: sqlx::query("sql"), sqlx::query_as::<_, T>("sql"), ...
(call_expression
  function: [
    (scoped_identifier
      path: (identifier) @_path
      name: (identifier) @_name)
    (generic_function
      function: (scoped_identifier
        path: (identifier) @_path
        name: (identifier) @_name))
  ]
  arguments: (arguments
    .
    [
      (string_literal
        (string_content) @injection.content)
      (raw_string_literal
        (string_content) @injection.content)
    ])
  (#eq? @_path "sqlx")
  (#any-of? @_name "query" "query_as" "query_scalar" "query_with" "query_as_with" "query_scalar_with" "raw_sql")
  (#set! injection.language "sql"))
