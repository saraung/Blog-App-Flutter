import 'package:blog_app/core/utils/bookmarks.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookMarkPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const BookMarkPage());
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  final BookmarkLocalDataSource bookmarkLocalDataSource =
      BookmarkLocalDataSource();
  List<Blog> bookmarkedBlogs = [];
  bool bookmarksLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  Future<void> _filterBookmarks(List<Blog> allBlogs) async {
    final bookmarkedIds = await bookmarkLocalDataSource.getBookmarkedIds();
    setState(() {
      bookmarkedBlogs =
          allBlogs.where((blog) => bookmarkedIds.contains(blog.id)).toList();
      bookmarksLoaded = true;
    });
  }

  Future<void> _removeBookmark(String blogId) async {
    await bookmarkLocalDataSource.removeBookmark(blogId);
    final state = context.read<BlogBloc>().state;
    if (state is BlogDisplaySuccess) {
      await _filterBookmarks(state.blogs);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Blogs"),
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlogDisplaySuccess) {
            if (!bookmarksLoaded) {
              _filterBookmarks(state.blogs);
              return const Center(child: CircularProgressIndicator());
            }

            if (bookmarkedBlogs.isEmpty) {
              return Center(
                  child: Text(
                "You haven’t bookmarked any blogs yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
              ));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedBlogs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final blog = bookmarkedBlogs[index];
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(context, BlogViewerPage.route(blog));
                    await _filterBookmarks(state.blogs);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isDark
                          ? theme.cardColor.withOpacity(0.8)
                          : Colors.white,
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.network(
                            blog.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade800,
                              width: 100,
                              height: 100,
                              child:
                                  const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                        // Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blog.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "By ${blog.posterName}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Delete Icon
                        IconButton(
                          icon: Icon(Icons.bookmark_remove_outlined,
                              color: theme.iconTheme.color),
                          onPressed: () => _removeBookmark(blog.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is BlogFailure) {
            return Center(child: Text("Error: ${state.error}"));
          } else {
            return const Center(child: Text("Something went wrong."));
          }
        },
      ),
    );
  }
}
