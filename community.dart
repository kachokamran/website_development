import 'package:flutter/material.dart';

void main() {
  runApp(CommunityEngagementApp());
}

class CommunityEngagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Engagement',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PostListScreen(),
    );
  }
}

class Post {
  String title;
  String content;
  int likes;
  List<String> comments;

  Post({
    required this.title,
    required this.content,
    this.likes = 0,
    this.comments = const [],
  });
}

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final List<Post> posts = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addPost() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      setState(() {
        posts.add(Post(title: title, content: content));
        _titleController.clear();
        _contentController.clear();
      });
    }
  }

  void _likePost(int index) {
    setState(() {
      posts[index].likes++;
    });
  }

  void _addComment(int index, String comment) {
    setState(() {
      posts[index].comments.add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Engagement'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostWidget(
                  post: posts[index],
                  onLike: () => _likePost(index),
                  onComment: _addComment,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Post Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Post Content'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addPost,
                  child: Text('Add Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final Function(int index, String comment) onComment;

  PostWidget({
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(post.content),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: onLike,
                ),
                Text('${post.likes} Likes'),
              ],
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Add a comment'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  onComment(post.comments.length, _commentController.text);
                  _commentController.clear();
                }
              },
              child: Text('Comment'),
            ),
            ...post.comments.map((comment) => Text('- $comment')).toList(),
          ],
        ),
      ),
    );
  }
}
