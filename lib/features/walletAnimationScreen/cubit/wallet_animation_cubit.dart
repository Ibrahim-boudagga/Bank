import 'package:bank/features/walletAnimationScreen/models/transaction.dart';

import '../../../core/base/exports/export.dart';
import 'wallet_animation_state.dart';

class WalletAnimationCubit extends BaseCubit<WalletAnimationState> {
  WalletAnimationCubit(super.initialState);

  @override
  Future<void> onInit() async {
    super.onInit();
    await getTransactions();
  }

  Future<void> getTransactions() async {
    emit(state.copyWith(status: .loading, transactions: [..._skeletonTransactions]));
    await Future.delayed(const Duration(seconds: 10));
    final result = <Transaction>[...transactions, ...transactions, ..._skeletonTransactions];
    if (result.isEmpty) {
      emit(state.copyWith(status: .empty, transactions: []));
    } else {
      emit(state.copyWith(status: .success, transactions: result));
    }
  }

  List<Transaction> get _skeletonTransactions => List.generate(
    6,
    (_) => const Transaction(
      icon: Icons.receipt_long_outlined,
      title: 'Placeholder merchant',
      subtitle: 'Category • Date',
      amount: 0.00,
    ),
  );

  List<Transaction> get transactions => [
    const Transaction(
      icon: Icons.arrow_circle_up_outlined,
      title: 'Deposit',
      subtitle: 'Category • Date',
      amount: 120.00,
    ),
    const Transaction(
      icon: Icons.receipt_long_outlined,
      title: 'Withdraw',
      subtitle: 'Category • Date',
      amount: -120.00,
    ),
    const Transaction(
      icon: Icons.phone,
      title: 'Phone',
      subtitle: 'Category • Date',
      amount: -120.00,
    ),
    const Transaction(icon: Icons.home, title: 'Home', subtitle: 'Category • Date', amount: 120.00),
  ];
}
