import 'package:flutter/material.dart';

///A route that shows a widget as a full screen overlay
///If [bgColor] is not provided, it will be transluscent
///with Color.black.withAlpha(50)
class TransparentFullScreenOverlay extends ModalRoute<void> {
  ///The background color
  final Color? bgColor;

  ///The child
  final Widget child;

  ///The costructor
  TransparentFullScreenOverlay({required this.child, this.bgColor});

  ///The duration of transition and animation
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  ///Overlay is NOT opaque
  @override
  bool get opaque => false;

  ///Overllay cannot be dismissed by tapping outside child area
  @override
  bool get barrierDismissible => false;

  ///Overlay barrier color defaults to translucent black with alpha = 0.5
  @override
  Color get barrierColor => Colors.black.withOpacity(0.0);

  ///No barrier label
  @override
  String? get barrierLabel => null;

  ///Maintaines state on dismiss
  @override
  bool get maintainState => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: _buildOverlayContent(context),
    );
  }

  ///Build the [child] widget
  Widget _buildOverlayContent(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        movementDuration: Duration.zero,
        direction: DismissDirection.vertical,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Container(color: bgColor, child: child));
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
