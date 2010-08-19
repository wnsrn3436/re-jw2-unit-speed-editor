//마우스가 닿았는지 체크

if ((mouse_x>=argument0 && mouse_x<=argument2) || (mouse_x<=argument0 && mouse_x>=argument2)) && ((mouse_y>=argument1 && mouse_y<=argument3) || (mouse_y<=argument1 && mouse_y>=argument3))
{
return 1
}
return 0

// sk_mouse_check(x, y, x2, y2)
