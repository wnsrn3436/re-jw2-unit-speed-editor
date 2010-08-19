# CEI movement speed format

A Jurassic Primitive War 2 unit's movement speed is stored in the CEI file. The per direction blocks are as follows.

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

Each block is `0x200` bytes. The frame count is stored as 4 bytes at `0x13D8`, twelve bytes past the end of the speed region at `0x13CC`.

Speed is written as 4 bytes, in {horizontal speed, vertical speed} pairs of 8 bytes. If the values are hard to read by eye, splitting them into odd and even positions makes it clearer.

Speed is applied against the `m#.spz` move sprites in the CHR file, so every 8 bytes is the speed of one move sprite. Since a direction block is `0x200` bytes, only 64 move sprites can hold a speed value.
