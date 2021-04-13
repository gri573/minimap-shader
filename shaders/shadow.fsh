#version 120

uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec2 midtexcoord;
varying vec4 glcolor;
varying vec3 position;

void main() {
	vec4 color = texture2D(texture, midtexcoord);
	color += float(color.a < 0.1) * texture2D(texture, texcoord);
	color *= glcolor;
	if (position.x > 900.0) discard;
	gl_FragData[0] = color;
}
