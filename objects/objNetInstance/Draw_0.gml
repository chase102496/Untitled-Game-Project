if data != -1
{
	draw_sprite_ext(
	data.sprite_index,
	data.image_index,
	x,
	y,
	data.stats.xScale,
	data.stats.yScale,
	data.image_angle,
		make_color_hsv(
		data.stats.spriteColor[0],
		data.stats.spriteColor[1],
		data.stats.spriteColor[2]),
	data.image_alpha);
}