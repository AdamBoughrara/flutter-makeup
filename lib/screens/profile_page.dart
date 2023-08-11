import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isSignIn = true;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Check if the user is already signed in
    _auth.authStateChanges().listen((user) {
      setState(() {
        _isSignedIn = user != null;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 100,
          lightSource: LightSource.top,
          intensity: 0.7,
          color: Colors.white.withOpacity(0.65),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 46.0, horizontal: 36),
        //margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _isSignedIn
              ? [
                  Text(
                    'You are signed in as:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    _auth.currentUser?.email ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text('Log Out'),
                  ),
                ]
              : [
                  Text(_isSignIn ? 'Sign In' : 'Register',
                      style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isSignIn ? _signIn : _register,
                    child: Text(_isSignIn ? 'Sign In' : 'Register'),
                  ),
                  TextButton(
                    onPressed: _toggleMode,
                    child: Text(
                        _isSignIn ? 'Switch to Register' : 'Switch to Sign In'),
                  ),
                ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('Signed in as ${_auth.currentUser?.email}');
    } catch (e) {
      print('Sign in failed: $e');
    }
  }

  Future<void> _register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('Registered and signed in as ${_auth.currentUser?.email}');
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } catch (e) {
      print('Sign out failed: $e');
    }
  }

  void _toggleMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }
}
