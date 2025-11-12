precision mediump float;

uniform float elapsedTime;
varying vec2 vUv;

// --- small helpers ---
float hash21(vec2 p)
{
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// simple 2D value noise (cheap)
float noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);
  // four corners
    float a = hash21(i + vec2(0.0, 0.0));
    float b = hash21(i + vec2(1.0, 0.0));
    float c = hash21(i + vec2(0.0, 1.0));
    float d = hash21(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p)
{
    float v = 0.0;
    float amp = 0.5;
    for(int i = 0; i < 4; i++)
    {
        v += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return v;
}

// SDF: circle
float sdCircle(vec2 p, vec2 center, float r)
{
    return length(p - center) - r;
}

// smooth union (smooth min)
float smin(float a, float b, float k)
{
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * k * 0.25;
}

// nice palette (3-color mix)
vec3 palette(float t)
{
    vec3 a = vec3(0.05, 0.02, 0.18);
    vec3 b = vec3(0.9, 0.4, 0.2);
    vec3 c = vec3(0.95, 0.9, 0.4);
  // ramp and mix
    if(t < 0.5)
        return mix(a, b, smoothstep(0.0, 0.5, t));
    return mix(b, c, smoothstep(0.5, 1.0, t));
}

void main()
{
  // normalized pixel coords centered at (0,0)
    vec2 uv = vUv * 2.0 - 1.0;
    uv.x *= 1.0; // aspect correction if needed

  // animate and warp coords a bit
    float t = elapsedTime * 0.6;
    vec2 warp = (vec2(noise(uv * 3.0 + t), noise(uv * 5.0 - t)) - 0.5) * 0.2;
    vec2 p = uv + warp * fbm(uv * 2.0 + t * 0.2);

  // create several circles
    float d = 1e5;
  // big soft circle
    d = smin(d, sdCircle(p, vec2(0.0, 0.0), 0.6 + 0.05 * sin(t * 0.8)), 0.3);
  // rotated small ring
    vec2 c1 = vec2(0.4 * cos(t * 0.7), 0.4 * sin(t * 0.7));
    d = smin(d, sdCircle(p, c1, 0.18 + 0.02 * sin(t * 1.3 + 1.0)), 0.12);
  // another
    vec2 c2 = vec2(-0.45 * cos(t * 0.9 + 1.0), -0.22 * sin(t * 0.9 + 1.0));
    d = smin(d, sdCircle(p, c2, 0.13), 0.08);

  // soft edge mask and glow
    float edge = smoothstep(0.02, -0.02, d); // inside = 1.0
    float glow = smoothstep(0.3, 0.0, abs(d)) * 0.7; // soft glow outside

  // add micro detail from fbm
    float detail = fbm(p * 6.0 + t * 0.5) * 0.25;
    float shade = edge + glow + detail * 0.2;

  // color mapping
    vec3 col = palette(clamp(shade, 0.0, 1.0));

  // add rim/edge highlight
    float rim = smoothstep(0.02, 0.0, abs(d)) * 0.7;
    col += vec3(1.0, 0.9, 0.6) * rim;

  // vignette + grain
    float dist = length(uv);
    col *= smoothstep(1.2, 0.6, dist);

  // grain
    float g = hash21(gl_FragCoord.xy * 0.01 + t);
    col += (g - 0.5) * 0.03;

    gl_FragColor = vec4(col, 1.0);
}
