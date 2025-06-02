import 'package:shared_preferences/shared_preferences.dart';

class BookmarkLocalDataSource {
  static const _bookmarkKey = 'bookmarked_blog_ids';

  Future<Set<String>> getBookmarkedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_bookmarkKey);
    return ids?.toSet() ?? <String>{};
  }

  Future<bool> isBookmarked(String blogId) async {
    final bookmarkedIds = await getBookmarkedIds();
    return bookmarkedIds.contains(blogId);
  }

  Future<void> addBookmark(String blogId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedIds = await getBookmarkedIds();
    bookmarkedIds.add(blogId);
    await prefs.setStringList(_bookmarkKey, bookmarkedIds.toList());
  }

  Future<void> removeBookmark(String blogId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedIds = await getBookmarkedIds();
    bookmarkedIds.remove(blogId);
    await prefs.setStringList(_bookmarkKey, bookmarkedIds.toList());
  }

  Future<void> toggleBookmark(String blogId) async {
    final bookmarkedIds = await getBookmarkedIds();
    if (bookmarkedIds.contains(blogId)) {
      await removeBookmark(blogId);
    } else {
      await addBookmark(blogId);
    }
  }
}
