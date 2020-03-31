import 'package:flutter/material.dart';
import 'package:mentorship/AuthWidgets/register_screen.dart';
import '../services/authservice.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _pass = "";
  bool _isLoading = false;
  String _errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.black, Colors.black87],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset('assets/logo.png'),
              ),
              showErrorMessage(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    _email = value;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.email,
                      color: Colors.red[300],
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[300]),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.red[300],
                    ),
                    labelText: 'Email',
                    focusColor: Colors.white,
                  ),
                  cursorColor: Colors.red[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    _pass = value;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.red[300],
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[300]),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.red[300],
                    ),
                    labelText: 'Password',
                    focusColor: Colors.white,
                  ),
                  cursorColor: Colors.red[300],
                ),
              ),
              showCircularProgress(),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: RaisedButton(
                  onPressed: validateAndSubmit,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.red[300], width: 2),
                  ),
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    child: Text(
                      "Log in",
                      style: TextStyle(color: Colors.red[300], fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegisterScreen(auth: widget.auth)),
                    );
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.red[300], fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    String userId = "";
    try {
      userId = await widget.auth.signIn(_email, _pass);
      print('Signed in: $userId');
      setState(() {
        _isLoading = false;
      });

      if (userId.length > 0 && userId != null) {
        widget.loginCallback();
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    }
  }

  Widget showErrorMessage() {
    if (_errorMessage != "") {
      return Text(
        _errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red[300]),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]),
      ));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
