import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerScreen2 extends StatefulWidget {
  final Product product;
  final int selectedIndex;
  const ImageViewerScreen2(
      {Key? key, required this.product, required this.selectedIndex})
      : super(key: key);

  @override
  State<ImageViewerScreen2> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen2> {
  late PageController _pageController;
  int imageIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  List<String?> imageList = [];
  initState() {
    super.initState();

    _pageController = PageController(
      initialPage: widget.selectedIndex,
    );
    imageIndex = widget.selectedIndex;

    // imageList.add(widget.product.image);
    // imageList.add(widget.product.image);
    // imageList.add(widget.product.image);
    imageList.clear();
    imageList.add(widget.product.image);
    if (widget.product.images != null &&
        (widget.product.images ?? []).isNotEmpty) {
      imageList.addAll(widget.product.images ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'product_images'.tr),
      body: SafeArea(
        child: Stack(
          children: [
            Column(children: [
              Expanded(
                child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                        color: ResponsiveHelper.isDesktop(context)
                            ? Theme.of(context).canvasColor
                            : Theme.of(context).cardColor),
                    itemCount: imageList.length,
                    pageController: _pageController,
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(
                            '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${imageList[index]}'),
                        initialScale: PhotoViewComputedScale.contained,
                        heroAttributes:
                            PhotoViewHeroAttributes(tag: index.toString()),
                      );
                    },
                    loadingBuilder: (context, event) => Center(
                        child: SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              value: event == null
                                  ? 0
                                  : event.cumulativeBytesLoaded /
                                      event.expectedTotalBytes!,
                            ))),
                    onPageChanged: (int index) {
                      setState(() {
                        imageIndex = index;
                      });
                    }),
              ),
            ]),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  imageIndex > 0
                      ? InkWell(
                          onTap: () {
                            _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(10),
                            child: const Center(
                              child: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  imageIndex < imageList.length - 1
                      ? InkWell(
                          onTap: () {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(10),
                            child: const Center(
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
