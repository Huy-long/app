import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cart {
  static Future<void> addItem(Map<String, dynamic> itemData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart');
      final productId = itemData['id'];
      final existingItem = await cartCollection.doc(productId).get();

      if (existingItem.exists) {
        // If the item already exists in the cart, update the quantity
        final newQuantity = (existingItem.data()!['quantity'] as int) + 1;
        await cartCollection.doc(productId).update({'quantity': newQuantity});
      } else {
        // If the item does not exist, add it to the cart
        await cartCollection.doc(productId).set(itemData);
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart');
      final querySnapshot = await cartCollection.get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }
    return [];
  }

  static Future<void> updateItemQuantity(String productId, int newQuantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart');
      await cartCollection.doc(productId).update({'quantity': newQuantity});
    }
  }

  static Future<void> removeItem(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart');
      await cartCollection.doc(productId).delete();
    }
  }

  static Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart');
      final querySnapshot = await cartCollection.get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }
  }
}
