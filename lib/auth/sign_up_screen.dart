import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_book/utils/colors.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _rePassController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _rePassFocus = FocusNode();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1960),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dobController.text =
            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
      });
    FocusScope.of(context).requestFocus(_passFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background.png'),
        )),
        child: ListView(
          padding: const EdgeInsets.only(
            top: 70,
            left: 16,
            right: 16,
            bottom: 10,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                    ),
                  ),
                ),
                Image.asset('assets/images/logo.png'),
              ],
            ),
            SizedBox(height: 70),
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_emailFocus);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                filled: true,
                fillColor: Color(0x77FFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              focusNode: _emailFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                _selectDate(context);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                filled: true,
                fillColor: Color(0x77FFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dobController,
              onTap: () => _selectDate(context),
              readOnly: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Date of birth',
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                filled: true,
                fillColor: Color(0x77FFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passController,
              focusNode: _passFocus,
              textInputAction: TextInputAction.next,
              obscureText: true,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_rePassFocus);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                filled: true,
                fillColor: Color(0x77FFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _rePassController,
              focusNode: _rePassFocus,
              textInputAction: TextInputAction.done,
              obscureText: true,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Retype password',
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                filled: true,
                fillColor: Color(0x77FFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            FlatButton(
              color: Colors.white,
              onPressed: () => _register(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                  color: green34A853,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Register with',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                Expanded(
                  child: FlatButton(
                    color: blue3B5999,
                    onPressed: () => _signInWithFacebook(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Image.asset('assets/images/facebook.png'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FlatButton(
                    color: Colors.white,
                    onPressed: () => _signInWithGoogle(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Image.asset('assets/images/google.png'),
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Or',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            FlatButton(
              color: green34A853,
              onPressed: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    try {
      UserCredential userCredential;
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAccount googleAcc = googleUser;
      if (googleAcc == null) {
        throw Exception('Couldn\'t get User');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleAcc.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);

      final user = userCredential.user;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Sign In ${user.uid} with Google"),
      ));
    } catch (e) {
      print(e);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: ${e.message}"),
      ));
    }
  }

  void _signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        try {
          final AuthCredential credential = FacebookAuthProvider.credential(
            result.accessToken.token,
          );
          final User user = (await _auth.signInWithCredential(credential)).user;

          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Sign In ${user.uid} with Facebook"),
          ));
        } catch (e) {
          print(e);
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Failed to sign in with Facebook, ${e.toString()}"),
          ));
        }
//        _showLoggedInUI();
        break;
      case FacebookLoginStatus.cancelledByUser:
//        _showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
//        _showErrorOnUI(result.errorMessage);
        break;
    }
  }

  void _register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passController.text,
    ))
        .user;
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Sign In ${user.uid} with Email/Password"),
    ));

    FirebaseFirestore.instance.runTransaction((transaction) async {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      transaction.set(users.doc(user.uid), {
        'name': _nameController.text,
        'dob': selectedDate.toString(),
      });
    });
  }
}
