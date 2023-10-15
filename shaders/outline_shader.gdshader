shader_type canvas_item;

uniform float texture_width: hint_range(0.0, 64.0);
uniform float width : hint_range(0.0, 30.0);
uniform vec4 outline_color : source_color;

void fragment() {
    float size = width / float(textureSize(TEXTURE, 0).x);
    vec4 sprite_color = texture(TEXTURE, UV);
    float alpha = -4.0 * sprite_color.a;
    alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;

    vec4 final_color = mix(sprite_color, outline_color, clamp(abs(alpha), 0.0, 1.0));

    // check if the current pixel is within `size` of the edge of the canvas
    // pixels on the edge of the texture should always be outlined
    float x_coord = UV.x * texture_width;
    float y_coord = UV.y * texture_width;
    if (x_coord - size <= 0.0 || x_coord + size >= texture_width || y_coord - size <= 0.0 || y_coord + size >= texture_width) {
        final_color = vec4(1.0, 1.0, 1.0, 1.0);
    } 

    COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
}
