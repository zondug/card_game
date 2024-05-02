shader_type canvas_item;

uniform bool is_hovered = false;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 5.0;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    
    if (is_hovered) {
        vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
        
        float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
        outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
        outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
        outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
        outline = min(outline, 1.0);
        
        COLOR = mix(original_color, outline_color, outline - original_color.a);
    } else {
        COLOR = original_color;
    }
}