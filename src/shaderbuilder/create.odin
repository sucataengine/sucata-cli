package shader_builder

import "core:os"

QUAD_DEFAULT: string = `/* quad vertex shader */
@vs vs
layout(binding=0) uniform vs_params {
    mat4 mvp;
};

in vec2 position;
in vec4 color;
in vec2 uv;

out vec4 texcolor;
out vec2 texcoord;

void main() {
    gl_Position = mvp * vec4(position, 0.0, 1.0);
    texcolor = color;
    texcoord = uv;
}
@end

/* quad fragment shader */
@fs fs
layout(binding=0) uniform texture2D source_texture;
layout(binding=0) uniform sampler source_sampler;

in vec4 texcolor;
in vec2 texcoord;

out vec4 frag_color;

void main() {
    vec4 tex_color = texture(sampler2D(source_texture,source_sampler), texcoord);
    vec4 final_color = tex_color * texcolor;
    
    frag_color = final_color;
}
@end

/* quad shader program */
@program quad vs fs
`


FONT_DEFAULT: string = `/* text vertex shader */
@vs vs
layout(binding=0) uniform vs_params {
    mat4 mvp;
};

in vec2 position;
in vec4 color;
in vec2 uv;

out vec4 texcolor;
out vec2 texcoord;

void main() {
    gl_Position = mvp * vec4(position, 0.0, 1.0);
    texcolor = color;
    texcoord = uv;
}
@end

/* text fragment shader */
@fs fs
layout(binding=0) uniform texture2D source_texture;
layout(binding=0) uniform sampler source_sampler;

in vec4 texcolor;
in vec2 texcoord;

out vec4 frag_color;

void main() {
    vec4 tex_color = texture(sampler2D(source_texture,source_sampler), texcoord);
    float alpha = tex_color.r * color.a;
    frag_color = vec4(color.rgb, alpha);
}
@end

/* text shader program */
@program text vs fs
`


POST_PROCESSING_DEFAULT: string = `/* post-processing vertex shader */
@vs vs
in vec2 position;
in vec2 uv;

out vec2 texcoord;

void main() {
    gl_Position = vec4(position, 0.0, 1.0);
    texcoord    = uv;
}
@end

@fs fs
layout(binding=0) uniform texture2D screen_texture;
layout(binding=0) uniform sampler   screen_sampler;

in  vec2 texcoord;
out vec4 frag_color;

void main() {
    frag_color = texture(sampler2D(screen_texture, screen_sampler), texcoord);
}
@end

@program shader_post_processing vs fs`


create_default_quad :: proc(path: string) {
	bytes := transmute([]u8)QUAD_DEFAULT
	_ = os.write_entire_file(path, bytes)
}

create_default_post_processing :: proc(path: string) {
	bytes := transmute([]u8)POST_PROCESSING_DEFAULT
	_ = os.write_entire_file(path, bytes)
}

create_default_font_shader :: proc(path: string) {
	bytes := transmute([]u8)FONT_DEFAULT
	_ = os.write_entire_file(path, bytes)
}
