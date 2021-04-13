#version 120

uniform sampler2D lightmap;
uniform sampler2D texture;
uniform ivec2 atlasSize;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec2 midtexcoord;
varying vec4 glcolor;
varying vec3 position;

void main() {
	vec2 offsets[4] = vec2[4](
		vec2(-1,-1),
		vec2(-1, 1),
		vec2(1, -1),
		vec2(1, 1)
	);
	vec4 color = texture2D(texture, midtexcoord);
	int i = 0;
	while (color.a < 0.1 && i < 4) {
		vec4 color0 = float(color.a < 0.1) * texture2D(texture, midtexcoord + offsets[i] / atlasSize);
		color.rgb += color0.rgb * color0.a;
		color.a += color0.a;
		i++;
	}
	if (color.a < 0.1){
		color = texture2D(texture, texcoord);
	}
	color *= glcolor;
	if (position.x > 900.0) discard;
	gl_FragData[0] = color;
}
