import 'package:bank/core/base/cubit/base_cubit.dart';
import 'package:bank/core/base/exports/export.dart' show Icons;

import '../../../cubit/wallet_animation_state.dart';
import '../../../models/transaction.dart';


mixin TransactionsCubitMixin on BaseCubit<WalletAnimationState> {
  Future<void> fetchTransactions() async {
    emit(state.copyWith(
      status: TransactionStatus.loading,
      transactions: skeletonTransactions,
    ));
    await Future.delayed(const Duration(seconds: 2));
    final result = <Transaction>[...seedTransactions, ...seedTransactions, ...skeletonTransactions];
    if (result.isEmpty) {
      emit(state.copyWith(status: .empty, transactions: []));
    } else {
      emit(state.copyWith(status: .success, transactions: result));
    }
  }

  List<Transaction> get skeletonTransactions => List.generate(
    6,
    (_) => const Transaction(
      icon: Icons.receipt_long_outlined,
      title: 'Placeholder merchant',
      subtitle: 'Category • Date',
      amount: 0.00,
    ),
  );

  List<Transaction> get seedTransactions => [
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
    const Transaction(
      icon: Icons.home,
      title: 'Home',
      subtitle: 'Category • Date',
      amount: 120.00,
    ),
  ];
}
