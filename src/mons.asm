DEFSECT ".graphics", DATA AT 10000H
SECT    ".graphics"

global _gfx_begin
_gfx_begin:

	; zig zag
	DB 8, 4, 2, 1, 2, 4, 8, 16
