import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:web_horizon/res/app_url.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${AppUrl.imageUrl}$image",
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Image.asset(
          "assets/images/image_placeholder.png",
          fit: BoxFit.cover,
        );
      },
      errorWidget: (context, url, error) {
        return Image.asset(
          "assets/images/image_placeholder.png",
          fit: BoxFit.cover,
        );
      },
    );
  }
}
