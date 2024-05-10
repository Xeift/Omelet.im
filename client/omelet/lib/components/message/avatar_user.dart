import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 顯示用戶照片，可分small、medium、large的大小

class AvatarUser extends StatelessWidget {
  const AvatarUser({
    Key? key,
    this.url,
    required this.radius,
    this.onTap,
  }) : super(key: key);

  const AvatarUser.small({
    Key? key,
    this.url,
    this.onTap,
  })  : radius = 20,
        super(key: key);

  const AvatarUser.large({
    Key? key,
    this.url,
    this.onTap,
  })  : radius = 34,
        super(key: key);

  final double radius;
  final String? url;
  final VoidCallback? onTap;

  void clearCacheForUrl(String url) {
    CachedNetworkImage.evictFromCache(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _avatar(context),
    );
  }

  Widget _avatar(BuildContext context) {
    if (url != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: Image.network('$url?v=${DateTime.now()}').image,
        backgroundColor: Theme.of(context).cardColor,
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).cardColor,
        child: Center(
          child: Text(
            '?',
            style: TextStyle(fontSize: radius),
          ),
        ),
      );
    }
  }
}
