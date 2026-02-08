import 'package:bank/app/design/theme/app_theme.dart';

import '../models/transaction.dart';

enum TransactionStatus { initial, loading, success, empty, failure }

class WalletAnimationState {
  final TransactionStatus? status;
  final List<Transaction> transactions;
  final IslandState islandState;

  const WalletAnimationState({
    this.status,
    this.transactions = const [],
    this.islandState = const IslandState(height: AppSpacing.islandStartHeight, progress: 0.0),
  });

  factory WalletAnimationState.initial() =>
      const WalletAnimationState(status: TransactionStatus.initial);

  WalletAnimationState copyWith({
    TransactionStatus? status,
    List<Transaction>? transactions,
    IslandState? islandState,
  }) => WalletAnimationState(
    status: status ?? this.status,
    transactions: transactions ?? this.transactions,
    islandState: islandState ?? this.islandState,
  );
}

class IslandState {
  final double height;
  final double progress;

  const IslandState({required this.height, required this.progress});

  IslandState copyWith({double? height, double? progress}) =>
      IslandState(height: height ?? this.height, progress: progress ?? this.progress);
}
