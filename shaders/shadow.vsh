#version 120

#include "/lib/settings.glsl"
attribute vec2 mc_midTexCoord;
attribute vec3 at_midBlock;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec2 midtexcoord;
varying vec4 glcolor;
varying vec3 position;
varying float mat;

uniform int entityId;
uniform ivec2 eyeBrightness;
uniform vec3 cameraPosition;
uniform mat4 shadowProjection, shadowProjectionInverse;
uniform mat4 shadowModelView, shadowModelViewInverse;
const int shadowMapResolution = 1024;
const float shadowDistance = 120.0;
const float shadowDistanceRenderMul = 1.0;

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
	if(entityId > 10000 && entityId < 10003) {
		gl_Position.z = clamp(gl_Position.z - 0.2, 0.01, 1.0);
		mat = entityId - 10000;
	}
	if ( eyeBrightness.y < 200) {
		gl_Position.xy *= 1.4;
		if(position.y > 2 || position.y < -25|| position.y + cameraPosition.y < 1 || gl_Normal.y < 0) {
			position.x = 1000.0;
		}
	}
}
