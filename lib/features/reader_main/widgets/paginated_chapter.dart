import 'package:flutter/material.dart';

class PaginatedChapter extends StatefulWidget {
  final String text;

  const PaginatedChapter({super.key, required this.text});

  @override
  State<PaginatedChapter> createState() => _PaginatedChapterState();
}

class _PaginatedChapterState extends State<PaginatedChapter> {
  List<String> pages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _splitTextIntoPages();
  }

  void _splitTextIntoPages() {
    final text = widget.text;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final textStyle = const TextStyle(fontSize: 18, height: 1.5);
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    textPainter.layout(maxWidth: screenWidth - 32); // padding

    final linesPerPage =
        (screenHeight - 100) ~/ (textStyle.fontSize! * textStyle.height!);
    final words = text.split(' ');
    final buffer = StringBuffer();
    List<String> resultPages = [];

    int currentLine = 0;
    for (var word in words) {
      buffer.write('$word ');
      textPainter.text = TextSpan(text: buffer.toString(), style: textStyle);
      textPainter.layout(maxWidth: screenWidth - 32);

      final lines = textPainter.computeLineMetrics().length;

      if (lines > linesPerPage) {
        // Save previous
        final last = buffer.toString().trim().split(' ');
        last.removeLast(); // remove last word that caused overflow
        resultPages.add(last.join(' '));

        // start new page with current word
        buffer.clear();
        buffer.write('$word ');
      }
    }

    // Add remaining content
    if (buffer.isNotEmpty) {
      resultPages.add(buffer.toString());
    }

    setState(() {
      pages = resultPages;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return PageView.builder(
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            pages[index],
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
        );
      },
    );
  }
}
