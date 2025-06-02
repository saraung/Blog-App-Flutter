import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/bookmarks.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatefulWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;

  const BlogViewerPage({super.key, required this.blog});

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  final BookmarkLocalDataSource bookmarkLocalDataSource =
      BookmarkLocalDataSource();
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final bookmarked =
        await bookmarkLocalDataSource.isBookmarked(widget.blog.id);
    setState(() {
      isBookmarked = bookmarked;
    });
  }

  Future<void> _toggleBookmark() async {
    await bookmarkLocalDataSource.toggleBookmark(widget.blog.id);
    await _checkBookmark();
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  "By ${blog.posterName}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min read",
                      style: const TextStyle(
                        color: AppPallete.greyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleBookmark,
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.blue : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(height: 20),
                Text(
                  blog.content,
                  style: const TextStyle(fontSize: 16, height: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
