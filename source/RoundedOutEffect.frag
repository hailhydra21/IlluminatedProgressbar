#version 440
// qsb --glsl 100es,120,150 --hlsl 50 --msl 12 -o RoundedOutEffect.frag.qsb RoundedOutEffect.frag

precision highp float;
layout (location = 0) in vec2 qt_TexCoord0;
layout (location = 0) out vec4 fragColor;

layout (std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 ratio;
    float shdiff;
    float angle;
    float offset;
    float spread;
    float radius;
    float smoothstp;
    vec4 color1;
    vec4 color2;
} ubuf;


void main() {
    // TextCoord is normalized based on item size.
    vec2 center = ubuf.ratio / 2.0;
    vec2 coord = ubuf.ratio * qt_TexCoord0;

    // Normalize the coordinates to the center of the scene
    vec2 ncoord = coord - center;

    // Set shadow gradient
    float slop = tan(ubuf.angle);
    float mult = 1.57079 < ubuf.angle && ubuf.angle < 4.7123 ? -1.0 : 1.0;
    float ratio = smoothstep(0.0, ubuf.shdiff, mult * (slop * ncoord.x + ncoord.y)
                             / sqrt(slop * slop + 1.0) + ubuf.shdiff / 2.0);
    fragColor = mix(ubuf.color1, ubuf.color2, ratio);

    // Creating shadow based on shadow offset and shadow spreads.
    float dist = length(max(abs(center - coord) - center + ubuf.radius, 0.0)) - ubuf.radius;
    fragColor = fragColor * smoothstep(0.0, ubuf.spread, -dist + 0.001) * ubuf.qt_Opacity;

    // Clipping the scene to the circular region in the center.
    fragColor = fragColor * smoothstep(0.0, ubuf.smoothstp, dist + ubuf.offset) * ubuf.qt_Opacity;
}
