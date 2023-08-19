#version 440
// qsb --glsl 100es,120,150 --hlsl 50 --msl 12 -o progressGlow.frag.qsb progressGlow.frag

layout (location = 0) in vec2 qt_TexCoord0;
layout (location = 0) out vec4 fragColor;

layout (std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 color;
    int hasGradient;
    vec4 c0;
    vec4 c1;
    vec2 s0;
    vec2 s1;
    vec2 ratio;
    vec2 iboxRatio;
    float radius;
    float edgeOffset1;
} ubuf;

float getGlow(float dist, float radius, float intensity)
{
    return pow(radius/dist, intensity);
}

float random (vec2 co) {
  return fract (sin (dot (co, vec2 (12.9898, 78.233))) * 43758.5453);
}

void main() 
{
    // 获取场景的中心点，单位是像素
    vec2 center = ubuf.ratio / 2.0;

    // 获取当前像素的坐标，单位是像素
    vec2 coord = qt_TexCoord0 * ubuf.ratio;
	
    // 将坐标归一化到场景的中心点
    vec2 ncoord = coord - center;

    // 将s0乘以ratio，使其与coord在同一坐标系下
    vec2 s0 = ubuf.s0 * ubuf.ratio;

    // 将s1乘以ratio，使其与coord在同一坐标系下
    vec2 s1 = ubuf.s1 * ubuf.ratio;

    if(ubuf.hasGradient == 1)
    {
        // 计算s0和s1之间的距离
        float d = distance(s0, s1);

        // 计算s0和s1连线与x轴之间的夹角的正切值，避免除以零
        float angle = (s0.x - s1.x) / ((s1.y - s0.y) == 0.0 ? 0.001 : s1.y - s0.y);

        // 计算coord到s0和s1连线的垂直距离
        float line = angle * (coord.x - (s0.x + s1.x) / 2 ) + (s0.y + s1.y) / 2.0 - coord.y;

        // 计算coord到s0和s1连线的有符号距离
        float dist = line / sqrt(angle * angle + 1.0);

        // 根据s0和s1的y坐标判断渐变方向是从上到下还是从下到上，并设置旋转标志
        float rotflag = (s0.y > s1.y) ? -1.0 : 1.0;

        // 根据dist和d计算出coord处的渐变比例，并用mix函数混合c1和c0得到最终颜色
        fragColor = mix(ubuf.c1, ubuf.c0, smoothstep(0.0, 2.0 * d, rotflag * dist + d));
    }
    else
    {
        fragColor = ubuf.color;
    }

    float dist2 = length(max(abs(center - coord) - center + ubuf.radius, 0.0)) - ubuf.radius;
    // float randomf = random(vec2(0, dist2));
    // float glow = 0.05 * getGlow(length(ncoord), 1., 2.);

    // edge0和edge1的取值会影响函数的过渡区间和斜率。如果edge0和edge1相等，
    // 函数会返回0。如果edge0小于edge1，函数会在edge0和edge1之间产生一个从0到1的平滑过渡，
    // 过渡区间越大，斜率越小，曲线越平缓。
    // 如果edge0大于edge1，函数会在edge1和edge0之间产生一个从1到0的平滑过渡，
    // 过渡区间越大，斜率越小，曲线越平缓。
    // 你可以用这个网站来在线调整edge0和edge1的值，
    // 看看函数的图像如何变化。希望这能帮到你。
    fragColor = fragColor * smoothstep(0.0, 0.5 + ubuf.edgeOffset1, -dist2) * ubuf.qt_Opacity;

    //fragColor = ubuf.c0 * glow * ubuf.qt_Opacity;
}



