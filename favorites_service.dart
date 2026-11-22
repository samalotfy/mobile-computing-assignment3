import 'package:hive/hive.dart';
import '../models/post_model.dart';

class FavoritesService {
  static const String boxName = 'favoritesBox';

  // The box is already opened in main.dart, so reading it is synchronous.
  Box<Post> get _box => Hive.box<Post>(boxName);

  /// Adds the post to favorites if it is not there, removes it otherwise.
  Future<void> toggleFavorite(Post post) async {
    if (_box.containsKey(post.id)) {
      await _box.delete(post.id);
    } else {
      // A HiveObject can only live in one box, so save a COPY.
      final copy = Post(
        id: post.id,
        title: post.title,
        body: post.body,
        userId: post.userId,
      );
      await _box.put(post.id, copy);
    }
  }

  bool isFavorite(int id) => _box.containsKey(id);

  List<Post> getFavorites() => _box.values.toList();
}