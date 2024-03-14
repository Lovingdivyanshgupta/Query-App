import 'package:flutter/cupertino.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';
import 'package:simple_animations/simple_animations.dart' as simple;

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    // final tween = Track([
    //   Track("opacity")
    //       .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
    //   Track("translateY").add(
    //       Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
    //       curve: Curves.easeOut)
    // ]);
    final tween = MovieTween();
    tween.tween('opacity', Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500));

    tween.tween('translateY', Tween(begin: -30.0, end: 0.0),
        duration: const Duration(milliseconds: 500));

    return simple.PlayAnimationBuilder<Movie>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, animation, child) => Opacity(
        opacity: animation.get('opacity'),
        child: Transform.translate(
            offset: Offset(0, animation.get('translateY')), child: child),
      ),
    );
  }
}
