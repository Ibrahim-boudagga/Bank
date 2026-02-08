import '../models/transaction.dart';

enum TransactionStatus { initial, loading, success, empty, failure }

class WalletAnimationState {
  final TransactionStatus? status;
  final List<Transaction> transactions;

  const WalletAnimationState({this.status, this.transactions = const []});

  factory WalletAnimationState.initial() =>
      const WalletAnimationState(status: TransactionStatus.initial);

  WalletAnimationState copyWith({TransactionStatus? status, List<Transaction>? transactions}) =>
      WalletAnimationState(
        status: status ?? this.status,
        transactions: transactions ?? this.transactions,
      );
}
