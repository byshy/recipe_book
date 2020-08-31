import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_book/auth/sign_up_screen.dart';
import 'package:recipe_book/utils/colors.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Recipe Book',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset('assets/images/logo.png'),
              ],
            ),
            SizedBox(height: 70),
            TextField(
              controller: _emailController,
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
              controller: _passwordController,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            FlatButton(
              color: Colors.white,
              onPressed: emailPasswordLogin,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: green34A853,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Login with',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SignUpScreen(),
                  ),
                );
              },
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                'Create an account',
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

  void emailPasswordLogin() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${user.email} signed in"),
      ));
    } on FirebaseAuthException catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Expanded(child: Text("${e.message}")),
            ],
          ),
        ),
      );
    }
  }
}
