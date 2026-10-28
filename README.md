# Jurassic Primitive War 2 Unit-Speed Editor

[한국어](README.ko.md)

In Jurassic Primitive War 2, a unit's movement speed is stored per animation frame inside its stats file (CEI). This editor lists those values and lets you pick and change them.

The analysis is written up in [docs/cei-speed-format.md](docs/cei-speed-format.md).

<p>
  <img src="docs/screenshots/screenshot-1.png" width="480" alt="Speed editing screen">
</p>


## How to use

Download it from Releases, extract it and run it, and a file dialog opens right away. Pick a unit's `.cei` file and the per-frame speeds appear as a list.

Use the button in the top right to choose which of the eight directions to view. The list shows 15 entries at a time, with arrows on either side to page through.

Clicking a row prompts for the vertical direction, then the horizontal direction, and sets the value to the numbers you enter. `속도 전체변경` sets every frame of the direction currently shown to one value.

Pressing `저장` overwrites the original CEI in place. There is no way to undo this, so it is a good idea to back up the file first.


## How it works

**Speeds are stored per direction, 8 bytes per frame.** Starting at `0x3CC` in the CEI, eight direction blocks follow at `0x200` intervals, and within each block a frame is 4 bytes of horizontal speed and 4 bytes of vertical speed. Because each block is `0x200` bytes, a direction can hold at most 64 frames. The frame count is a 4-byte value at `0x13D8`, twelve bytes past `0x13CC` where the speed region ends, so the editor reads it first and scans only that many frames.

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

The `972`, `512` and `5080` in the source are all decimal. They are the same values as `0x3CC`, `0x200` and `0x13D8` in the analysis.

**Negatives are detected from the top byte.** The values are 4-byte signed integers, so a speed going left or up is stored as `FFFFFFxx`. The editor checks whether the assembled hex string starts with `FF`, and if it does, it takes `256 - low byte` as the magnitude and classes the value as left or up. Otherwise it is right or down. That is why the screen shows direction names instead of signs.

```gml
vb_read=""
repeat(4){ vb_read = sk_hex_conversion(file_bin_read_byte(vb_file)) + vb_read }

if string_delete(vb_read, 3, string_length(vb_read))="FF"
{ left[i, j] = 256 - sk_dec_conversion(string_delete(vb_read, 1, 6)) }
else
{ right[i, j] = sk_dec_conversion(string_delete(vb_read, 1, 6)) }
```

**Saving runs that conversion in reverse.** If a left or up value is present, `256 - value` is written as the low byte and the other three bytes are filled with `FF`. For right or down the value is written as is and the other three bytes get `0`. If both are 0, all four bytes are 0.

```gml
if left[i, j]!=0
{
  file_bin_write_byte(vb_file, left[i, j]+(256-(left[i, j]*2)))
  file_bin_write_byte(vb_file, 255)
  file_bin_write_byte(vb_file, 255)
  file_bin_write_byte(vb_file, 255)
}
```

One frame cannot hold both up and down, and the same goes for left and right, so filling one clears the other to 0. Input is capped at 255.


## Files

| Path | Contents |
|---|---|
| `source/jw2-unit-speed-editor.gmk` | Original project file |
| `source/split/` | Text tree produced by GmkSplitter |
| `docs/cei-speed-format.md` | CEI movement speed offset analysis |
| `docs/screenshots/` | Screenshots |
| Releases | Executable and usage notes |


## Credits

The Korean text output scripts (`source/split/Scripts/sefx_v2_0/`) were made by 김게맛 (sodium031) of the GameMaker community.


## License

zlib. See [LICENSE](LICENSE). Bundled libraries made by other people keep their own licenses.
