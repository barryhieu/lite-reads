import 'package:book_reader/features/list_books/providers/coin_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListBooksUserCoin extends ConsumerWidget {
  ListBooksUserCoin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coin = ref.watch(coinProvider);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Text(
        '🪙 $coin',
        key: ValueKey(coin), // cần để trigger AnimatedSwitcher
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
