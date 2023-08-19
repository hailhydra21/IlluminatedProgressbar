#version 440
// qsb --glsl 100es,120,150 --hlsl 50 --msl 12 -o test.frag.qsb test.frag

precision highp float;
layout (location = 0) in vec2 qt_TexCoord0;
layout (location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
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
    // 获取场景的中心点，单位是像素
    vec2 center = ubuf.ratio / 2.0;
    // 获取当前像素的坐标，单位是像素
    vec2 coord = qt_TexCoord0 * ubuf.ratio;

    // 将坐标归一化到场景的中心点
    vec2 ncoord = coord - center;

    // 设置阴影渐变
    // 根据阴影角度计算阴影线的斜率
    float slop = tan(ubuf.angle);
    // 根据阴影角度确定阴影方向的符号
    float mult = 1.57079 < ubuf.angle && ubuf.angle < 4.7123 ? -1.0 : 1.0;
    // 计算当前像素到阴影线的距离
    vec4 ratio = vec4(smoothstep(0.0, ubuf.shdiff, mult * (slop * ncoord.x + ncoord.y)
                                 / sqrt(slop * slop + 1.0) + ubuf.shdiff / 2.0));
    // 根据距离比例混合两种颜色
    fragColor = mix(ubuf.color1, ubuf.color2, ratio);

    // 根据阴影偏移和阴影扩散创建阴影效果
    // 计算当前像素到圆边缘的距离
    float dist = length(max(abs(center - coord) - center + ubuf.radius, 0.0)) - ubuf.radius;

    // 应用一个smoothstep函数来创建柔和的阴影效果
    fragColor = fragColor * smoothstep(0.0, ubuf.spread, dist + ubuf.offset) * ubuf.qt_Opacity;

    // 将场景裁剪到中心的圆形区域
    // 应用另一个smoothstep函数来裁剪圆外的像素
    fragColor = fragColor * smoothstep(0.0, ubuf.smoothstp, -dist + 0.005) * ubuf.qt_Opacity;
}
