import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Pinned "Your Contacts" header. Sticks to the top when the list scrolls under it.
class BlobPinnedSectionTitle extends StatelessWidget {
  const BlobPinnedSectionTitle({super.key});

  static const double _headerHeight = AppSpacing.xxl;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedSectionTitleDelegate(headerHeight: _headerHeight),
    );
  }
}

class _PinnedSectionTitleDelegate extends SliverPersistentHeaderDelegate {
  _PinnedSectionTitleDelegate({required this.headerHeight});

  final double headerHeight;

  @override
  double get minExtent => headerHeight;

  @override
  double get maxExtent => headerHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: headerHeight,
      alignment: .centerLeft,
      color: Colors.transparent,
      child: Text(
        'Your Contacts',
        style: AppTextStyles.islandSectionTitle.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
