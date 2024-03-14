import 'package:flutter/material.dart';

import 'color_modal.dart';

class CurvePaint extends CustomPainter {
  final colorGradient = MyColorsModal();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = const Color(0xff6268D7);
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width / 2, 200, size.width, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CurveAddPaint extends CustomPainter {
  final colorGradient = MyColorsModal();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.indigoAccent;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width / 4, size.height / 4, size.width / 2, size.height * 0.5);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.8, size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * 0.5);
    canvas.drawPath(path, paint);
    // Offset center = Offset(size.width/2, size.height/2);
    // canvas.drawCircle(center,120.0,paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CirclePaint extends CustomPainter {
  final colorGradient = MyColorsModal();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.indigoAccent;
    paint.style = PaintingStyle.fill;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomPainterClass extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(143, 148, 251, 0.6)
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BoxBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.grey;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.fill;
    const BorderRadius borderRadius = BorderRadius.only(
        topLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
        bottomLeft: Radius.circular(30));
    final Rect rect = Rect.fromLTRB(0, 0, size.width * 0.9, size.height * 0.3);
    final RRect outer = borderRadius.toRRect(rect);
    canvas.drawRRect(outer, paint);
    final Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width * 0.1, 0);
    path.lineTo(size.width * 0.7, size.height * 0.1);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
