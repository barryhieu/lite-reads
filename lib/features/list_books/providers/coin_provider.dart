import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final coinProvider = StateNotifierProvider<CoinNotifier, int>((ref) {
  return CoinNotifier();
});

class CoinNotifier extends StateNotifier<int> {
  CoinNotifier() : super(0) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('coin_balance') ?? 100;
  }

  Future<void> update(int newBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coin_balance', newBalance);
    state = newBalance;
  }

  Future<void> decrease(int amount) async {
    await update(state - amount);
  }

  Future<void> increase(int amount) async {
    await update(state + amount);
  }
}
