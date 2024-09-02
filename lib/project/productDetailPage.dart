import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_banhang/Cart/Cart.dart';
import 'package:app_banhang/project/commentsPage.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetailPage({Key? key, required this.productData}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool? isFavorite;
  final TransformationController _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  int _currentZoomLevelIndex = 0;
  final List<double> _zoomLevels = [1.0, 2.0, 3.0, 4.0];

  @override
  void initState() {
    super.initState();
    _initializeFavoriteStatus();
  }

  Future<void> _initializeFavoriteStatus() async {
    final productId = widget.productData['id'];
    if (productId == null) {
      setState(() {
        isFavorite = false;
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isFavorite = false;
      });
      return;
    }

    final favoriteDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId);

    final favoriteSnapshot = await favoriteDoc.get();
    setState(() {
      isFavorite = favoriteSnapshot.exists;
    });
  }

  void _toggleFavorite() async {
    final productId = widget.productData['id'];

    if (productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product ID is missing'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User is not authenticated'),
        ),
      );
      return;
    }

    final favoriteDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId);

    try {
      final favoriteSnapshot = await favoriteDoc.get();
      if (favoriteSnapshot.exists) {
        await favoriteDoc.delete();
        setState(() {
          isFavorite = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from favorites'),
          ),
        );
      } else {
        await favoriteDoc.set(widget.productData);
        setState(() {
          isFavorite = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to favorites'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating favorite status: $e'),
        ),
      );
    }
  }

  void _addToCart() async {
    final productId = widget.productData['id'];
    if (productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product ID is missing'),
        ),
      );
      return;
    }

    final itemData = {
      'id': productId,
      'title': widget.productData['title'],
      'quantity': 1,
      'price': widget.productData['price'],
      'images': widget.productData['images'] ?? '', // Ensure the image URL is included
    };

    try {
      await Cart.addItem(itemData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.productData['title']} added to cart'),
        ),
      );
      setState(() {}); // Trigger UI update
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $error'),
        ),
      );
    }
  }

  void _addComment() async {
    final productId = widget.productData['id'];
    if (productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product ID is missing'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User is not authenticated'),
        ),
      );
      return;
    }

    TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment'),
        content: TextField(
          controller: _commentController,
          decoration: InputDecoration(hintText: 'Enter your comment'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                FirebaseFirestore.instance.collection('comments').add({
                  'productId': productId,
                  'comment': _commentController.text,
                  'email': user.email ?? 'Anonymous',
                  'timestamp': FieldValue.serverTimestamp(),
                }).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Comment added successfully'),
                    ),
                  );
                  Navigator.of(context).pop();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add comment: $error'),
                    ),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Comment cannot be empty'),
                  ),
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.productData['title'] ?? 'No Title';
    final String category = widget.productData['category'] ?? 'No Category';
    final price = widget.productData['price'] is int
        ? (widget.productData['price'] as int).toString()
        : widget.productData['price'] as String? ?? '0';
    final String content = widget.productData['content'] ?? 'No Content';
    final String imageUrl = widget.productData['images'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.cyan,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onDoubleTapDown: (details) {
                    _doubleTapDetails = details;
                  },
                  onDoubleTap: () {
                    setState(() {
                      _currentZoomLevelIndex = (_currentZoomLevelIndex + 1) % _zoomLevels.length;
                    });

                    if (_doubleTapDetails != null) {
                      final position = _doubleTapDetails!.localPosition;
                      _transformationController.value = Matrix4.identity()
                        ..translate(-position.dx * (_zoomLevels[_currentZoomLevelIndex] - 1),
                            -position.dy * (_zoomLevels[_currentZoomLevelIndex] - 1))
                        ..scale(_zoomLevels[_currentZoomLevelIndex]);
                    }
                  },
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.cyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite ?? false ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ?? false ? Colors.red : Colors.grey,
                            ),
                            onPressed: _toggleFavorite,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${price}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        content,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _addToCart,
                    child: const Icon(Icons.shopping_cart),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addComment,
                    child: const Icon(Icons.comment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentsPage(productId: widget.productData['id']),
                        ),
                      );
                    },
                    child: const Text("View Comments"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
