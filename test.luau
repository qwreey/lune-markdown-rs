local markdown_rs = require("./")
	.new(require("@lune/process").args[1] or "./target/release/liblune_markdown_rs.so")

-- Throw error if syntax error in code
local result = markdown_rs:to_html([[
# hello

**Hello** _world_ `in`

> mark

```
down
```
]])

print(result)
--[[
<h1 id='hello'>hello</h1>

<p><strong>Hello</strong> <em>world</em> <code>in</code></p>

<blockquote>
<p>mark</p>
</blockquote>

<pre><code>down</code></pre>
]]