shader_type canvas_item;

uniform vec4 shade_color : source_color;

// void vertex() {
// 	// Called for every vertex the material is visible on.
// }

void fragment() {
	COLOR = min(COLOR, shade_color);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
