import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/ui/widget/blur_close_button.dart';
import 'package:place_see_app/ui/widget/photo_info.dart';

class PhotoGalleryScreen extends StatefulWidget {
  final List<PhotoFullInfo> photos;
  final int initialIndex;

  const PhotoGalleryScreen({super.key, required this.photos, required this.initialIndex});

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> with SingleTickerProviderStateMixin{
  late PageController controller;
  int currentIndex = 0;
  double dragOffset = 0;
  double opacity = 0.8;
  double scale = 1;

  late AnimationController returnController;
  late Animation<double> returnAnimation;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    controller = PageController(initialPage: currentIndex);

    returnController = AnimationController(
        vsync: this,
      duration: const Duration(milliseconds: 200)
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    dragOffset += details.delta.dy;

    final progress = (dragOffset.abs() / 400).clamp(0.0, 1.0);
    setState(() {
      opacity = 1 - progress;
      scale = 1 - progress * 0.25;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    final shouldClose = dragOffset.abs() > 120 || velocity.abs() > 700;

    if (shouldClose) {
      Navigator.of(context).pop();
      return;
    }
    _animateBack();
  }

  void _animateBack() {
    returnAnimation = Tween<double>(begin: dragOffset, end: 0)
        .animate(
            CurvedAnimation(parent: returnController, curve: Curves.easeOut)
        )
        ..addListener(() {
          final progress = (returnAnimation.value.abs() / 400).clamp(0, 1.0).toDouble();

          setState(() {
            dragOffset = returnAnimation.value;
            opacity = 1 - progress;
            scale = 1 - progress * 0.25;
          });
        });
    returnController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photos[currentIndex];
    final blurSigma = (opacity * 20).clamp(0, 17).toDouble();

    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigma,
                      sigmaY: blurSigma
                    ),
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: opacity.clamp(0.3, 0.65)
                    ),
                  ),
                )
            ),

            Transform.translate(
                offset: Offset(0, dragOffset),
              child: Transform.scale(
                scale: scale,
                child: PhotoViewGallery.builder(
                    itemCount: widget.photos.length,
                    pageController: controller,
                    onPageChanged: (i) => setState(() => currentIndex = i),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent
                    ),
                    builder: (context, index) {
                      final photo = widget.photos[index];
                      return PhotoViewGalleryPageOptions(
                        heroAttributes: PhotoViewHeroAttributes(tag: photo.imageUrl),
                        imageProvider: CachedNetworkImageProvider(photo.imageUrl),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      );
                    }
                ),
              ),
            ),

            Positioned(
              left: 16,
                right: 16,
                bottom: 30,
                child: Opacity(
                    opacity: opacity,
                  child: PhotoInfo(photo: photo),
                )
            ),

            Positioned(
              top: 45,
                left: 16,
                child: Opacity(
                    opacity: opacity,
                  child: BlurCloseButton(),
                )
            )
          ],
        ),
      ),
    );
  }
}
