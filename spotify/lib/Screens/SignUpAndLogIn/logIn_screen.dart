import 'package:flutter/material.dart';
import 'forgot_password_email_screen.dart';
import '../../Providers/authorization_provider.dart';
import '../../Providers/user_provider.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = '/login_screen';
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _passwordVisible;
  bool _validate;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    _validate = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _auth = Provider.of<AuthorizationProvider>(context, listen: false);
    final _user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(25, 5, 0, 10),
            child: Text(
              'Email or Username',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25),
            width: deviceSize.width * 0.9,
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email or Username',
                filled: true,
                fillColor: Colors.grey,
                labelStyle: TextStyle(color: Colors.white38),
              ),
              style: TextStyle(color: Colors.white),
              cursorColor: Theme.of(context).primaryColor,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 20, 0, 5),
            child: Text(
              'Password',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 25, top: 5, bottom: 20),
                width: deviceSize.width * 0.9,
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.grey,
                    labelStyle: TextStyle(color: Colors.white38),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white38,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_passwordVisible,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _validate
                  ? SizedBox(height: deviceSize.height * 0.01)
                  : Text('Invalid uername or password',
                      style: TextStyle(color: Colors.red)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25),
                width: deviceSize.width * 0.4,
                height: deviceSize.height * 0.065,
                child: RaisedButton(
                  textColor: Theme.of(context).accentColor,
                  color: Colors.grey,
                  child: Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  onPressed: () {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      setState(() {
                        _validate = false;
                      });
                    } else {
                      try {
                        _auth.signIn(
                            emailController.text, passwordController.text);

                        try {
                          _user.setUser(_auth.token);
                          //NAVIGATE TO HOME SCREEN

                        } catch (error) {
                          //LOST CONNECTION ERROR
                        }
                      } catch (error) {
                        setState(() {
                          _validate = false;
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15),
                width: deviceSize.width * 0.6,
                height: deviceSize.height * 0.05,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.transparent,
                  child: Text(
                    'Forgot Your Password?',
                    style: TextStyle(fontSize: 12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                    side: BorderSide(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, GetEmailScreen.routeName);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
