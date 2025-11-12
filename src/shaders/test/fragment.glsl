#define PI 3.14159265359

uniform float elapsedTime;

varying vec2 vUv;

// get a random number 
float random(vec2 st)
{
  return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) *
    43758.5453123);
}

// rotate uv cords
vec2 rotate(vec2 uv, float rotation, vec2 mid)
{
  return vec2(cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x, cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y);
}

//	Classic Perlin 2D Noise 
//	by Stefan Gustavson (https://github.com/stegu/webgl-noise)
//
vec2 fade(vec2 t)
{
  return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

vec4 permute(vec4 x)
{
  return mod(((x * 34.0) + 1.0) * x, 289.0);
}

float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = permute(permute(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x, gy.x);
  vec2 g10 = vec2(gx.y, gy.y);
  vec2 g01 = vec2(gx.z, gy.z);
  vec2 g11 = vec2(gx.w, gy.w);
  vec4 norm = 1.79284291400159 - 0.85373472095314 *
    vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

/*
vec3 generateBars()
{
  float barX = step(0.8, mod(vUv.x * 10.0 + 0.2, 1.0));
  barX *= step(0.4, mod(vUv.y * 10.0, 1.0));

  float barY = step(0.4, mod(vUv.x * 10.0, 1.0));
  barY *= step(0.8, mod(vUv.y * 10.0 + 0.2, 1.0));

  vec3 color = vec3(barX + barY);

  return color;
}

vec3 generateBoxes()
{
  // float PI = 3.1415;

  // float strengthX = abs(cos(vUv.x * PI)) * 0.8;
  // float strengthY = abs(cos(vUv.y * PI)) * 0.8;

  // vec3 color = vec3(strengthX * strengthY);

  float strengthX = abs(vUv.x - 0.5);
  float strengthY = abs(vUv.y - 0.5);

  float square1 = step(0.2, max(strengthX, strengthY));
  float square2 = 1.0 - step(0.25, max(strengthX, strengthY));

  vec3 color = vec3(square1 * square2);

  return color;
}

vec3 generateColorPallete()
{
  float axisX = floor(vUv.x * 10.0) / 10.0;
  float axisY = floor(vUv.y * 10.0) / 10.0;

  vec3 color = vec3(axisX * axisY);

  return color;
}


vec3 generateTvNoSignal()
{

  vec3 color = vec3(random(vUv));

  return color;
}


vec3 generateMineCraftBlock()
{

  // float axisX = floor(vUv.x * 10.0) / 10.0;
  // float axisY = floor(vUv.y * 10.0) / 10.0;

  float axisX = floor(vUv.x * 10.0) / 10.0;
  float axisY = floor((vUv.y + vUv.x) * 10.0) / 10.0;

  vec3 color = vec3(random(vec2(axisX, axisY)));

  return color;
}

*/

/*
vec3 generateCirculars()
{
// -------------------------------

  // float strength = length(vUv);
  // float strength = length(vUv - 0.5);
  // float strength = 1.0 - length(vUv - 0.5);
  // float strength = 1.0 - length(vUv - 0.5);
  // float strength = 0.02 / length(vUv - 0.5);
  // float strength = 0.02 / length(vUv.yy - 0.5);

// -------------------------------
  // vec2 lightUvX = vec2(vUv.x * 0.2 + 0.4, vUv.y);
  // float strengthX = 0.02 / length(lightUvX - 0.5);

  // vec2 lightUvY = vec2(vUv.x, vUv.y * 0.2 + 0.4);
  // float strengthY = 0.02 / length(lightUvY - 0.5);

  // vec3 color = vec3(strengthX * strengthY);
// -------------------------------

  // vec2 rotatedUv = rotate(vUv, PI * 0.25, vec2(0.5));

  // vec2 lightUvX = vec2(rotatedUv.x * 0.2 + 0.4, rotatedUv.y);
  // float strengthX = 0.02 / length(lightUvX - 0.5);

  // vec2 lightUvY = vec2(rotatedUv.x, rotatedUv.y * 0.2 + 0.4);
  // float strengthY = 0.02 / length(lightUvY - 0.5);

  // vec3 color = vec3(strengthX * strengthY);

// -------------------------------
  // float strength = step(0.25, length(vUv - vec2(0.5)));
  // float strength = abs(distance(vUv, vec2(0.5)) - 0.25);
  // float strength = step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));
  // float strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));
// -------------------------------

// *** waved circle animated ***

  // vec2 wavedUvs = vec2(vUv.x, vUv.y + sin(vUv.x * 30.0) * 0.1);
  // float strength = 1.0 - step(0.01, abs(distance(wavedUvs, vec2(0.5)) - 0.25));
  // vec3 color = vec3(strength);

  // vec2 wavedUvs = vec2(
  //   vUv.x + sin(vUv.y * 100.0 + elapsedTime * 10.0) * 0.1,
  //   vUv.y + sin(vUv.x * 100.0 + elapsedTime * 10.0) * 0.1
  //   );

  // float strength = 1.0 - step(0.01, abs(distance(wavedUvs, vec2(0.5)) - 0.25));
  // vec3 color = vec3(strength);

  // *** --------------- ***

  // float angle = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0);
  // angle += 0.5;
  // float sinusoid = sin(angle * 100.0);

  // float radius = 0.25 + sinusoid * 0.02;
  // float strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - radius));

  // vec3 color = vec3(strength);

  // return color;
}
*/
/*
vec3 generateFromAngle()
{
  // float strength = atan(vUv.x - 0.5, vUv.y - 0.5);
  // vec3 color = vec3(strength);

  // float strength = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0);
  // vec3 color = vec3(strength + 1.0);

  // float strength = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0);
  // strength += 0.5;
  // strength *= 12.0;

  // strength = mod(strength, 1.0);

  // vec3 color = vec3(strength);

  // float strength = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0);
  // strength += 0.5;
  // strength *= 12.0;

  // strength = mod(strength, 1.0);
  // strength = step(strength, 0.5);

  // vec3 color = vec3(strength);

  // float strength = atan(vUv.x - 0.5, vUv.y - 0.5) / (PI * 2.0);
  // strength += 0.5;
  // strength = sin(strength * 50.0);

  // vec3 color = vec3(strength);

  // return color;
}
*/

vec3 generateBackground()
{
  // float strength = cnoise(vUv * 10.0 + elapsedTime);
  // vec3 color = vec3(strength + 0.6, 0.1, strength + 0.2);

  // float strength = cnoise(vUv * 10.0);
  // strength = step(0.1, strength);
  // vec3 color = vec3(strength);

  // float strength = cnoise(vUv * 10.0);
  // strength = 1.0 - abs(strength);

  // vec3 color = vec3(strength);

  // ********
  // float strength = cnoise(vUv * 10.0 + elapsedTime);
  // float sinusiod = sin(strength * 20.2 + elapsedTime * 2.0);
  // vec3 color = vec3(sinusiod);

  // float strength = cnoise(vUv * 10.0 + elapsedTime);
  // float sinusiod = sin(strength * 20.2 + elapsedTime * 2.0);
  // sinusiod = step(0.9, sinusiod);

  // colored version
  float strength = cnoise(vUv * 10.0 + elapsedTime);
  float sinusiod = sin(strength * 20.2 + elapsedTime * 2.0);
  sinusiod = step(0.9, sinusiod);

  vec3 blackColor = vec3(0.5);
  vec3 uvColor = vec3(vUv, 1.0);

  vec3 mixedColor = mix(blackColor, uvColor, sinusiod);

  vec3 color = vec3(mixedColor);

  return color;
}

void main()
{
  // vec3 color = generateBars();
  // vec3 color = generateBoxes();
  // vec3 color = generateColorPallete();
  // vec3 color = generateTvNoSignal();
  // vec3 color = generateMineCraftBlock();
  // vec3 color = generateCirculars();
  // vec3 color = generateFromAngle();
  vec3 color = generateBackground();

  gl_FragColor = vec4(color, 1.0);
}
