//Varyings//
varying vec2 texcoord;

#ifdef FSH
//Uniforms//
uniform int hideGUI;
uniform float aspectRatio;
uniform sampler2D colortex0;
uniform sampler2D shadowcolor0;
uniform mat4 gbufferModelView;
uniform float screenBrightness;

//Optifine Constants//
const vec4 shadowcolor0ClearColor = vec4(0.0, 0.0, 0.0, 1.0);

//Includes//
#include "/lib/settings.glsl"
#include "/lib/minimap.glsl"

//Program//
void main() {
	vec3 color = texture2D(colortex0, texcoord).rgb;
	color = mix(color, pow(color, vec3(0.85)), screenBrightness);
	#ifdef MINIMAP
	if (hideGUI == 0) {
		vec2 lookdir = normalize(gbufferModelView[0].xz + vec2(0.01, 0.0));
		float mmrot = acos(lookdir.x) * sign(sin(lookdir.y));
		vec2 mmcoord = 2.0 * MM_SCALE * (texcoord * vec2(aspectRatio, 1.0) + vec2(0.02)) - 2.0 * MM_SCALE * vec2(aspectRatio, 1.0) + vec2(1.0);
		if (mmcoord.x > -1.0 && mmcoord.y > -1.0 && mmcoord.x < 1.0 && mmcoord.y < 1.0) {
			vec4 mmcolor = minimap(mmcoord, shadowcolor0, mmrot);
			color = mix(color, mmcolor.rgb, mmcolor.a);
		}
	}
	#endif
/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}

#endif
#ifdef VSH
void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
#endif