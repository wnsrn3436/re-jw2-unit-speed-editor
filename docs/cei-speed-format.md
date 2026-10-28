# CEI movement speed format

A Jurassic Primitive War 2 unit's movement speed is stored in the CEI file, split into blocks by direction.

| Offset | Direction |
|---|---|
| `0x3CC` | Up |
| `0x5CC` | Up-right |
| `0x7CC` | Right |
| `0x9CC` | Down-right |
| `0xBCC` | Down |
| `0xDCC` | Down-left |
| `0xFCC` | Left |
| `0x11CC` | Up-left |

Each block is `0x200` bytes. The frame count is stored as 4 bytes at `0x13D8`, twelve bytes past `0x13CC` where the speed blocks end.

Movement speed is written as 4-byte values that form 8-byte {horizontal speed, vertical speed} pairs. If the values are hard to tell apart by eye, splitting them into odd and even positions makes it easier.

Speed is applied based on the `m#.spz` move sprites in the CHR file, so every 8 bytes is the speed of one move sprite. Since one direction block is `0x200` bytes, speed values can be set for 64 move sprites at most.
