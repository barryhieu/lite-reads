import 'package:book_reader/features/list_books/widgets/list_books_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Book {
  final String title;
  final String author;
  final int year;
  final String summary;
  final String coverUrl;

  Book({
    required this.title,
    required this.author,
    required this.year,
    required this.summary,
    required this.coverUrl,
  });
}

class ListBookScreen extends ConsumerWidget {
  ListBookScreen({super.key});
  int coinBalance = 0;

  final List<Book> books = [
    Book(
      title: "Clean Code",
      author: "Robert C. Martin",
      year: 2008,
      summary: "A handbook of agile software craftsmanship.",
      coverUrl:
          "https://images-na.ssl-images-amazon.com/images/I/41SH-SvWPxL._SX374_BO1,204,203,200_.jpg",
    ),
    Book(
      title: "The Pragmatic Programmer",
      author: "Andrew Hunt & David Thomas",
      year: 1999,
      summary: "Classic tips to improve your programming practices.",
      coverUrl:
          "https://m.media-amazon.com/images/I/513Y5o-DYtL._SX328_BO1,204,203,200_.jpg",
    ),

    Book(
      title: "You Don’t Know JS",
      author: "Kyle Simpson",
      year: 2014,
      summary: "A deep dive into the JavaScript language.",
      coverUrl:
          "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTHERFB-nSKQNBpospSKjqmjwFbA4j5cYu2YEfdvLnWiFTRnUfU",
    ),
    Book(
      title: "Flutter in Action",
      author: "Eric Windmill",
      year: 2020,
      summary: "Hands-on guide to building apps with Flutter.",
      coverUrl:
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNvPCIG-0Q8UW0L0z2bIAl-mhwp3l3t4X2-1UlJ07K2tIbuvEx",
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ListBooksHeader(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () => showChaptersDialog(context, book.title, ref),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh bìa sách
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.coverUrl,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 120,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Thông tin sách
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tác giả: ${book.author}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Năm: ${book.year}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            book.summary,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
