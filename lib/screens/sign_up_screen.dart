import 'package:simple_chat_app/services/AuthService.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const id = 'sign_up_screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _displayNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  String _emailErrorText;
  String _displayNameErrorText;
  String _passwordErrorText;
  String _confirmPasswordErrorText;

  Map<String, dynamic> _validateForm() {
    // Reset validation state
    setState(() {
      _emailErrorText = null;
      _displayNameErrorText = null;
      _passwordErrorText = null;
      _confirmPasswordErrorText = null;
    });

    bool isValid = true;

    final email = _emailController.text.trim();
    final displayName = _displayNameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      if (email.isEmpty) {
        _emailErrorText = 'Please enter your email.';
        isValid = false;
      }
      if (displayName.isEmpty) {
        _displayNameErrorText = 'Please enter display name';
        isValid = false;
      }
      if (password.isEmpty) {
        _passwordErrorText = 'Please enter your password.';
        isValid = false;
      }
      if (password != confirmPassword) {
        _confirmPasswordErrorText = 'Password does not match.';
        isValid = false;
      }
    });

    return {
      'isValid': isValid,
      'email': email,
      'displayName': displayName,
      'password': password,
    };
  }

  Future _signUp() async {
    final formData = _validateForm();
    if (formData['isValid']) {
      try {
        final user = await AuthService.signUp(
          email: formData['email'],
          displayName: formData['displayName'],
          password: formData['password'],
        );
        if (user != null) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        setState(() {
          switch (e.code) {
            case 'ERROR_INVALID_EMAIL':
              _emailErrorText = 'Please enter a valid email.';
              break;
            case 'ERROR_EMAIL_ALREADY_IN_USE':
              _emailErrorText = 'Email already in use.';
              break;
            case 'ERROR_WEAK_PASSWORD':
              _passwordErrorText = 'Please enter a strong password';
              break;
            default:
              _emailErrorText = 'An error occurred.';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
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
                  _displayNameFocusNode.requestFocus();
                },
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _displayNameController,
                focusNode: _displayNameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Display name',
                  errorText: _displayNameErrorText,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  _displayNameFocusNode.unfocus();
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
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  _passwordFocusNode.unfocus();
                  _confirmPasswordFocusNode.requestFocus();
                },
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  errorText: _confirmPasswordErrorText,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 12.0),
              RaisedButton(
                onPressed: _signUp,
                child: Text('Sign up'),
                color: Colors.blue,
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
