import 'package:simple_chat_app/screens/chat_screen.dart';
import 'package:simple_chat_app/screens/sign_up_screen.dart';
import 'package:simple_chat_app/services/AuthService.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const id = 'sign_in_screen';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  String _emailErrorText;
  String _passwordErrorText;

  Map<String, dynamic> _validateForm() {
    // Reset validation state
    setState(() {
      _emailErrorText = null;
      _passwordErrorText = null;
    });

    bool isValid = true;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      if (email.isEmpty) {
        _emailErrorText = 'Please enter your email.';
        isValid = false;
      }
      if (password.isEmpty) {
        _passwordErrorText = 'Please enter your password.';
        isValid = false;
      }
    });

    return {
      'isValid': isValid,
      'email': email,
      'password': password,
    };
  }

  Future<void> _signIn() async {
    final formData = _validateForm();
    if (formData['isValid']) {
      try {
        final user = await AuthService.signIn(
          email: formData['email'],
          password: formData['password'],
        );
        if (user != null) {
          Navigator.pushReplacementNamed(context, ChatScreen.id);
        }
      } catch (e) {
        setState(() {
          switch (e.code) {
            case 'ERROR_INVALID_EMAIL':
              _emailErrorText = 'Please enter a valid email.';
              break;
            case 'ERROR_USER_NOT_FOUND':
              _emailErrorText = 'User not found.';
              break;
            case 'ERROR_USER_DISABLED':
              _emailErrorText = 'This user has been disabled.';
              break;
            case 'ERROR_WRONG_PASSWORD':
              _passwordErrorText = 'Wrong password';
              break;
            default:
              _emailErrorText = 'An error occurred.';
          }
        });
      }
    }
  }

  Future _signUp() async {
    final result = await Navigator.pushNamed(context, SignUpScreen.id);
    if (result == true) {
      Navigator.pushReplacementNamed(context, ChatScreen.id);
    }
  }

  Future _checkSession() async {
    final user = await AuthService.currentUser();
    if (user != null) {
      Navigator.pushReplacementNamed(context, ChatScreen.id);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSession());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailErrorText,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  _emailFocusNode.unfocus();
                  _passwordFocusNode.requestFocus();
                },
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _passwordErrorText,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 12.0),
              RaisedButton(
                onPressed: _signIn,
                child: Text('Sign in'),
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(16.0),
              ),
              SizedBox(height: 24.0),
              Text(
                'Or create account',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              RaisedButton(
                onPressed: _signUp,
                child: Text('Sign up'),
                color: Colors.green,
                textColor: Colors.white,
                padding: EdgeInsets.all(16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
