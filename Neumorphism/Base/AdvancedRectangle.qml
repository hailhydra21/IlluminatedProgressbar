// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
//import Neumorphism 1.0

Item {
    id: control

    property color color: '#aaa'
    property list<GradientColor> gradient
    property var radius: undefined

    ShaderEffect {
        id: effect                                                  // 给这个元素一个id，方便引用
        width: control.width                                        // 设置宽度为control元素的宽度
        height: control.height                                      // 设置高度为control元素的高度

        readonly property int hasGradient: gradient.length > 1 ? 1 : 0    // 定义一个只读的布尔属性，表示是否有渐变颜色
        readonly property color color: control.color
        readonly property color c0: hasGradient ? gradient[0].color: "#fff";     // 定义一个只读的颜色属性，表示渐变颜色的第一个颜色，如果没有渐变，则为白色
        readonly property color c1: hasGradient ? gradient[1].color: "#fff";     // 定义一个只读的颜色属性，表示渐变颜色的第二个颜色，如果没有渐变，则为白色
        readonly property vector2d s0: hasGradient ? gradient[0].stop : Qt.vector2d(0,0)    // 定义一个只读的二维向量属性，表示渐变颜色的第一个停止点，如果没有渐变，则为(0,0)
        readonly property vector2d s1: hasGradient ? gradient[1].stop : Qt.vector2d(0,0)    // 定义一个只读的二维向量属性，表示渐变颜色的第二个停止点，如果没有渐变，则为(0,0)
        readonly property vector2d ratio: Qt.vector2d(width / Math.max(width, height),
                                                      height / Math.max(width, height));    // 定义一个只读的二维向量属性，表示宽高比例
        readonly property vector4d radius: {
            let whMin = Math.min(ratio.x, ratio.y) / 2                         // 定义一个局部变量，表示宽高比例中较小的一半
            if(typeof control.radius == "number"){                             // 如果control.radius是一个数字类型
                let rad = 0;                                                   // 定义一个局部变量，表示圆角半径
                rad = Math.min(Math.max(control.radius, 0.01), whMin);         // 将圆角半径限制在0.01和whMin之间
                return Qt.vector4d(rad, rad, rad, rad);                        // 返回一个四维向量，表示四个角的圆角半径相同
            }
            else if(typeof control.radius == "object" && whMin > 0) {          // 如果control.radius是一个对象类型，并且whMin大于0
                /*!
                * I made advanced rectangle in order to make a rectangle with changeable radiuses and a basic gradient.
                * radius points,  0 <= x,y,z,w <= 0.5
                * - vector4d(x, y, z, w):
                *  ╭───┬───╮
                *  │ X │ Y │
                *  ├───┼───┤
                *  │ W │ Z │
                *  ╰───┴───╯
                *  ╭┐ ┌╮ ┌┐ ┌┐
                *  └┘ └┘ └╯ ╰┘
                *   X  Y  Z  W
                */
                //返回一个四维向量，表示四个角的圆角半径分别为control.radius.x,y,z,w，并且限制在0.01和whMin之间
                return Qt.vector4d(Math.min(Math.max(control.radius.x, 0.01), whMin),
                                   Math.min(Math.max(control.radius.y, 0.01), whMin),
                                   Math.min(Math.max(control.radius.z, 0.01), whMin),
                                   Math.min(Math.max(control.radius.w, 0.01), whMin));
            }
            else {
                return Qt.vector4d(0.0,0.0,0.0,0.0);       //返回一个四维向量，表示四个角的圆角半径都为0
            }
        }

        /**
         * TODO: Allow radius variants to be more than 0.5, To do so, tie Y to the radius center point.
         *  ╭───┬─┐
         *  │ Y │ │
         *  ├───┼─┤
         *  └───┴─┘
         * BUG: I'm not sure why, but GLSL works without the "mod" function in this code "lowp int area = int(mod(-atan(", and I'm not sure why?!
         * Isn't there any overflow here?
         */

        fragmentShader: "../../source/AdvancedRectangle.frag.qsb"
    }
}
