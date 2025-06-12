import 'package:book_reader/features/list_books/providers/coin_provider.dart';
import 'package:book_reader/features/list_books/widgets/animated_coins.dart';
import 'package:book_reader/features/list_books/widgets/list_books_user_coin.dart';
import 'package:book_reader/features/reader_main/reader_main.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListBooksHeader extends ConsumerWidget implements PreferredSizeWidget {
  const ListBooksHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Row(
        children: [
          const Text('📚 Sách và tài liệu'),
          const Spacer(),
          const SizedBox(width: 4),
          ListBooksUserCoin(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

Future<void> showChaptersDialog(
  BuildContext context,
  String bookTitle,
  WidgetRef ref,
) async {
  final Map<int, GlobalKey> chapterKeys = {
    for (int i = 1; i <= 16; i++) i: GlobalKey(),
  };

  final prefs = await SharedPreferences.getInstance();
  final key = 'unlocked_${bookTitle.hashCode}';
  final unlockedChapters =
      prefs.getStringList(key)?.map(int.parse).toSet() ??
      {1}; // Chương 1 mở sẵn

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("📖 $bookTitle", style: TextStyle(fontSize: 18)),
                ListBooksUserCoin(),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 16,
                itemBuilder: (context, index) {
                  final chapter = index + 1;
                  final isUnlocked = unlockedChapters.contains(chapter);

                  return ListTile(
                    title: Text('Chương $chapter'),
                    leading: Icon(
                      isUnlocked ? Icons.menu_book : Icons.lock_outline,
                      color: isUnlocked ? Colors.green : Colors.grey,
                    ),
                    trailing: isUnlocked
                        ? const Text(" ")
                        : ElevatedButton.icon(
                            key: chapterKeys[chapter],
                            icon: const Icon(Icons.lock_open),
                            label: const Text("10 🪙"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              await animateCoinFlyUp(
                                context: context,
                                fromKey: chapterKeys[chapter]!,
                              );
                              final coinNotifier = ref.read(
                                coinProvider.notifier,
                              );
                              final currentCoins = ref.read(coinProvider);

                              if (currentCoins >= 10) {
                                unlockedChapters.add(chapter);
                                await prefs.setStringList(
                                  key,
                                  unlockedChapters
                                      .map((e) => e.toString())
                                      .toList(),
                                );

                                await coinNotifier.decrease(10);
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Không đủ coin!"),
                                  ),
                                );
                              }
                            },
                          ),
                    onTap: isUnlocked
                        ? () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReaderMain(
                                  bookTitle: bookTitle,
                                  chapter: chapter,
                                ),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Đóng"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    },
  );
}
