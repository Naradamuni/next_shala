import 'package:flutter/material.dart';
import 'package:next_shala/components/carousel_lazy_loading.dart';
import 'package:next_shala/components/dot_indicators.dart';

///The image carousel component
///Uses [PageView] and [DotIndicators]
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    Key? key,
    required this.onClick,
    required this.images,
    required this.objectKey,
  }) : super(key: key);

  ///The list of images
  final List<dynamic> images;

  ///On click callback
  final Function(int) onClick;
  final String objectKey;

  ///The statee
  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

///The state class for [ImageCarousel]
class _ImageCarouselState extends State<ImageCarousel> {
  ///The selected index in the carousel
  late int _selectedIndex;

  ///iniialize  state
  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  ///Override build UI
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselLazyLoaded(
              height: 250,
              onPageChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              builder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      widget.onClick(index);
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              widget.images[index][widget.objectKey],
                              fit: BoxFit.cover,
                            ))));
              },
              length: widget.images.length),
          if (widget.images.length > 1)
            const SizedBox(
              height: 8,
            ),
          if (widget.images.length > 1)
            DotIndicators(
              length: widget.images.length,
              selectedIndex: _selectedIndex,
            )
        ]);
  }
}
