--!nolint TableOperations

local ffi = require("@lune/ffi")
local markdown_rs = {} :: markdown_rs
markdown_rs.__index = markdown_rs

export type markdown_rs = markdown_rs_pub & markdown_rs_private
export type markdown_rs_pub = {
	to_html: (self: markdown_rs, code: string) -> string,
}
export type markdown_rs_private = {
	_lib: ffi.LibData,
	_to_html: ffi.CallableData,
}

local result_t = ffi.c.struct({
	-- len
	ffi.i32,
	-- ptr
	ffi.u8:ptr(),
})

function markdown_rs.new(lib_path: string): markdown_rs
	local self = setmetatable({}, markdown_rs)
	self._lib = ffi.open(lib_path)
	self._to_html = ffi.c
		.fn({ ffi.u8:ptr(), ffi.i32 }, result_t)
		:callable(self._lib:find("to_html"))
	return self
end

function markdown_rs:to_html(code: string): string
	local source = ffi.box(#code):writeString(code)
	local result = ffi.box(result_t.size)
	self._to_html(
		result,
		source:ref():ref(),
		ffi.i32:box(#code):ref()
	)
	local result_table = result_t:readData(result)
	local result_string = result_table[2]:readString(result_table[1])
	ffi.free(result_table[2])
	return result_string
end

return markdown_rs :: { new: (libpath: string) -> markdown_rs_pub }
