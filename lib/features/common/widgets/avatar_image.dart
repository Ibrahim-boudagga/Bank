import 'package:bank/app/design/colors/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Circular avatar that loads [url] with [CachedNetworkImage].
/// [size] is the diameter. On error or while loading, shows a gradient circle with person icon.
class AvatarImage extends StatelessWidget {
  const AvatarImage({super.key, required this.url, required this.size});

  final String url;
  final Size size;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _EmptyAvatar(size: size);

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        shape: .circle,
        border: .all(color: AppColors.electricAccent.withValues(alpha: 0.5), width: 1),
      ),
      clipBehavior: .antiAlias,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: .cover,
        width: size.width,
        height: size.height,
        placeholder: (_, _) => _EmptyAvatar(size: size),
        errorWidget: (_, _, _) => _EmptyAvatar(size: size),
      ),
    );
  }
}

class _EmptyAvatar extends StatelessWidget {
  final Size size;
  const _EmptyAvatar({required this.size});

  @override
  Widget build(BuildContext context) => Container(
    width: size.width,
    height: size.height,
    decoration: BoxDecoration(
      shape: .circle,
      gradient: const LinearGradient(
        colors: [AppColors.spaceStart, AppColors.spaceEnd],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      border: .all(color: AppColors.electricAccent.withValues(alpha: 0.5), width: 1),
    ),
    child: Icon(Icons.person, color: Colors.white, size: size.width * 0.46),
  );
}
