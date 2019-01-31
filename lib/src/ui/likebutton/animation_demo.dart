import 'package:flutter/material.dart';

class StaggerDemo extends StatefulWidget {
  @override
  _StaggerDemoState createState() => new _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  // ...Boilerplate...

  Future<Null> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1.0 is normal animation speed.
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: new Center(
          child: new Container(
            width: 300.0,
            height: 300.0,
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: new Border.all(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            child: new StaggerAnimation(
              controller: _controller.view,
            ),
          ),
        ),
      ),
    );
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.controller})
      :

        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.

        opacity = new Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = new Tween<double>(
          begin: 50.0,
          end: 150.0,
        ).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        height = new Tween<double>(
          begin: 50.0,
          end: 150.0,
        ).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = new BorderRadiusTween(
          begin: new BorderRadius.circular(4.0),
          end: new BorderRadius.circular(75.0),
        ).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = new EdgeInsetsTween(
          begin: EdgeInsets.all(0.0),
          end: EdgeInsets.all(30.0),
        ).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(0.4, 0.8, curve: Curves.ease),
          ),
        ),
        color = new ColorTween(begin: Colors.lightGreenAccent, end: Colors.blue)
            .animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(0.4, 0.8, curve: Curves.ease),
          ),
        ),

        // ... Other tween definitions ...

        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius> borderRadius;
  final Animation<Color> color;

  // This function is called each the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: new Opacity(
        opacity: opacity.value,
        child: new Container(
          width: width.value,
          height: height.value,
          decoration: new BoxDecoration(
            color: color.value,
            border: new Border.all(
              color: Colors.indigo[300],
              width: 3.0,
            ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
