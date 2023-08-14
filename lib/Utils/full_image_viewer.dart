
import 'package:clip/Models/user_model.dart';
import 'package:flutter/material.dart';

class ImageSliderPage extends StatefulWidget {
  final List<UserMedia> imageUrls;
  final int initialIndex;

  ImageSliderPage({required this.imageUrls, required this.initialIndex});

  @override
  _ImageSliderPageState createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<ImageSliderPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(''),
      ),
      body: Container(
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index) {
            UserMedia media = widget.imageUrls[index];
            return Image.network(media.url);
          },
        ),
      ),
    );
  }
}


