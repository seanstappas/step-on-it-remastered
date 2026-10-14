shader_type canvas_item;

// p3_tint.gdshader — Crimson Red palette remapping for Player 3 in Step On It! Remastered
// Remaps blue/green player tunic & block pixels into Crimson Red (#E53935 highlight, #8E0000 shadow)

uniform vec4 target_highlight : source_color = vec4(0.898, 0.224, 0.208, 1.0); // #E53935
uniform vec4 target_shadow : source_color = vec4(0.557, 0.0, 0.0, 1.0);        // #8E0000

void fragment() {
    vec4 c = texture(TEXTURE, UV);
    if (c.a < 0.01) {
        COLOR = c;
    } else {
        // Identify blue/cyan tunic tones where blue/cyan dominates over red
        float max_bg = max(c.g, c.b);
        if (max_bg > c.r * 1.25 && max_bg > 0.15) {
            float luma = 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
            vec4 red_tint = mix(target_shadow, target_highlight, clamp(luma * 1.4, 0.0, 1.0));
            COLOR = vec4(red_tint.rgb, c.a);
        } else {
            COLOR = c;
        }
    }
}
