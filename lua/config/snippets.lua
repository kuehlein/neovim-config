  -- ============================================================================
  -- Code snippet short-cuts
  -- ============================================================================
  --
  -- Common prefix conventions across languages:
  --   td          = TODO comment
  --   p           = print/console.log/println (or public/export prefix for constructs)
  --   fn          = function definition
  --   afn         = async function definition
  --   if/ie/ieie  = if statement / if-else / if-else-if-else
  --   for         = for loop (with language-specific variants: foro, fori, forp, etc.)
  --   wl          = while loop
  --   tc          = try-catch
  --   cl          = class definition
  --   pcl         = public/export class definition
  --   ip          = import statement
  --   ep          = export default statement
  --
  -- ============================================================================
local snippets = require('mini.snippets')

-- Returns snippets based on context
-- context.lang contains the current buffer's filetype
local function custom_snippets(context)
  local all_snippets = {
    -- Global snippets
    { prefix = '@date', body = '$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE', desc = 'Current date (YYYY-MM-DD)' },
    { prefix = '@time', body = '$CURRENT_HOUR:$CURRENT_MINUTE:$CURRENT_SECOND', desc = 'Current time (HH:MM:SS)' },
    { prefix = '@datetime', body = '$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE $CURRENT_HOUR:$CURRENT_MINUTE', desc = 'Date and time' },

    -- Bash
    { prefix = 'td', body = '# TODO: $0', desc = 'TODO comment', filetype = 'bash' },
    { prefix = 'sbash', body = '#!/usr/bin/env bash\n\nset -euo pipefail\n\n$0', desc = 'Bash script with strict mode', filetype = 'bash' },
    { prefix = 'fn', body = '$1() {\n\t$0\n}', desc = 'Bash function', filetype = 'bash' },
    { prefix = 'if', body = 'if [[ $1 ]]; then\n\t$0\nfi', desc = 'If statement', filetype = 'bash' },
    { prefix = 'ie', body = 'if [[ $1 ]]; then\n\t$2\nelse\n\t$0\nfi', desc = 'If-else statement', filetype = 'bash' },
    { prefix = 'ieie', body = 'if [[ $1 ]]; then\n\t$2\nelif [[ $3 ]]; then\n\t$4\nelse\n\t$0\nfi', desc = 'If-elseif-else statement', filetype = 'bash' },
    { prefix = 'for', body = 'for $1 in $2; do\n\t$0\ndone', desc = 'For loop', filetype = 'bash' },
    { prefix = 'forc', body = 'for (( i=$1; i<$2; i++ )); do\n\t$0\ndone', desc = 'C-style for loop', filetype = 'bash' },
    { prefix = 'wl', body = 'while [[ $1 ]]; do\n\t$0\ndone', desc = 'While loop', filetype = 'bash' },
    { prefix = 'case', body = 'case $1 in\n\t$2)\n\t\t$3\n\t\t;;\n\t*)\n\t\t$0\n\t\t;;\nesac', desc = 'Case statement', filetype = 'bash' },
    { prefix = 'p', body = 'echo "$0"', desc = 'Echo statement', filetype = 'bash' },

    -- C
    { prefix = 'td', body = '// TODO: $0', desc = 'TODO comment', filetype = 'c' },
    { prefix = 'main', body = '#include <stdio.h>\n\nint main(int argc, char *argv[]) {\n\t$0\n\treturn 0;\n}', desc = 'Main function', filetype = 'c' },
    { prefix = 'for', body = 'for (int $1 = 0; $1 < $2; $1++) {\n\t$0\n}', desc = 'For loop', filetype = 'c' },
    { prefix = 'wl', body = 'while ($1) {\n\t$0\n}', desc = 'While loop', filetype = 'c' },
    { prefix = 'if', body = 'if ($1) {\n\t$0\n}', desc = 'If statement', filetype = 'c' },
    { prefix = 'ie', body = 'if ($1) {\n\t$2\n} else {\n\t$0\n}', desc = 'If-else statement', filetype = 'c' },
    { prefix = 'ieie', body = 'if ($1) {\n\t$2\n} else if ($3) {\n\t$4\n} else {\n\t$0\n}', desc = 'If-elseif-else statement', filetype = 'c' },
    { prefix = 'sw', body = 'switch ($1) {\n\tcase $2:\n\t\t$3\n\t\tbreak;\n\tdefault:\n\t\t$0\n\t\tbreak;\n}', desc = 'Switch statement', filetype = 'c' },
    { prefix = 'st', body = 'struct $1 {\n\t$0\n};', desc = 'Struct definition', filetype = 'c' },
    { prefix = 'tydst', body = 'typedef struct {\n\t$0\n} $1;', desc = 'Typedef struct', filetype = 'c' },
    { prefix = 'mal', body = '$1 *$2 = ($1 *)malloc(sizeof($1) * $3);', desc = 'Malloc allocation', filetype = 'c' },
    { prefix = 'p', body = 'printf("$0\\n");', desc = 'Printf statement', filetype = 'c' },

    -- CSS
    { prefix = 'td', body = '/* TODO: $0 */', desc = 'TODO comment', filetype = 'css' },
    { prefix = 'com', body = '/* $0 */', desc = 'Comment', filetype = 'css' },
    { prefix = 'mlc', body = '/**\n * $0\n */', desc = 'Multi-line comment', filetype = 'css' },
    { prefix = 'cl', body = '.$1 {\n\t$2: $0;\n}', desc = 'Class', filetype = 'css' },
    { prefix = 'id', body = '#$1 {\n\t$2: $0;\n}', desc = 'Id', filetype = 'css' },
    { prefix = 'media', body = '@media ($1) {\n\t$0\n}', desc = 'Media query', filetype = 'css' },
    { prefix = 'mediamin', body = '@media (min-width: $1px) {\n\t$0\n}', desc = 'Media query (min-width)', filetype = 'css' },
    { prefix = 'flex', body = 'display: flex;\njustify-content: $1;\nalign-items: $2;$0', desc = 'Flexbox container', filetype = 'css' },
    { prefix = 'grid', body = 'display: grid;\ngrid-template-columns: $1;\ngrid-gap: $2;$0', desc = 'Grid container', filetype = 'css' },
    { prefix = 'anim', body = 'animation: $1 $2s $3;$0', desc = 'Animation', filetype = 'css' },
    { prefix = 'keyf', body = '@keyframes $1 {\n\t0% {\n\t\t$2\n\t}\n\t100% {\n\t\t$0\n\t}\n}', desc = 'Keyframes', filetype = 'css' },
    { prefix = 'trans', body = 'transition: $1 $2s $3;$0', desc = 'Transition', filetype = 'css' },
    { prefix = 'center', body = 'display: flex;\njustify-content: center;\nalign-items: center;$0', desc = 'Center with flexbox', filetype = 'css' },
    { prefix = 'pseudo', body = '&:$1 {\n\t$0\n}', desc = 'Pseudo-class', filetype = 'css' },

    -- Dart
    { prefix = 'td', body = '// TODO: $0', desc = 'TODO comment', filetype = 'dart' },
    { prefix = 'slw', body = 'class $1 extends StatelessWidget {\n\tconst $1({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn $0;\n\t}\n}', desc = 'StatelessWidget', filetype = 'dart' },
    { prefix = 'sfw', body = 'class $1 extends StatefulWidget {\n\tconst $1({super.key});\n\n\t@override\n\tState<$1> createState() => _$1State();\n}\n\nclass _$1State extends State<$1> {\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn $0;\n\t}\n}', desc = 'StatefulWidget', filetype = 'dart' },
    { prefix = 'bld', body = '@override\nWidget build(BuildContext context) {\n\treturn $0;\n}', desc = 'Build method', filetype = 'dart' },
    { prefix = 'async', body = 'Future<$1> $2() async {\n\t$0\n}', desc = 'Async function', filetype = 'dart' },
    { prefix = 'future', body = 'FutureBuilder<$1>(\n\tfuture: $2,\n\tbuilder: (context, snapshot) {\n\t\tif (snapshot.hasData) {\n\t\t\treturn $3;\n\t\t}\n\t\treturn const CircularProgressIndicator();\n\t},\n)', desc = 'FutureBuilder widget', filetype = 'dart' },
    { prefix = 'stream', body = 'StreamBuilder<$1>(\n\tstream: $2,\n\tbuilder: (context, snapshot) {\n\t\tif (snapshot.hasData) {\n\t\t\treturn $3;\n\t\t}\n\t\treturn const CircularProgressIndicator();\n\t},\n)', desc = 'StreamBuilder widget', filetype = 'dart' },
    { prefix = 'p', body = 'print(\'$0\');', desc = 'Print statement', filetype = 'dart' },
    { prefix = 'db', body = 'debugPrint(\'$0\');', desc = 'Debug print', filetype = 'dart' },
    { prefix = 'tc', body = 'try {\n\t$1\n} catch (e) {\n\t$0\n}', desc = 'Try-catch block', filetype = 'dart' },

    -- Haskell
    { prefix = 'td', body = '-- TODO: $0', desc = 'TODO comment', filetype = 'haskell' },
    { prefix = 'main', body = 'main :: IO ()\nmain = do\n\t$0', desc = 'Main function', filetype = 'haskell' },
    { prefix = 'fn', body = '$1 :: $2\n$1 $3 = $0', desc = 'Function definition', filetype = 'haskell' },
    { prefix = 'data', body = 'data $1 = $2\n\tderiving (Show, Eq)', desc = 'Data type', filetype = 'haskell' },
    { prefix = 'nty', body = 'newtype $1 = $1 $2\n\tderiving (Show, Eq)', desc = 'Newtype definition', filetype = 'haskell' },
    { prefix = 'cl', body = 'class $1 a where\n\t$0', desc = 'Type class', filetype = 'haskell' },
    { prefix = 'inst', body = 'instance $1 $2 where\n\t$0', desc = 'Type class instance', filetype = 'haskell' },
    { prefix = 'co', body = 'case $1 of\n\t$2 -> $3\n\t_ -> $0', desc = 'Case expression', filetype = 'haskell' },
    { prefix = 'wh', body = 'where\n\t$0', desc = 'Where clause', filetype = 'haskell' },
    { prefix = 'let', body = 'let $1 = $2\n in $0', desc = 'Let expression', filetype = 'haskell' },

    -- HTML
    { prefix = 'td', body = '<!-- TODO: $0 -->', desc = 'TODO comment', filetype = 'html' },
    { prefix = 'com', body = '<!-- $0 -->', desc = 'Comment', filetype = 'html' },
    { prefix = 'div', body = '<div>$0</div>', desc = 'Div tag', filetype = 'html' },
    { prefix = 'p', body = '<p>$0</p>', desc = 'P tag', filetype = 'html' },
    { prefix = 'script', body = '<script>\n\t$0\n</script>', desc = 'Script tag', filetype = 'html' },
    { prefix = 'img', body = '<img src="$0"/>', desc = 'Img tag', filetype = 'html' },
    { prefix = 'link', body = '<a href="$1">$2</a>$0', desc = 'Link tag', filetype = 'html' },
    { prefix = 'btn', body = '<button type="$1">$0</button>', desc = 'Button', filetype = 'html' },
    { prefix = 'input', body = '<input type="$1" name="$2" placeholder="$3" />', desc = 'Input field', filetype = 'html' },
    { prefix = 'span', body = '<span>$0</span>', desc = 'Span tag', filetype = 'html' },
    { prefix = 'tag', body = '<$1>$0</$1>', desc = 'Generic tag', filetype = 'html' },
    { prefix = 'doc', body = '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<link rel="stylesheet" href="style.css" />\n\t<title>$1</title>\n</head>\n<body>\n\t$0\n</body>\n</html>', desc = 'Html document', filetype = 'html' },

    -- JavaScript
    { prefix = 'td', body = '// TODO: $0', desc = 'TODO comment', filetype = 'javascript' },
    { prefix = 'mlc', body = '/**\n * $0\n */', desc = 'Multi-line comment', filetype = 'javascript' },
    { prefix = 'fn', body = 'function $1($2) {\n\t$0\n}', desc = 'Function', filetype = 'javascript' },
    { prefix = 'af', body = 'const $1 = ($2) => {\n\t$0\n}', desc = 'Arrow function', filetype = 'javascript' },
    { prefix = 'afn', body = 'async function $1($2) {\n\t$0\n}', desc = 'Async function', filetype = 'javascript' },
    { prefix = 'aaf', body = 'const $1 = async ($2) => {\n\t$0\n}', desc = 'Async arrow function', filetype = 'javascript' },
    { prefix = 'p', body = 'console.log($0)', desc = 'Console log', filetype = 'javascript' },
    { prefix = 'db', body = 'console.debug($0)', desc = 'Console debug', filetype = 'javascript' },
    { prefix = 'if', body = 'if ($1) {\n\t$0\n}', desc = 'If statement', filetype = 'javascript' },
    { prefix = 'ie', body = 'if ($1) {\n\t$2\n} else {\n\t$0\n}', desc = 'If-else statement', filetype = 'javascript' },
    { prefix = 'ieie', body = 'if ($1) {\n\t$2\n} else if ($3) {\n\t$4\n} else {\n\t$0\n}', desc = 'If-elseif-else statement', filetype = 'javascript' },
    { prefix = 'for', body = 'for (let $1 = 0; $1 < $2; $1++) {\n\t$0\n}', desc = 'For loop', filetype = 'javascript' },
    { prefix = 'fori', body = 'for (const $1 in $2) {\n\t$0\n}', desc = 'For-in loop', filetype = 'javascript' },
    { prefix = 'foro', body = 'for (const $1 of $2) {\n\t$0\n}', desc = 'For-of loop', filetype = 'javascript' },
    { prefix = 'fore', body = '$1.forEach(($2) => {\n\t$0\n});', desc = 'ForEach loop', filetype = 'javascript' },
    { prefix = 'wl', body = 'while ($1) {\n\t$0\n}', desc = 'While loop', filetype = 'javascript' },
    { prefix = 'tc', body = 'try {\n\t$1\n} catch (error) {\n\t$0\n}', desc = 'Try-catch block', filetype = 'javascript' },
    { prefix = 'prom', body = 'new Promise((resolve, reject) => {\n\t$0\n})', desc = 'Promise', filetype = 'javascript' },
    { prefix = 'cl', body = 'class $1 {\n\tconstructor($2) {\n\t\t$3\n\t}\n\n\t$0\n}', desc = 'Class definition', filetype = 'javascript' },
    { prefix = 'pcl', body = 'export class $1 {\n\tconstructor($2) {\n\t\t$3\n\t}\n\n\t$0\n}', desc = 'Export class definition', filetype = 'javascript' },
    { prefix = 'sw', body = 'switch ($1) {\n\tcase $2:\n\t\t$3\n\t\tbreak;\n\tdefault:\n\t\t$0\n\t\tbreak;\n}', desc = 'Switch statement', filetype = 'javascript' },
    { prefix = 'ip', body = 'import $1 from \'$2\';$0', desc = 'Import statement', filetype = 'javascript' },
    { prefix = 'ipd', body = 'import { $1 } from \'$2\';$0', desc = 'Import destructured', filetype = 'javascript' },
    { prefix = 'ep', body = 'export default $0', desc = 'Export default', filetype = 'javascript' },
    { prefix = 'epn', body = 'export const $1 = $0', desc = 'Export named', filetype = 'javascript' },
    { prefix = 'dso', body = 'const { $1 } = $2;$0', desc = 'Destructure object', filetype = 'javascript' },
    { prefix = 'dsa', body = 'const [$1] = $2;$0', desc = 'Destructure array', filetype = 'javascript' },

    -- JSON
    { prefix = 'kv', body = '"$1": $2,$0', desc = 'Key-value', filetype = 'json' },
    { prefix = 'kvs', body = '"$1": "$2",$0', desc = 'Key-value string', filetype = 'json' },
    { prefix = 'kvo', body = '"$1": { "$2": $0 },', desc = 'Key-value object', filetype = 'json' },
    { prefix = 'kva', body = '"$1": [$2],$0', desc = 'Key-value array', filetype = 'json' },
    { prefix = 'obj', body = '{ "$1": $0 }', desc = 'JSON object', filetype = 'json' },
    { prefix = 'arr', body = '[$0]', desc = 'JSON array', filetype = 'json' },

    -- Lua
    { prefix = 'td', body = '-- TODO: $0', desc = 'TODO comment', filetype = 'lua' },
    { prefix = 'mlc', body = '--[[\n\t$0\n]]--', desc = 'Multi-line comment', filetype = 'lua' },
    { prefix = 'p', body = 'print($0)', desc = 'Print', filetype = 'lua' },
    { prefix = 'fn', body = 'function $1($2)\n\t$0\nend', desc = 'Function', filetype = 'lua' },
    { prefix = 'lf', body = 'local function $1($2)\n\t$0\nend', desc = 'Local function', filetype = 'lua' },
    { prefix = 'if', body = 'if $1 then\n\t$0\nend', desc = 'If statement', filetype = 'lua' },
    { prefix = 'ie', body = 'if $1 then\n\t$2\nelse\n\t$0\nend', desc = 'If-else statement', filetype = 'lua' },
    { prefix = 'ieie', body = 'if $1 then\n\t$2\nelseif $3 then\n\t$4\nelse\n\t$0\nend', desc = 'If-elseif-else statement', filetype = 'lua' },
    { prefix = 'req', body = "require('$1')", desc = 'Require', filetype = 'lua' },
    { prefix = 'for', body = 'for $1 = $2, $3 do\n\t$0\nend', desc = 'Numeric for loop', filetype = 'lua' },
    { prefix = 'forp', body = 'for $1, $2 in pairs($3) do\n\t$0\nend', desc = 'For pairs loop', filetype = 'lua' },
    { prefix = 'fori', body = 'for $1, $2 in ipairs($3) do\n\t$0\nend', desc = 'For ipairs loop', filetype = 'lua' },
    { prefix = 'wl', body = 'while $1 do\n\t$0\nend', desc = 'While loop', filetype = 'lua' },
    { prefix = 'dw', body = 'repeat\n\t$1\nuntil $0', desc = 'Repeat-until loop', filetype = 'lua' },
    { prefix = 'tbl', body = 'local $1 = { $0 }', desc = 'Table definition', filetype = 'lua' },
    { prefix = 'lvi', body = 'local $1 = vim.$0', desc = 'Local vim variable', filetype = 'lua' },
    { prefix = 'pcall', body = 'local ok, result = pcall($1)\nif ok then\n\t$0\nend', desc = 'Protected call', filetype = 'lua' },

    -- Nix
    { prefix = 'td', body = '# TODO: $0', desc = 'TODO comment', filetype = 'nix' },
    { prefix = 'mlc', body = '/**\n * $0\n */', desc = 'Multi-line comment', filetype = 'nix' },
    { prefix = 'li', body = 'let\n\t$1\nin\n\t$0', desc = 'Let-in expression', filetype = 'nix' },
    { prefix = 'mkdrv', body = 'stdenv.mkDerivation {\n\tpname = "$1";\n\tversion = "$2";\n\n\tsrc = $3;\n\n\tbuildInputs = [ $4 ];\n\n\t$0\n}', desc = 'mkDerivation', filetype = 'nix' },
    { prefix = 'fetchgit', body = 'fetchFromGitHub {\n\towner = "$1";\n\trepo = "$2";\n\trev = "$3";\n\tsha256 = "$0";\n}', desc = 'fetchFromGitHub', filetype = 'nix' },
    { prefix = 'sh', body = 'mkShell {\n\tbuildInputs = [\n\t\t$0\n\t];\n}', desc = 'mkShell', filetype = 'nix' },
    { prefix = 'inh', body = 'inherit ($1) $0;', desc = 'Inherit from set', filetype = 'nix' },
    { prefix = 'with', body = 'with $1; [\n\t$0\n]', desc = 'With expression', filetype = 'nix' },
    { prefix = 'overlay', body = 'final: prev: {\n\t$1 = prev.$1.overrideAttrs (old: {\n\t\t$0\n\t});\n}', desc = 'Nixpkgs overlay', filetype = 'nix' },
    { prefix = 'fn', body = '{ $1 }:\n$0', desc = 'Lambda function', filetype = 'nix' },
    { prefix = 'ie', body = 'if $1 then $2 else $0', desc = 'If-else statement', filetype = 'nix' },
    { prefix = 'ieie', body = 'if $1 then $2 else if $3 then $4 else $0', desc = 'If-elseif-else statement', filetype = 'nix' },

    -- Rust
    { prefix = 'td', body = '// TODO: $0', desc = 'TODO comment', filetype = 'rust' },
    { prefix = 'mlc', body = '/**\n * $0\n */', desc = 'Multi-line comment', filetype = 'rust' },
    { prefix = 'p', body = 'println!("$0");', desc = 'Println', filetype = 'rust' },
    { prefix = 'db', body = 'dbg!($0);', desc = 'Debug macro', filetype = 'rust' },
    { prefix = 'pan', body = 'panic!("$0");', desc = 'Panic macro', filetype = 'rust' },
    { prefix = 'fn', body = 'fn $1($2) -> $3 {\n\t$0\n}', desc = 'Function', filetype = 'rust' },
    { prefix = 'pfn', body = 'pub fn $1($2) -> $3 {\n\t$0\n}', desc = 'Public function', filetype = 'rust' },
    { prefix = 'if', body = 'if $1 {\n\t$0\n}', desc = 'If statement', filetype = 'rust' },
    { prefix = 'ie', body = 'if $1 {\n\t$2\n} else {\n\t$0\n}', desc = 'If-else statement', filetype = 'rust' },
    { prefix = 'ieie', body = 'if $1 {\n\t$2\n} else if $3 {\n\t$4\n} else {\n\t$0\n}', desc = 'If-elseif-else statement', filetype = 'rust' },
    { prefix = 'ma', body = 'match $1 {\n\t$2 => $3,\n\t_ => $0,\n}', desc = 'Match expression', filetype = 'rust' },
    { prefix = 'ifl', body = 'if let $1 = $2 {\n\t$0\n}', desc = 'If let statement', filetype = 'rust' },
    { prefix = 'wlt', body = 'while let $1 = $2 {\n\t$0\n}', desc = 'While let loop', filetype = 'rust' },
    { prefix = 'for', body = 'for $1 in $2 {\n\t$0\n}', desc = 'For loop', filetype = 'rust' },
    { prefix = 'loop', body = 'loop {\n\t$0\n}', desc = 'Infinite loop', filetype = 'rust' },
    { prefix = 'wl', body = 'while $1 {\n\t$0\n}', desc = 'While loop', filetype = 'rust' },
    { prefix = 'tc', body = 'match $1 {\n\tOk($2) => $3,\n\tErr(e) => $0,\n}', desc = 'Result match (try-catch)', filetype = 'rust' },
    { prefix = 'ot', body = 'Option<$1>', desc = 'Option type', filetype = 'rust' },
    { prefix = 's', body = 'String::new()$0', desc = 'New empty String', filetype = 'rust' },
    { prefix = 'sf', body = 'String::from($1)$0', desc = 'String from value', filetype = 'rust' },
    { prefix = 'v', body = 'vec![]$0', desc = 'Vec macro', filetype = 'rust' },
    { prefix = 'vt', body = 'Vec<$1>$0', desc = 'Vec type', filetype = 'rust' },
    { prefix = 'lvn', body = 'let mut $1 = Vec::new();$0', desc = 'New Vec', filetype = 'rust' },
    { prefix = 'dr', body = '#[derive($1)]$0', desc = 'Derive macro', filetype = 'rust' },
    { prefix = 'drc', body = '#[derive(Clone, Copy, Debug, $1)]$0', desc = 'Derive macro (Clone, Copy, Debug)', filetype = 'rust' },
    { prefix = 'mod', body = 'mod $1 {\n\t$0\n}', desc = 'Module definition', filetype = 'rust' },
    { prefix = 'st', body = 'struct $1 {\n\t$0\n}', desc = 'Struct definition', filetype = 'rust' },
    { prefix = 'pst', body = 'pub struct $1 {\n\t$0\n}', desc = 'Public struct definition', filetype = 'rust' },
    { prefix = 'en', body = 'enum $1 {\n\t$0\n}', desc = 'Enum definition', filetype = 'rust' },
    { prefix = 'pen', body = 'pub enum $1 {\n\t$0\n}', desc = 'Public enum definition', filetype = 'rust' },
    { prefix = 'trt', body = 'trait $1 {\n\t$0\n}', desc = 'Trait definition', filetype = 'rust' },
    { prefix = 'ptrt', body = 'pub trait $1 {\n\t$0\n}', desc = 'Public trait definition', filetype = 'rust' },
    { prefix = 'test', body = '#[test]\nfn $1() {\n\t$0\n}', desc = 'Test function', filetype = 'rust' },
    { prefix = 'impl', body = 'impl $1 {\n\t$0\n}', desc = 'Impl block', filetype = 'rust' },
    { prefix = 'implf', body = 'impl $1 for $2 {\n\t$0\n}', desc = 'Impl trait for type', filetype = 'rust' },
    { prefix = 'res', body = 'Result<$1, $2>', desc = 'Result type', filetype = 'rust' },
    { prefix = 'uhm', body = 'use std::collections::HashMap;$0', desc = 'Import HashMap', filetype = 'rust' },
    { prefix = 'uhs', body = 'use std::collections::HashSet;$0', desc = 'Import HashSet', filetype = 'rust' },
    { prefix = 'uvd', body = 'use std::collections::VecDeque;$0', desc = 'Import VecDeque', filetype = 'rust' },
    { prefix = 'ue', body = 'use std::error::Error;$0', desc = 'Import Error', filetype = 'rust' },
    { prefix = 'ua', body = 'use std::sync::Arc;$0', desc = 'Import Arc', filetype = 'rust' },
    { prefix = 'um', body = 'use std::sync::Mutex;$0', desc = 'Import Mutex', filetype = 'rust' },
    { prefix = 'uf', body = 'use std::fmt;$0', desc = 'Import fmt (Display, Debug)', filetype = 'rust' },

    -- SCSS
    { prefix = 'td', body = '/* TODO: $0 */', desc = 'TODO comment', filetype = 'scss' },
    { prefix = 'com', body = '/* $0 */', desc = 'Comment', filetype = 'scss' },
    { prefix = 'mlc', body = '/**\n * $0\n */', desc = 'Multi-line comment', filetype = 'scss' },
    { prefix = 'cl', body = '.$1 {\n\t$2: $0;\n}', desc = 'Class', filetype = 'scss' },
    { prefix = 'id', body = '#$1 {\n\t$2: $0;\n}', desc = 'Id', filetype = 'scss' },
    { prefix = 'media', body = '@media ($1) {\n\t$0\n}', desc = 'Media query', filetype = 'scss' },
    { prefix = 'mediamin', body = '@media (min-width: $1px) {\n\t$0\n}', desc = 'Media query (min-width)', filetype = 'scss' },
    { prefix = 'flex', body = 'display: flex;\njustify-content: $1;\nalign-items: $2;$0', desc = 'Flexbox container', filetype = 'scss' },
    { prefix = 'grid', body = 'display: grid;\ngrid-template-columns: $1;\ngrid-gap: $2;$0', desc = 'Grid container', filetype = 'scss' },
    { prefix = 'anim', body = 'animation: $1 $2s $3;$0', desc = 'Animation', filetype = 'scss' },
    { prefix = 'keyf', body = '@keyframes $1 {\n\t0% {\n\t\t$2\n\t}\n\t100% {\n\t\t$0\n\t}\n}', desc = 'Keyframes', filetype = 'scss' },
    { prefix = 'trans', body = 'transition: $1 $2s $3;$0', desc = 'Transition', filetype = 'scss' },
    { prefix = 'center', body = 'display: flex;\njustify-content: center;\nalign-items: center;$0', desc = 'Center with flexbox', filetype = 'scss' },
    { prefix = 'pseudo', body = '&:$1 {\n\t$0\n}', desc = 'Pseudo-class', filetype = 'scss' },
    { prefix = 'v', body = '$$1: $2;$0', desc = 'SCSS variable', filetype = 'scss' },
    { prefix = 'nest', body = '$1 {\n\t$0\n}', desc = 'Nested selector', filetype = 'scss' },
    { prefix = 'mixin', body = '@mixin $1($2) {\n\t$0\n}', desc = 'Mixin definition', filetype = 'scss' },
    { prefix = 'mixinc', body = '@include $1($2);$0', desc = 'Mixin include', filetype = 'scss' },
    { prefix = 'extend', body = '@extend $1;$0', desc = 'Extend selector', filetype = 'scss' },
    { prefix = 'ip', body = '@import \'$1\';$0', desc = 'Import file', filetype = 'scss' },
    { prefix = 'fn', body = '@function $1($2) {\n\t@return $0;\n}', desc = 'Function definition', filetype = 'scss' },
    { prefix = 'each', body = '@each $$1 in $2 {\n\t$0\n}', desc = 'Each loop', filetype = 'scss' },
    { prefix = 'for', body = '@for $$1 from $2 through $3 {\n\t$0\n}', desc = 'For loop', filetype = 'scss' },
    { prefix = 'if', body = '@if $1 {\n\t$0\n}', desc = 'If statement', filetype = 'scss' },
    { prefix = 'parent', body = '& {\n\t$0\n}', desc = 'Parent selector', filetype = 'scss' },

    -- SQL
    { prefix = 'td', body = '-- TODO: $0', desc = 'TODO comment', filetype = 'sql' },
    { prefix = 'sel', body = 'SELECT $1\nFROM $2\nWHERE $0;', desc = 'SELECT statement', filetype = 'sql' },
    { prefix = 'sela', body = 'SELECT *\nFROM $1\nWHERE $0;', desc = 'SELECT all', filetype = 'sql' },
    { prefix = 'ins', body = 'INSERT INTO $1 ($2)\nVALUES ($0);', desc = 'INSERT statement', filetype = 'sql' },
    { prefix = 'upd', body = 'UPDATE $1\nSET $2 = $3\nWHERE $0;', desc = 'UPDATE statement', filetype = 'sql' },
    { prefix = 'del', body = 'DELETE FROM $1\nWHERE $0;', desc = 'DELETE statement', filetype = 'sql' },
    { prefix = 'ctbl', body = 'CREATE TABLE $1 (\n\tid INTEGER PRIMARY KEY,\n\t$0\n);', desc = 'CREATE TABLE', filetype = 'sql' },
    { prefix = 'lj', body = 'SELECT $1\nFROM $2\nLEFT JOIN $3 ON $2.$4 = $3.$5\nWHERE $0;', desc = 'LEFT JOIN', filetype = 'sql' },
    { prefix = 'rj', body = 'SELECT $1\nFROM $2\nINNER JOIN $3 ON $2.$4 = $3.$5\nWHERE $0;', desc = 'INNER JOIN', filetype = 'sql' },
    { prefix = 'cte', body = 'WITH $1 AS (\n\t$2\n)\nSELECT $3\nFROM $1\nWHERE $0;', desc = 'Common Table Expression', filetype = 'sql' },

    -- TOML
    { prefix = 'td', body = '# TODO: $0', desc = 'TODO comment', filetype = 'toml' },
    { prefix = 'kv', body = '$1 = $2$0', desc = 'Key-value', filetype = 'toml' },
    { prefix = 'kvs', body = '$1 = "$2"$0', desc = 'Key-value string', filetype = 'toml' },
    { prefix = 'arr', body = '$1 = [\n  $0\n]', desc = 'TOML array', filetype = 'toml' },
    { prefix = 'tbl', body = '[$1.$2]\n$0', desc = 'TOML nested table', filetype = 'toml' },
    { prefix = 'tbli', body = '$1 = { $2 = "$3" }$0', desc = 'TOML inline table', filetype = 'toml' },
    { prefix = 'tbla', body = '[[$1]]\n$0', desc = 'Array of tables', filetype = 'toml' },
    { prefix = 'sec', body = '[$1]\n$0', desc = 'TOML section', filetype = 'toml' },

    -- TypeScript
    { prefix = 'td', body = '// TODO: $0', desc = 'TODO comment', filetype = 'typescript' },
    { prefix = 'mlc', body = '/**\n * $0\n */', desc = 'Multi-line comment', filetype = 'typescript' },
    { prefix = 'fn', body = 'function $1($2): $3 {\n\t$0\n}', desc = 'Function', filetype = 'typescript' },
    { prefix = 'af', body = 'const $1 = ($2): $3 => {\n\t$0\n}', desc = 'Arrow function', filetype = 'typescript' },
    { prefix = 'afn', body = 'async function $1($2): Promise<$3> {\n\t$0\n}', desc = 'Async function', filetype = 'typescript' },
    { prefix = 'aaf', body = 'const $1 = async ($2): Promise<$3> => {\n\t$0\n}', desc = 'Async arrow function', filetype = 'typescript' },
    { prefix = 'p', body = 'console.log($0)', desc = 'Console log', filetype = 'typescript' },
    { prefix = 'db', body = 'console.debug($0)', desc = 'Console debug', filetype = 'typescript' },
    { prefix = 'if', body = 'if ($1) {\n\t$0\n}', desc = 'If statement', filetype = 'typescript' },
    { prefix = 'ie', body = 'if ($1) {\n\t$2\n} else {\n\t$0\n}', desc = 'If-else statement', filetype = 'typescript' },
    { prefix = 'ieie', body = 'if ($1) {\n\t$2\n} else if ($3) {\n\t$4\n} else {\n\t$0\n}', desc = 'If-elseif-else statement', filetype = 'typescript' },
    { prefix = 'for', body = 'for (let $1 = 0; $1 < $2; $1++) {\n\t$0\n}', desc = 'For loop', filetype = 'typescript' },
    { prefix = 'fori', body = 'for (const $1 in $2) {\n\t$0\n}', desc = 'For-in loop', filetype = 'typescript' },
    { prefix = 'foro', body = 'for (const $1 of $2) {\n\t$0\n}', desc = 'For-of loop', filetype = 'typescript' },
    { prefix = 'fore', body = '$1.forEach(($2) => {\n\t$0\n});', desc = 'ForEach loop', filetype = 'typescript' },
    { prefix = 'wl', body = 'while ($1) {\n\t$0\n}', desc = 'While loop', filetype = 'typescript' },
    { prefix = 'tc', body = 'try {\n\t$1\n} catch (error) {\n\t$0\n}', desc = 'Try-catch block', filetype = 'typescript' },
    { prefix = 'prom', body = 'new Promise((resolve, reject) => {\n\t$0\n})', desc = 'Promise', filetype = 'typescript' },
    { prefix = 'cl', body = 'class $1 {\n\tconstructor($2) {\n\t\t$3\n\t}\n\n\t$0\n}', desc = 'Class definition', filetype = 'typescript' },
    { prefix = 'pcl', body = 'export class $1 {\n\tconstructor($2) {\n\t\t$3\n\t}\n\n\t$0\n}', desc = 'Export class definition', filetype = 'typescript' },
    { prefix = 'ip', body = 'import $1 from \'$2\';$0', desc = 'Import statement', filetype = 'typescript' },
    { prefix = 'ipd', body = 'import { $1 } from \'$2\';$0', desc = 'Import destructured', filetype = 'typescript' },
    { prefix = 'ep', body = 'export default $0', desc = 'Export default', filetype = 'typescript' },
    { prefix = 'epn', body = 'export const $1: $2 = $0', desc = 'Export named', filetype = 'typescript' },
    { prefix = 'dso', body = 'const { $1 } = $2;$0', desc = 'Destructure object', filetype = 'typescript' },
    { prefix = 'dsa', body = 'const [$1] = $2;$0', desc = 'Destructure array', filetype = 'typescript' },
    { prefix = 'int', body = 'interface $1 {\n\t$0\n}', desc = 'Interface', filetype = 'typescript' },
    { prefix = 'pint', body = 'export interface $1 {\n\t$0\n}', desc = 'Export interface', filetype = 'typescript' },
    { prefix = 'ty', body = 'type $1 = $0', desc = 'Type alias', filetype = 'typescript' },
    { prefix = 'pty', body = 'export type $1 = $0', desc = 'Export type alias', filetype = 'typescript' },
    { prefix = 'en', body = 'enum $1 {\n\t$0\n}', desc = 'Enum definition', filetype = 'typescript' },
    { prefix = 'pen', body = 'export enum $1 {\n\t$0\n}', desc = 'Export enum', filetype = 'typescript' },
    { prefix = 'sw', body = 'switch ($1) {\n\tcase $2:\n\t\t$3\n\t\tbreak;\n\tdefault:\n\t\t$0\n\t\tbreak;\n}', desc = 'Switch statement', filetype = 'typescript' },
    { prefix = 'ipt', body = 'import type { $1 } from \'$2\';$0', desc = 'Import type', filetype = 'typescript' },

    -- YAML
    { prefix = 'td', body = '# TODO: $0', desc = 'TODO comment', filetype = 'yaml' },
    { prefix = 'kv', body = '$1: $2$0', desc = 'YAML key-value', filetype = 'yaml' },
    { prefix = 'kvs', body = '$1: "$2"$0', desc = 'YAML key-value string', filetype = 'yaml' },
    { prefix = 'obj', body = '$1:\n\t$2: $0', desc = 'YAML nested object', filetype = 'yaml' },
    { prefix = 'arr', body = '- $0', desc = 'YAML array item', filetype = 'yaml' },
    { prefix = 'mlsl', body = '$1: |\n\t$0', desc = 'YAML multiline string (literal)', filetype = 'yaml' },
    { prefix = 'mlsf', body = '$1: >\n\t$0', desc = 'YAML multiline string (folded)', filetype = 'yaml' },
    { prefix = 'ls', body = '$1:\n\t- $0', desc = 'YAML list', filetype = 'yaml' },
    { prefix = 'anc', body = '$1: &$2\n\t$0', desc = 'YAML anchor', filetype = 'yaml' },
    { prefix = 'al', body = '<<: *$1$0', desc = 'YAML alias', filetype = 'yaml' },
  }

  -- Filter snippets based on current language/filetype
  local result = {}
  for _, snip in ipairs(all_snippets) do
    -- Include snippet if it has no filetype (global) or matches current language
    if not snip.filetype or snip.filetype == context.lang then
      local filtered_snip = { prefix = snip.prefix, body = snip.body, desc = snip.desc }
      table.insert(result, filtered_snip)
    end
  end

  return result
end

snippets.setup({
  snippets = {
    custom_snippets,
  },

  mappings = {
    expand = '<Tab>',
    jump_next = '<Tab>',
    jump_prev = '<S-Tab>',
    stop = '<CR>',
  },
})

-- Start LSP server to expose snippets to completion menu
snippets.start_lsp_server()
