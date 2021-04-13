float cursor(vec2 cursorCoord){
	float iscursor = clamp(float(cursorCoord.y < 0.1 - 2.5 * abs(cursorCoord.x) && cursorCoord.y > -0.02 - 0.5 * abs(cursorCoord.x)) + 0.1*sign(cursorCoord.x) - 0.1, 0, 1);
	return iscursor;
}
vec4 minimap(vec2 texCoord, sampler2D maptex, float rot) {
	vec2 distAng = vec2(length(texCoord), 0.0);
	distAng.y = acos(texCoord.x / distAng.x) * sign(sin(texCoord.y));
	#ifdef MAPROT
	distAng.y += rot;
	#else
	distAng.y -= rot;
	#endif
	vec2 rotPos = distAng.x * vec2(cos(distAng.y), sin(distAng.y));
	#ifdef MAPROT
	vec4 color = texture2D(maptex, 0.3 * rotPos + vec2(0.5));
	color.rgb = mix(color.rgb, vec3(0.9, 0.3, 0.1), cursor(texCoord));
	#else
	vec4 color = texture2D(maptex, 0.3 * texCoord + vec2(0.5));
	color.rgb = mix(color.rgb, vec3(0.9, 0.3, 0.1), cursor(rotPos));
	#endif
	float isborder = float((abs(texCoord.x) > 0.96 || abs(texCoord.y) > 0.96) && abs(texCoord.x) < 1.0 && abs(texCoord.y) < 1.0);
	color.rgb = mix(color.rgb, vec3(0.3, 0.15, 0.1), isborder);
	color.a = 1.0;
	return color;
}

