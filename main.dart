import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Page1(),
  ));
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(_createRoute()),
            child: const Text('Go')),
      ),
    );
  }

  /// PageRouteBuilder has two callback, one to build the content
  /// of the route `pageBuilder` and one to build the route's
  /// transition `transitionsBuilder`
  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Page2(),

        /// The child parameter in transitionsBuilder is the
        /// widget returned from pageBuilder.The framework can
        /// avoid extra work because `child` stays the same
        /// throughout the transition
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 1. The animation produce values from 0 to 1.
          // 2. The CurveTween maps those values to new values
          // between 0 and 1 base on its curve.
          // 3. The `Tween<Offset>` maps the double to [Offset]
          // values.
          /// Flutter provides a selection easing curves that
          /// adjust the rate of the animation over time.
          /// The [Curves] class provides a predefined set
          /// of commonly used curves. For example, `Curves
          /// .easeOut` makes the animation start quickly and end
          /// slowly.
          var curve = Curves.ease;
          // This new [Tween] still produces values from 0 to 1 so
          // combined with `[`Tween<Offset>`.
          var curveTween = CurveTween(curve: curve);

          /// To make the new page animate in from the bottom,
          /// it should animate from `Offset(0, 1)` to Offset(0,
          /// 0)` or [Offset.zero] constructor.
          /// The `transitionBuilder` callback has an animation
          /// parameter. It's an `Animation<double>` that
          /// produces values between 0 and 1. Convert the
          /// animation to animation using [Tween]
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(curveTween);
          final offsetAnimation = animation.drive(tween);

          /// [SlideTransition] extends [AnimationWidget].
          /// [AnimationWidget] rebuild themselves when the value
          /// of the animation changes.
          /// [SlideTransition] takes an `Animation<Offset>` and
          /// translates its child using a [FractionalTranslation]
          /// whenever the value of the animation changes.
          ///
          /// The new [Tween] or Animatable produces [Offset]
          /// values first by evaluating the [CurveTween], then
          /// evaluating the `Tween<Offset>`.
          ///
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text('Page 2'),
            ElevatedButton(
                onPressed: () {
                  //page 3
                  Navigator.of(context).push(_createRoute());
                },
                child: const Text('To page 3'))
          ],
        ),
      ),
    );
  }

  Route<void> _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Page3(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: curve);

          /// Use [SlideTransition]
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('page 3'),
      ),
      body: Container(),
    );
  }
}
