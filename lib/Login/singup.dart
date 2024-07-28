import 'package:app_banhang/Drawer/bottomMenu/bottommenu.dart';
import 'package:app_banhang/Login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _configController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool passwordConfirmed() {
    return _passwordController.text.trim() == _configController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.red,
            Colors.blue,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 40),
                _inputField("Name", _nameController, Icons.person),
                SizedBox(height: 20),
                _inputField("Email", _emailController, Icons.email),
                SizedBox(height: 20),
                _inputField("Password", _passwordController, Icons.lock, isPassword: true),
                SizedBox(height: 20),
                _inputField("Confirm Password", _configController, Icons.lock_outline, isPassword: true),
                SizedBox(height: 30),
                _registerButton(),
                SizedBox(height: 15),
                _extraText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String labelText, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      style: const TextStyle(color: Colors.white, fontSize: 18),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (isPassword && labelText == "Confirm Password" && !passwordConfirmed()) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          try {
            UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            // Update the user profile with the display name
            await userCredential.user?.updateDisplayName(_nameController.text);
            await userCredential.user?.reload();
            User? updatedUser = _auth.currentUser;

            // Save user information to Firestore
            await _firestore.collection('users').doc(updatedUser?.uid).set({
              'Name': _nameController.text,
              'Email': _emailController.text.trim(),
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavBar()),
            );
          } on FirebaseAuthException catch (e) {
            print("Error: $e");
          }
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _extraText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
        child: Row(
          children: [
            const Text(
              "Bạn đã có tài khoản?  ",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Material(
              color: Colors.transparent,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.cyan[100],
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
