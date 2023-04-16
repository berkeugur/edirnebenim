import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Color placeholderColor = Colors.blue.withOpacity(.2);
double placeholderSize = 30;

class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({
    this.imageUrl,
    super.key,
    this.imageBuilder,
    this.placeholder,
    this.errorWidget,
    this.fit,
    this.width,
    this.height,
    this.borderRadius,
  });
  final String? imageUrl;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: imageUrl ?? 'https://i.stack.imgur.com/OXKJQ.png',
        imageBuilder: imageBuilder,
        placeholder: placeholder ??
            (context, url) => LoadingAnimationWidget.fourRotatingDots(
                  color: placeholderColor,
                  size: placeholderSize,
                ),
        errorWidget: errorWidget ??
            (context, url, error) {
              debugPrint('APP_CACHED_NETWORK_IMAGE: url:$url error $error');
              FirebaseFirestore.instance
                  .collection('debugs')
                  .doc(url)
                  .set({'url': url, 'error': error});
              return const SizedBox();
            },
      ),
    );
  }
}
