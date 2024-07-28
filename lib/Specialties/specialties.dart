import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_banhang/Cart/Cartpage.dart';

class Specialties extends StatefulWidget {
  const Specialties({Key? key}) : super(key: key);
  @override
  State<Specialties> createState() => _SpecialtiesState();
}

class _SpecialtiesState extends State<Specialties> {
  List<DocumentSnapshot> selectedProducts = [];
  final CollectionReference products2 =
  FirebaseFirestore.instance.collection('products2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed:
          () => {
            Navigator.pop(context)
          },
              child: const Icon(Icons.east_rounded))
        ],
      ),
      body: StreamBuilder(
        stream: products2.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No data available');
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.only(bottom:16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: Column(
                    children: [
                      Expanded(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: NetworkImage(data['images']),
                              fit: BoxFit.cover),
                            ),
                          ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        data['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['category']}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data['content']}',
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () => {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()))
                        },
                        child: Text(
                          'Price: ${data['price']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
