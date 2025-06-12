import 'package:book_reader/features/reader_main/widgets/paginated_chapter.dart';
import 'package:book_reader/helpers/constants.dart%20';
import 'package:flutter/material.dart';

class ReaderMain extends StatefulWidget {
  final String bookTitle;
  final int chapter;
  const ReaderMain({super.key, required this.bookTitle, required this.chapter});

  @override
  State<ReaderMain> createState() => ReaderMainState();
}

class ReaderMainState extends State<ReaderMain> {
  bool isSwipeMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📖 ${widget.bookTitle} - Chương ${widget.chapter}"),
        actions: [
          IconButton(
            tooltip: isSwipeMode ? 'Switch to Scroll' : 'Switch to Swipe',
            icon: Icon(isSwipeMode ? Icons.swap_horiz : Icons.swap_vert),
            onPressed: () {
              setState(() {
                isSwipeMode = !isSwipeMode;
              });
            },
          ),
        ],
      ),
      body: isSwipeMode
          ? PaginatedChapter(text: chapter1)
          : Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0,
              ),
              child: SingleChildScrollView(
                child: Text(
                  chapter1,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                ),
              ),
            ),
    );
  }
}
