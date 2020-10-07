import 'dart:convert';

import 'package:e_commerce_/pages/products_page.dart';
import 'package:e_commerce_/pages/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  bool _isSubmitting;
  String _username, _email, _password;

  Widget _showTitle() {
    return Text('Login', style: Theme.of(context).textTheme.headline5);
  }

  Widget _emailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _email = val,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) =>
                !val.contains('@') ? 'Invalid e-mail address' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25),
                ),
                labelText: 'E-Mail',
                hintText: 'Enter a valid E-mail',
                prefixIcon: Icon(Icons.alternate_email, color: Colors.grey))));
  }

  Widget _userPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _password = val,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (val) => val.length < 6 ? 'Password is too short' : null,
        obscureText: _obscureText,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: 'Password',
          hintText: 'Enter Password, min length 6',
          prefixIcon: Icon(Icons.lock, color: Colors.grey),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: _obscureText
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
          ),
        ),
      ),
    );
  }

  Widget _showFormButtons() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _isSubmitting == true
              ? NutsActivityIndicator(
                  animating: true,
                  animationDuration: Duration(milliseconds: 200),
                  activeColor: Colors.green,
                  inactiveColor: Colors.green,
                )
              : RaisedButton(
                  onPressed: _submit,
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: Theme.of(context).accentColor,
                ),
          FlatButton(
            onPressed: () => Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => RegisterPage())),
            child: Text('New user? Register'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    final response =
        await http.post('http://192.168.1.7:1337/auth/local', body: {
      'identifier': _email,
      'password': _password,
    });
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
      _storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();
      // print(responseData);
    } else {
      setState(() {
        _isSubmitting = false;
      });
      final error = responseData['message'];
      _showErrorSnack(error);
    }
  }

  _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
    prefs.setString('token', json.encode(responseData['jwt']));

    print('done');
    print(json.encode(user));
  }

  _showSuccessSnack() {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        'User $_username successfully Logged in!',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  _showErrorSnack(error) {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        '$error !',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    throw Exception('Error Logging in: $error');
  }

  _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => ProductsPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _showTitle(),
                  _emailInput(),
                  _userPasswordInput(),
                  _showFormButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
