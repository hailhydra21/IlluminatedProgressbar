#version 440
// qsb --glsl 100es,120,150 --hlsl 50 --msl 12 -o AdvancedRectangle.frag.qsb AdvancedRectangle.frag

precision highp float;
layout (location = 0) in vec2 qt_TexCoord0;
layout (location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 ratio;                             // 定义一个高精度的二维向量变量，表示宽高比例
    int hasGradient;                       // 定义一个低精度的布尔型变量，表示是否有渐变颜色
    vec4 radius;                            // 定义一个高精度的四维向量变量，表示四个角的圆角半径
    vec4 color;                             // 定义一个高精度的四维向量变量，表示颜色
    vec4 c0;                                // 定义一个高精度的四维向量变量，表示渐变颜色的第一个颜色
    vec4 c1;                                // 定义一个高精度的四维向量变量，表示渐变颜色的第二个颜色
    vec2 s0;                                // 定义一个高精度的二维向量变量，表示渐变颜色的第一个停止点
    vec2 s1;                                // 定义一个高精度的二维向量变量，表示渐变颜色的第二个停止点
} ubuf;

void main() {
    // TextCoord is normalized based on item size.
    vec2 center = ubuf.ratio / 2.0;                 // 定义一个高精度的二维向量变量，表示矩形中心点
    vec2 coord = ubuf.ratio * qt_TexCoord0;         // 定义一个高精度的二维向量变量，表示当前像素点坐标
    vec2 s0 = ubuf.s0 * ubuf.ratio;                 // 将s0乘以ratio，使其与coord在同一坐标系下
    vec2 s1 = ubuf.s1 * ubuf.ratio;                 // 将s1乘以ratio，使其与coord在同一坐标系下

    // This part sets the gradient color if one exists; otherwise, it just sets the color.
    if(ubuf.hasGradient == 1)
    {
        // 如果有渐变颜色
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
        // 直接设置为color
        fragColor = ubuf.color;
    }

    // Create border radius.
    // 将radius转换为一个高精度的浮点型数组
    float radius[4] = float[4](ubuf.radius.x, ubuf.radius.y, ubuf.radius.z, ubuf.radius.w);

    // 根据coord和center的相对位置计算出coord处于哪个角的区域，用0,1,2,3表示
    int area = int(mod(-atan(coord.x - center.x, coord.y - center.y) * 0.636 + 3, 4.0));

    // 计算coord到圆角边界的有符号距离
    float dist = length(max(abs(center - coord) - center + radius[area], 0.0)) - radius[area];

    // 根据dist和qt_Opacity调整颜色的透明度，实现圆角效果
    fragColor = fragColor * smoothstep(0.0, 0.01, -dist + 0.001) * ubuf.qt_Opacity;
}
