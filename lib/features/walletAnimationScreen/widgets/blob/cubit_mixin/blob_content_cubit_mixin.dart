import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/core/base/cubit/base_cubit.dart';
import 'package:flutter/material.dart';

import '../../../cubit/wallet_animation_state.dart';

/// Mixin that provides data for the Dynamic Island blob content (suggested contacts, contact list).
/// Override [suggestedContactNames], [suggestedContactColors], [contactListNames], [contactListInitials]
/// in tests or when loading from API.
mixin BlobContentCubitMixin on BaseCubit<WalletAnimationState> {
  /// Names shown in the pill and as suggested contact circles.
  List<String> get suggestedContactNames => const ['Farid', 'Shadi', 'Cyrus'];

  /// Colors for suggested contact circles. Use [AppColors.avatarColors] if you need more.
  List<Color> get suggestedContactColors => const [
        Color(0xFFFF8A65),
        Color(0xFF29B6F6),
        Color(0xFFB9F6CA),
      ];

  /// Full names for the "Your Contacts" list.
  List<String> get contactListNames => const [
        'Annette Black',
        'Cameron Williamson',
        'Jane Cooper',
        'Wade Warren',
        'Devon Lane',
        'Molly Sanders',
      ];

  /// Initials for the contact list avatars (one per [contactListNames]).
  List<String> get contactListInitials => const ['A', 'C', 'J', 'W', 'D', 'M'];

  /// Avatar color for contact list item at [index]. Uses [AppColors.avatarColors].
  Color avatarColorForIndex(int index) =>
      AppColors.avatarColors[index % AppColors.avatarColors.length];
}
