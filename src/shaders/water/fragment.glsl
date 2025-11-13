precision mediump float;

uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform float uFragElevationOffset;
uniform float uFragElevationMulti;

varying float vElevation;

void main()
{
  float mixerStrength = (vElevation + uFragElevationOffset) * uFragElevationMulti;
  vec3 color = mix(uDepthColor, uSurfaceColor, mixerStrength);

  gl_FragColor = vec4(color, 1.0); // Red color

}