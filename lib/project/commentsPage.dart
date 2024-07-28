import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsPage extends StatelessWidget {
  final String productId;

  const CommentsPage({Key? key, required this.productId}) : super(key: key);

  Future<void> _deleteComment(BuildContext context, String commentId) async {
    try {
      await FirebaseFirestore.instance.collection('comments').doc(commentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete comment: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('productId', isEqualTo: productId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var comments = snapshot.data!.docs;

          if (comments.isEmpty) {
            return Center(child: Text('No comments yet.'));
          }

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              var commentData = comments[index].data() as Map<String, dynamic>;
              var commentId = comments[index].id; // Get the comment ID
              var userEmail = commentData['email'] ?? 'Anonymous';
              var commentContent = commentData['comment'] ?? '';

              return ListTile(
                leading: Icon(Icons.person),
                title: Text(userEmail),
                subtitle: Text(commentContent),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Show a confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Comment'),
                        content: Text('Are you sure you want to delete this comment?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _deleteComment(context, commentId); // Pass context to _deleteComment
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
