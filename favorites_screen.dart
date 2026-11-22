import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../services/favorites_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesService();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ValueListenableBuilder<Box<Post>>(
        valueListenable: Hive.box<Post>('favoritesBox').listenable(),
        builder: (context, box, _) {
          final posts = favorites.getFavorites();

          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final Post post = posts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(post.id.toString())),
                  title: Text(
                    post.title,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(post.body, maxLines: 2),
                  trailing: IconButton(
                    icon: const Icon(Icons.star, color: Colors.amber),
                    onPressed: () => favorites.toggleFavorite(post),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}