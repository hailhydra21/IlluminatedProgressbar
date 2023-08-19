// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.12

Item {
    id: rootItem

    property variant source                            // 声明一个属性，用于保存要模糊的源元素
    property real radius: 28                           // 声明一个属性，用于控制模糊半径
    property bool transparentBorder: false             // 声明一个属性，用于启用或禁用源元素周围的透明边框
    property color color: '#000'                       // 声明一个属性，用于设置模糊效果的颜色
    property bool cached: false                        // 声明一个属性，用于启用或禁用模糊效果的缓存

    ShaderEffectSource {
        id: cacheItem                                  // 创建一个ShaderEffectSource元素，用于缓存模糊效果
        anchors.fill: shaderItem                       // 让它填充和shaderItem相同的区域
        visible: rootItem.cached                       // 只有当缓存启用时才可见
        sourceItem: shaderItem                         // 设置源元素为shaderItem
        live: true                                     // 当源元素改变时更新缓存
        hideSource: visible                            // 当缓存可见时隐藏源元素
        smooth: rootItem.radius > 0                    // 如果模糊半径为正则启用平滑
    }

    // qt_MultiTexCoord0和qt_TexCoord0都是着色器中的变量，它们用来表示纹理坐标。
    // qt_MultiTexCoord0是一个输入变量，它由Qt Quick提供给顶点着色器，表示每个顶点的纹理坐标。
    // qt_TexCoord0是一个输出变量，它由顶点着色器传递给片元着色器，表示每个片元的纹理坐标。
    // 通常情况下，顶点着色器会将qt_MultiTexCoord0的值直接赋给qt_TexCoord0，以保持纹理坐标不变。
    // 但是，如果需要对纹理坐标进行一些变换或计算，就可以在顶点着色器中修改qt_TexCoord0的值。
    property string __internalBlurVertexShader: "
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        uniform highp mat4 qt_Matrix;
        uniform highp float yStep;
        uniform highp float xStep;
        varying highp vec2 qt_TexCoord0;
        varying highp vec2 qt_TexCoord1;
        varying highp vec2 qt_TexCoord2;
        varying highp vec2 qt_TexCoord3;

        void main() {
            qt_TexCoord0 = vec2(qt_MultiTexCoord0.x + xStep, qt_MultiTexCoord0.y + yStep * 0.1);
            qt_TexCoord1 = vec2(qt_MultiTexCoord0.x + xStep * 0.1, qt_MultiTexCoord0.y - yStep);
            qt_TexCoord2 = vec2(qt_MultiTexCoord0.x - xStep * 0.1, qt_MultiTexCoord0.y + yStep);
            qt_TexCoord3 = vec2(qt_MultiTexCoord0.x - xStep, qt_MultiTexCoord0.y - yStep * 0.1);
            gl_Position = qt_Matrix * qt_Vertex;
        }" // 定义一个字符串，包含模糊的顶点着色器代码

    property string __internalBlurFragmentShader: "
        uniform lowp sampler2D source;
        uniform lowp float qt_Opacity;
        varying highp vec2 qt_TexCoord0;
        varying highp vec2 qt_TexCoord1;
        varying highp vec2 qt_TexCoord2;
        varying highp vec2 qt_TexCoord3;

        void main() {
            highp vec4 sourceColor = (texture2D(source, qt_TexCoord0) +
                                      texture2D(source, qt_TexCoord1) +
                                      texture2D(source, qt_TexCoord2) +
                                      texture2D(source, qt_TexCoord3)) * 0.25;
            gl_FragColor = sourceColor * qt_Opacity;
        }" // 定义一个字符串，包含模糊的片段着色器代码

    ShaderEffectSource {
        id: proxy                                               // 创建一个ShaderEffectSource元素，用于代理源元素
        sourceItem: rootItem.source                             // 设置源元素为rootItem的source属性
        anchors.fill: rootItem                                  // 让它填充和rootItem相同的区域
        visible: false                                          // 让它不可见
    }

    ShaderEffect {
        id: level0                                              // 创建一个ShaderEffect元素，用于应用第一层模糊
        property variant source: proxy                          // 设置源元素为proxy元素
        anchors.fill: parent                                    // 让它填充和父元素相同的区域
        visible: false                                          // 让它不可见
        smooth: true                                            // 启用平滑
    }

    ShaderEffectSource {
        id: level1                                              // 创建一个ShaderEffectSource元素，用于捕获第一层模糊
        width: Math.ceil(shaderItem.width / 32) * 32
        height: Math.ceil(shaderItem.height / 32) * 32
        sourceItem: level0                                      // 设置源元素为level0元素
        hideSource: rootItem.visible                            // 当rootItem可见时隐藏源元素
        sourceRect: transparentBorder ? Qt.rect(-64, -64, shaderItem.width, shaderItem.height) : Qt.rect(0, 0, 0, 0) // 根据rootItem的属性设置源矩形，包含或排除透明边框
        visible: false                                          // 让它不可见
        smooth: rootItem.radius > 0                             // 如果模糊半径为正则启用平滑
    }

    ShaderEffect {
        id: effect1                                             // 创建一个ShaderEffect元素，用于应用第二层模糊
        property variant source: level1                         // 设置源元素为level1元素
        property real yStep: 1/height                           // 设置yStep统一变量为它的高度的倒数
        property real xStep: 1/width                            // 设置xStep统一变量为它的宽度的倒数
        anchors.fill: level2                                    // 让它填充和level2元素相同的区域
        visible: false                                          // 让它不可见
        smooth: true                                            // 启用平滑
        vertexShader: __internalBlurVertexShader                // 使用之前定义的顶点着色器代码
        fragmentShader: __internalBlurFragmentShader            // 使用之前定义的片段着色器代码
    }

    ShaderEffectSource {
        id: level2                                              // 创建一个ShaderEffectSource元素，用于捕获第二层模糊
        width: level1.width / 2                                 // 设置它的宽度为level1的宽度的一半
        height: level1.height / 2                               // 设置它的高度为level1的高度的一半
        sourceItem: effect1                                     // 设置源元素为effect1元素
        hideSource: rootItem.visible                            // 当rootItem可见时隐藏源元素
        visible: false                                          // 让它不可见
        smooth: true                                            // 启用平滑
    }

    ShaderEffect {
        id: effect2                                             // 创建一个ShaderEffect元素，用于应用第三层模糊
        property variant source: level2                         // 设置源元素为level2元素
        property real yStep: 1/height                           // 设置yStep统一变量为它的高度的倒数
        property real xStep: 1/width                            // 设置xStep统一变量为它的宽度的倒数
        anchors.fill: level3                                    // 让它填充和level3元素相同的区域
        visible: false                                          // 让它不可见
        smooth: true                                            // 启用平滑
        vertexShader: __internalBlurVertexShader                // 使用之前定义的顶点着色器代码
        fragmentShader: __internalBlurFragmentShader            // 使用之前定义的片段着色器代码
    }

    ShaderEffectSource {
        id: level3                                              // 创建一个ShaderEffectSource元素，用于捕获第三层模糊
        width: level2.width / 2                                 // 设置它的宽度为level2的宽度的一半
        height: level2.height / 2                               // 设置它的高度为level2的高度的一半
        sourceItem: effect2                                     // 设置源元素为effect2元素
        hideSource: rootItem.visible                            // 当rootItem可见时隐藏源元素
        visible: false                                          // 让它不可见
        smooth: true
    }

    ShaderEffect {
        id: effect3
        property variant source: level3
        property real yStep: 1/height
        property real xStep: 1/width
        anchors.fill: level4
        visible: false
        smooth: true
        vertexShader: __internalBlurVertexShader
        fragmentShader: __internalBlurFragmentShader
    }

    ShaderEffectSource {
        id: level4
        width: level3.width / 2                                 // 设置宽度为level3的一半
        height: level3.height / 2                               // 设置高度为level3的一半
        sourceItem: effect3                                     // 设置源项目为effect3
        hideSource: rootItem.visible                            // 根据根项目的可见性隐藏源项目
        visible: false                                          // 不可见
        smooth: true                                            // 平滑
    }

    ShaderEffect {
        id: effect4
        property variant source: level4                         // 设置源为level4
        property real yStep: 1/height                           // 设置y方向的步长为1/高度
        property real xStep: 1/width                            // 设置x方向的步长为1/宽度
        anchors.fill: level5                                    // 填充level5
        visible: false                                          // 不可见
        smooth: true                                            // 平滑
        vertexShader: __internalBlurVertexShader                // 使用内置的顶点着色器
        fragmentShader: __internalBlurFragmentShader            // 使用内置的片段着色器
    }

    ShaderEffectSource {
        id: level5
        width: level4.width / 2                                 // 设置宽度为level4的一半
        height: level4.height / 2                               // 设置高度为level4的一半
        sourceItem: effect4                                     // 设置源项目为effect4
        hideSource: rootItem.visible                            // 根据根项目的可见性隐藏源项目
        visible: false                                          // 不可见
        smooth: true                                            // 平滑
    }

    ShaderEffect {
        id: effect5
        property variant source: level5                         // 设置源为level5
        property real yStep: 1/height                           // 设置y方向的步长为1/高度
        property real xStep: 1/width                            // 设置x方向的步长为1/宽度
        anchors.fill: level6                                    // 填充level6
        visible: false                                          // 不可见
        smooth: true                                            // 平滑
        vertexShader: __internalBlurVertexShader                // 使用内置的顶点着色器
        fragmentShader: __internalBlurFragmentShader            // 使用内置的片段着色器
    }

    ShaderEffectSource {
        id: level6
        width: level5.width / 2                                 // 设置宽度为level5的一半
        height: level5.height / 2                               // 设置高度为level5的一半
        sourceItem: effect5                                     // 设置源项目为effect5
        hideSource: rootItem.visible                            // 根据根项目的可见性隐藏源项目
        visible: false                                          // 不可见
        smooth: true                                            // 平滑
    }

    Item {
        id: dummysource
        width: 1
        height: 1
        visible: false
    }

    ShaderEffectSource {
        id: dummy
        width: 1
        height: 1
        sourceItem: dummysource
        visible: false
        smooth: false
        live: false
    }

    ShaderEffect {
        id: shaderItem

        property color color: rootItem.color              // 设置颜色属性为根项目的颜色属性
        property variant source1: level1
        property variant source2: level2
        property variant source3: level3
        property variant source4: level4
        property variant source5: level5
        property variant source6: level6
        property real lod: Math.sqrt(rootItem.radius) * 0.15 - 0.2   // 设置lod属性为根项目半径的平方根乘以0.15减去0.2
        property real weight1
        property real weight2
        property real weight3
        property real weight4
        property real weight5
        property real weight6

        x: transparentBorder ? -64 : 0                  // 根据transparentBorder属性设置x坐标
        y: transparentBorder ? -64 : 0                  // 根据transparentBorder属性设置y坐标
        width: transparentBorder ? parent.width + 128 : parent.width        // 根据transparentBorder属性设置宽度
        height: transparentBorder ? parent.height + 128 : parent.height     // 根据transparentBorder属性设置高度

        function weight(v) {                            // 定义一个函数，根据v的值返回一个权重
            if (v <= 0.0)
                return 1.0
            if (v >= 0.5)
                return 0.0

            return 1.0 - v * 2.0
        }

        function calculateWeights() {                   // 定义一个函数，计算各个层级的权重

            var w1 = weight(Math.abs(lod - 0.100))
            var w2 = weight(Math.abs(lod - 0.300))
            var w3 = weight(Math.abs(lod - 0.500))
            var w4 = weight(Math.abs(lod - 0.700))
            var w5 = weight(Math.abs(lod - 0.900))
            var w6 = weight(Math.abs(lod - 1.100))

            var sum = w1 + w2 + w3 + w4 + w5 + w6;
            weight1 = w1 / sum;
            weight2 = w2 / sum;
            weight3 = w3 / sum;
            weight4 = w4 / sum;
            weight5 = w5 / sum;
            weight6 = w6 / sum;

            upateSources()
        }


        function upateSources() {
            var sources = Array();
            var weights = Array();

            if (weight1 > 0) {                  // 如果weight1大于0
                sources.push(level1)            // 把level1加入到sources数组
                weights.push(weight1)           // 把weight1加入到weights数组
            }

            if (weight2 > 0) {                  // 如果weight2大于0
                sources.push(level2)            // 把level2加入到sources数组
                weights.push(weight2)           // 把weight2加入到weights数组
            }

            if (weight3 > 0) {                  // 如果weight3大于0
                sources.push(level3)            // 把level3加入到sources数组
                weights.push(weight3)           // 把weight3加入到weights数组
            }

            if (weight4 > 0) {                  // 如果weight4大于0
                sources.push(level4)            // 把level4加入到sources数组
                weights.push(weight4)           // 把weight4加入到weights数组
            }

            if (weight5 > 0) {                  // 如果weight5大于0
                sources.push(level5)            // 把level5加入到sources数组
                weights.push(weight5)           // 把weight5加入到weights数组
            }

            if (weight6 > 0) {                  // 如果weight6大于0
                sources.push(level6)            // 把level6加入到sources数组
                weights.push(weight6)           // 把weight6加入到weights数组
            }

            for (var j = sources.length; j < 6; j++) {  // 对于sources数组的长度小于6的情况
                sources.push(dummy)                     // 把dummy加入到sources数组，作为占位符
                weights.push(0.0)                       // 把0.0加入到weights数组，作为占位符的权重
            }

            source1 = sources[0]
            source2 = sources[1]
            source3 = sources[2]
            source4 = sources[3]
            source5 = sources[4]
            source6 = sources[5]

            weight1 = weights[0]
            weight2 = weights[1]
            weight3 = weights[2]
            weight4 = weights[3]
            weight5 = weights[4]
            weight6 = weights[5]
        }

        Component.onCompleted: calculateWeights()       // 当组件完成时，调用calculateWeights函数

        onLodChanged: calculateWeights()                // 当lod属性改变时，调用calculateWeights函数

        // 定义片段着色器
        fragmentShader: "
            uniform lowp sampler2D source1;
            uniform lowp sampler2D source2;
            uniform lowp sampler2D source3;
            uniform lowp sampler2D source4;
            uniform lowp sampler2D source5;
            uniform lowp vec4 color;
            uniform mediump float weight1;
            uniform mediump float weight2;
            uniform mediump float weight3;
            uniform mediump float weight4;
            uniform mediump float weight5;
            uniform lowp float qt_Opacity;
            varying mediump vec2 qt_TexCoord0;

           void main() {
               lowp float op = texture2D(source1, qt_TexCoord0).a * weight1;
               op += texture2D(source2, qt_TexCoord0).a * weight2;
               op += texture2D(source3, qt_TexCoord0).a * weight3;
               op += texture2D(source4, qt_TexCoord0).a * weight4;
               op += texture2D(source5, qt_TexCoord0).a * weight5;
               gl_FragColor = op * qt_Opacity * color; // 设置片段的颜色为各个源的透明度乘以权重再乘以颜色
           }"
    } // 结束shaderEffect
}
