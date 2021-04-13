#version 120

uniform int hideGUI;
uniform float aspectRatio;
uniform sampler2D colortex0;
uniform sampler2D shadowcolor0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;

#include "lib/settings.glsl"
#include "/lib/minimap.glsl"

varying vec2 texcoord;

const vec4 shadowcolor0ClearColor = vec4(0.0, 0.0, 0.0, 1.0);

void main() {
	vec3 color = texture2D(colortex0, texcoord).rgb;
	#ifdef MINIMAP
	if (hideGUI == 0) {
		vec2 lookdir = normalize(gbufferModelView[0].xz);
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
