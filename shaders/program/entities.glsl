//Varyings//
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 color;

#ifdef FSH
//Uniforms//
uniform sampler2D texture;
uniform vec4 entityColor;
//Program//
void main() {
	vec4 color = texture2D(texture, texcoord) * color * max(lmcoord.y, lmcoord.x);
	color.rgb *= vec3(1 + entityColor);
	/*DRAWBUFFERS:0*/
	gl_FragData[0] = color;
}
#endif

#ifdef VSH
void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	color = gl_Color;
	color *= 1 + gl_Normal.y * 0.4;
}
#endif
