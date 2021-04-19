//Varyings//
varying vec2 lmcoord;
varying vec2 texcoord;
varying vec2 midtexcoord;
varying vec4 glcolor;
varying vec3 position;
varying float mat;

#ifdef FSH
//Uniforms//
uniform sampler2D lightmap;
uniform sampler2D texture;
uniform ivec2 atlasSize;
uniform float frameTimeCounter;

//Includes//
#include "/lib/settings.glsl"

//Program//
void main() {
	if (position.x > 900.0) discard;
	vec2 offsets[4] = vec2[4](
		vec2(-1,-1),
		vec2(-1, 1),
		vec2(1, -1),
		vec2(1, 1)
	);
	vec4 color = vec4(0.0);
	if (mat < 0.5) {
		color = texture2D(texture, midtexcoord);
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
	}else {
		color = vec4(float((mat > 1.5 && mat < 2.5) || (mat > 2.5 && mat < 3.5)), float(mat > 0.5 && mat < 1.5), 0.0, 1.0);
		#ifdef DANGER_ALERT
		if (mat > 2.5 && mat < 3.5){
			color = vec4(1.0) - float(mod(4 * frameTimeCounter, 2) > 1.0) * vec4(0.0, 1.0, 1.0, 0.0);
		}
		#endif
	}
	gl_FragData[0] = color;
}
#endif

#ifdef VSH
//Attributes//
attribute vec2 mc_midTexCoord;
attribute vec3 mc_Entity;

//Uniforms//
uniform int entityId;
uniform ivec2 eyeBrightness;
uniform vec3 cameraPosition;
uniform mat4 shadowProjection, shadowProjectionInverse;
uniform mat4 shadowModelView, shadowModelViewInverse;

//Optifine Constants//
const int shadowMapResolution = 1024;
const float shadowDistance = 120.0;
const float shadowDistanceRenderMul = 1.0;

//Includes//
#include "/lib/settings.glsl"

//Program//
void main() {
	mat = 0;
	midtexcoord = mc_midTexCoord;
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
	gl_Position = ftransform();
	position = (shadowModelViewInverse * shadowProjectionInverse * gl_Position).xyz;
	gl_Position.xy = position.xz * vec2(0.01, -0.01) * MM_ZOOM;
	gl_Position.z = 0.99 - (position.y + cameraPosition.y)/256.0;
	mat = mc_Entity.x - 10000;
	if(entityId > 10000) {
		gl_Position.z = clamp(gl_Position.z - 0.2, 0.01, cameraPosition.y);
		position.y = clamp(position.y - 10, min(position.y, 0), 20);
		mat = entityId - 10000;
	}
	if ( eyeBrightness.y < 200) {
		gl_Position.xy *= 1.4;
		if(position.y > 5 || position.y < -25|| position.y + cameraPosition.y < 1 || gl_Normal.y < 0) {
			position.x = 1000.0;
		}
	}
}
#endif
