import 'package:app_banhang/Cart/Cartpage.dart';
import 'package:app_banhang/Login/Login.dart';
import 'package:app_banhang/project/favorite/favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<String>(
              future: getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error');
                } else {
                  return Text(snapshot.data ?? 'No Name');
                }
              },
            ),
            accountEmail: Text(_auth.currentUser?.email ?? 'No Email'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _auth.currentUser?.email?.substring(0, 1).toUpperCase() ?? 'A',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text('Your Cart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          ListTile(
            title: Text('Favorites Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> getUserName() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc['Name'] ?? 'No Name';
  }
}

class BestSellingProductsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Best Selling Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('products').orderBy('sales', descending: true).limit(10).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView(
              children: snapshot.data?.docs.map((doc) {
                return ListTile(
                  title: Text(doc['Name']),
                  subtitle: Text('Sales: ${doc['sales']}'),
                );
              }).toList() ?? [],
            );
          }
        },
      ),
    );
  }
}
