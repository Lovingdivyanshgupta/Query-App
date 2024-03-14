import 'package:flutter/cupertino.dart';

class AnimatedRoute extends PageRouteBuilder {
  AnimatedRoute({
    required this.route,
    this.page,
    this.offsetDirection,
  }) : super(
          pageBuilder: (context, animation, second) => page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, second, child) =>
              SlideTransition(
            //opacity: animation,
            //turns: animation,
            position: Tween<Offset>(
                    begin: const Offset(1, 0), end: const Offset(0, 0))
                .animate(animation),
            //sizeFactor: animation,
            //scale: animation,
            // decoration:
            //     DecorationTween(begin: BoxDecoration(), end: BoxDecoration())
            //         .animate(animation),
            child: route,
          ),
        );
  final dynamic route;
  final dynamic page;
  final dynamic offsetDirection;
}
