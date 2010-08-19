# Jurassic Primitive War 2 Unit-Speed Editor

In Jurassic Primitive War 2, a unit's movement speed is stored per animation frame inside its stats file (CEI). This editor lists those values and lets you pick and change them.

The analysis is written up in [docs/cei-speed-format.md](docs/cei-speed-format.md).

<p>
  <img src="docs/screenshots/screenshot-1.png" width="480" alt="Speed editing screen">
</p>


## How to use

Download from Releases, extract and run it, and a file dialog opens right away. Pick a unit's `.cei` and the per frame speeds appear as a list.

The button in the top right chooses which of the eight directions to view. The list shows 15 entries at a time, with arrows on either side to page through.

Click a row to change a value. It asks for the vertical direction and the horizontal direction in turn and takes a number for each. `속도 전체변경` sets every frame of the current direction to one value.

`저장` overwrites the original CEI in place. There is no undo, so back it up first.


## How it works

**Speeds are stored per direction, 8 bytes per frame.** Starting at `0x3CC` in the CEI, eight direction blocks follow at `0x200` intervals, and within each block a frame is 4 bytes of horizontal speed and 4 bytes of vertical speed. A block of `0x200` caps each direction at 64 frames. The frame count sits at `0x13D8` as a 4 byte value, twelve bytes past the end of the speed region at `0x13CC`, so that is read first and only that many frames are scanned.

```gml
file_bin_seek(vb_file, 5080)                     // 0x13D8, frame count
repeat(4){ max_h = sk_hex_conversion(file_bin_read_byte(vb_file)) + max_h }
max_d = sk_dec_conversion(max_h)

for(i=0; i!=8; i+=1)                             // eight directions
{
  file_bin_seek(vb_file, 972+(i*512))            // 0x3CC + i*0x200
  for(j=0; j!=max_d; j+=1)                       // frame count
  {
    ...
  }
}
```

The `972`, `512` and `5080` in the source are decimal. They are the same values as `0x3CC`, `0x200` and `0x13D8` in the analysis.

**Negatives are detected from the top byte.** The values are 4 byte signed integers, so a speed going left or up is stored as `FFFFFFxx`. The first two characters of the assembled hex string are checked for `FF`, and if they match the magnitude is `256 - low byte` and it is classed as left or up. Otherwise it is right or down. That is why the screen shows direction names instead of signs.

```gml
vb_read=""
repeat(4){ vb_read = sk_hex_conversion(file_bin_read_byte(vb_file)) + vb_read }

if string_delete(vb_read, 3, string_length(vb_read))="FF"
{ left[i, j] = 256 - sk_dec_conversion(string_delete(vb_read, 1, 6)) }
else
{ right[i, j] = sk_dec_conversion(string_delete(vb_read, 1, 6)) }
```

**Saving runs that conversion in reverse.** If a left or up value is present, `256 - value` goes in the low byte and the other three bytes are filled with `FF`. For right or down the value is written as is and the other three bytes are `0`. If both are 0, all four bytes are 0.

```gml
if left[i, j]!=0
{
  file_bin_write_byte(vb_file, left[i, j]+(256-(left[i, j]*2)))
  file_bin_write_byte(vb_file, 255)
  file_bin_write_byte(vb_file, 255)
  file_bin_write_byte(vb_file, 255)
}
```

One frame cannot hold both up and down, and the same goes for left and right. Filling one clears the other to 0. Input is capped at 255.


## Files

| Path | Contents |
|---|---|
| `source/jw2-unit-speed-editor.gmk` | Original project file |
| `source/split/` | Text tree produced by GmkSplitter |
| `docs/cei-speed-format.md` | CEI movement speed offset analysis |
| `docs/screenshots/` | Screenshots |
| Releases | Executable and usage notes |


## Credits

The Korean text scripts under `source/split/Scripts/sefx_v2_0/` were written by 김게맛 (sodium031) of the GameMaker community.


## License

zlib. See [LICENSE](LICENSE). Bundled libraries made by other people keep their own licenses.
