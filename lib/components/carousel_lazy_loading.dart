import 'package:flutter/material.dart';

///A siimple side scrolling carousel that snaps on scrolling
///Supports lazy loading
///Loads widgets until [lookAhead] value
///Uses page view
class CarouselLazyLoaded extends StatefulWidget {
  ///thee constructor
  const CarouselLazyLoaded(
      {Key? key,
      required this.builder,
      required this.length,
      this.height = 120,
      required this.onPageChange,
      this.lookAhead = 1})
      : super(key: key);

  ///Builder function to build widget
  final Widget Function(BuildContext context, int index) builder;

  ///the heeight of the carousel
  final double height;

  ///The number of items
  final int length;

  ///the look ahead
  ///Builder builds util look ahead index
  final int lookAhead;

  ///callback function when page changes
  final Function(int) onPageChange;

  ///The state
  @override
  CarouselStateLazyLoaded createState() => CarouselStateLazyLoaded();
}

///State class for [CarouselStateLazyLoaded]
class CarouselStateLazyLoaded extends State<CarouselLazyLoaded> {
  int _currentIndex = 0;

  ///Override build function
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.height,
        child: PageView.builder(
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
            widget.onPageChange(index);
          },
          padEnds: false,
          itemCount: widget.length,
          controller: PageController(viewportFraction: 1),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (index <= _currentIndex + widget.lookAhead) {
              return widget.builder(context, index);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
