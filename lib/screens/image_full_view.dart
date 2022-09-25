import 'package:flutter/material.dart';

///This is a simple page that can be used to display a image in full screen
class PhotoViewerPage extends StatefulWidget {
  ///The image that needs to be displayed
  final List<dynamic> images;

  ///The current image index
  final int currentImageIndex;
  final String objectKey;

  ///The costructor
  const PhotoViewerPage(
      {Key? key,
      required this.images,
      this.currentImageIndex = 0,
      required this.objectKey})
      : super(key: key);

  ///Create state
  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

///The state class for photo viewer page
class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.currentImageIndex);
    super.initState();
  }

  ///Override build function
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 48),
      Row(children: [
        RawMaterialButton(
          padding: const EdgeInsets.all(10.0),
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white10,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        )
      ]),
      Container(
          constraints: BoxConstraints.loose(Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height - 120)),
          child: Center(
              child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.images.length,
                  pageSnapping: true,
                  itemBuilder: (context, pagePosition) {
                    return Image.network(
                      widget.images[pagePosition] is String
                          ? widget.images[pagePosition]
                          : widget.images[pagePosition][widget.objectKey],
                      fit: BoxFit.fitWidth,
                    );
                  })))
    ]);
  }
}
