import 'package:flutter/material.dart';

class MyColorsModal {
  static const Color kThemeColor = Color.fromRGBO(143, 148, 251, 1);
  List<dynamic> categoryList = [];

  static List<Gradient> getGradientColors() {
    List<Gradient> gradientColors = [
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.decal,
        colors: [
          kThemeColor,
          Color.fromRGBO(143, 148, 251, 0.6),
          kThemeColor,
        ],
      ),
    ];
    return gradientColors;
  }

  static List<Gradient> cardGradientColors() {
    List<Gradient> gradientColors = [
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0x2f1723ac),
          Color(0x2fb06ab3),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0x2fddd6f3),
          Color(0x2ffaaca8),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0x2f43cea2),
          Color(0x2f185a9d),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0x2fff512f),
          Color(0x2fdd2476),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0x2f00ced1),
          Color(0x2f0000ff),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0x2f800080),
          Color(0x2fff0000),
        ],
      ),
    ];
    return gradientColors;
  }

  static List<Gradient> alphaGradientColors() {
    List<Gradient> gradientColors = [
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xff1723ac),
          Color(0xffb06ab3),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xffddd6f3),
          Color(0xfffaaca8),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xff43cea2),
          Color(0xff185a9d),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xffff512f),
          Color(0xffdd2476),
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.teal,
          Colors.cyan,
        ],
      ),
      const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.amber,
          Colors.deepOrange,
        ],
      ),
    ];
    return gradientColors;
  }
}

// LinearGradient(
//   begin: Alignment.topRight,
//   end: Alignment.bottomLeft,
//   colors: [
//     Color(0xf04568dc),
//     Color(0XF0b06ab3),
//   ],
// ),
// LinearGradient(
//   begin: Alignment.topRight,
//   end: Alignment.bottomLeft,
//   colors: [
//     Color(0xffddd6f3),
//     Color(0xfffaaca8),
//   ],
// ),
// LinearGradient(
//   begin: Alignment.topRight,
//   end: Alignment.bottomLeft,
//   colors: [
//     Color(0xff43cea2),
//     Color(0xff185a9d),
//   ],
// ),
// LinearGradient(
//   begin: Alignment.topRight,
//   end: Alignment.bottomLeft,
//   colors: [
//     Color(0XFFff512f),
//     Color(0xffdd2476),
//   ],
// ),
// LinearGradient(
//   begin: Alignment.topRight,
//   end: Alignment.bottomLeft,
//   colors: [
//     Colors.teal,
//     Colors.cyan,
//   ],
// ),
// LinearGradient(
//   begin: Alignment.topRight,
//   end: Alignment.bottomLeft,
//   colors: [
//     Colors.amber,
//     Colors.deepOrange,
//   ],
// ),
