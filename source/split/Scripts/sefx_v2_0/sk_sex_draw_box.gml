//글자가포함된 박스를드로우합니다

draw_set_color(argument4)
draw_set_alpha(argument6)
draw_rectangle(argument0+5, argument1+5, argument0+10+string_length(argument2)*global.__sexwidth[0], argument1+global.__sexwidth[1]+6, 0)
draw_set_color(c_black)

draw_set_alpha(argument5)
sk_draw_kr_string(argument0+7, argument1+5, argument2, argument3)
draw_set_alpha(1)

// sk_sex_draw_box(x, y, 글자, 글자색, 박스색, 글자투명도, 박스투명도)
