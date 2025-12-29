import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class StorageService {
  // Posts'larni saqlash
  Future<void> savePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = posts.map((post) => post.toJson()).toList();
    await prefs.setString('posts', jsonEncode(postsJson));
  }

  // Posts'larni yuklash
  Future<List<Post>> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsString = prefs.getString('posts');

    if (postsString == null || postsString.isEmpty) {
      return _getDefaultPosts();
    }

    try {
      final List<dynamic> postsJson = jsonDecode(postsString);
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      return _getDefaultPosts();
    }
  }

  // Default posts
  List<Post> _getDefaultPosts() {
    return [
      Post(
        id: '1',
        username: 'gabrielcali',
        userImage: 'https://i.pravatar.cc/150?img=1',
        postImage:
            'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
        caption: 'Beautiful pitbull enjoying the day! 🐕',
        likes: 1234,
        comments: [],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Post(
        id: '2',
        username: 'nature_lover',
        userImage: 'https://i.pravatar.cc/150?img=2',
        postImage:
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        caption: 'Amazing sunset view from the mountains 🌄',
        likes: 2341,
        comments: [],
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Post(
        id: '3',
        username: 'foodie_paradise',
        userImage: 'https://i.pravatar.cc/150?img=3',
        postImage:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
        caption: 'Delicious homemade pizza 🍕',
        likes: 5623,
        comments: [],
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];
  }

  // Bitta postni yangilash
  Future<void> updatePost(Post updatedPost) async {
    final posts = await loadPosts();
    final index = posts.indexWhere((p) => p.id == updatedPost.id);

    if (index != -1) {
      posts[index] = updatedPost;
      await savePosts(posts);
    }
  }

  // Comment qo'shish
  Future<void> addComment(String postId, Comment comment) async {
    final posts = await loadPosts();
    final postIndex = posts.indexWhere((p) => p.id == postId);

    if (postIndex != -1) {
      posts[postIndex].comments.add(comment);
      await savePosts(posts);
    }
  }
}
