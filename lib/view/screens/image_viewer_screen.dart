import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/custom_app_bar.dart';
import '../base/custom_image.dart';

class ImageViewerScreen extends StatefulWidget {
  final String imageUrl;
  const ImageViewerScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Product image'.tr),
        body: Center(
          child: CustomImage(
            image: widget.imageUrl,
            fit: BoxFit.contain,
            width: Get.width,
          ),
        ));
  }
}
