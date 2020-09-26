import 'dart:async';

import 'package:fasturista/src/models/CustomClipPath.dart';
import 'package:fasturista/src/models/PageAnimate.dart';
import 'package:fasturista/src/pages/map.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showLoading = false;

  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text('Regresar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  Widget _userEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        labelText: "Correo electrónico",
        helperText: "",
        prefixIcon: Icon(Icons.person),
      ),
      onChanged: (value) {
        setState(() {
          _userEmailController.text = value;
        });
      },
    );
  }

  Widget _userPassword() {
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        labelText: "Contraseña",
        helperText: "",
        prefixIcon: Icon(Icons.lock),
      ),
      onChanged: (value) {
        setState(() {
          _passwordController.text = value;
        });
      },
    );
  }

  Widget _buttonLogin() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ButtonTheme(
        height: 50.0,
        minWidth: 350.0,
        child: !_showLoading
            ? RaisedButton(
                textColor: Colors.white,
                color: Colors.green[400],
                child: Text("Ingresar",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _showLoading = !_showLoading;

                    final duration = new Duration(seconds: 2);
                    Timer(duration, () {
                      Navigator.push(
                          context,
                          PageAnimated(
                            page: MapTourist(
                                userEmail: this._userEmailController.text),
                          ).slideTransition());
                    });
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              )
            : CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: null,
      // onTap: () {
      //   Navigator.push(
      //       context, PageAnimated(page: SignUpPage()).slideRightTransition());
      // },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¿No tienes una cuenta?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Regístrate',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'fas',
          style: TextStyle(
            // textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            // color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'T',
              style: TextStyle(color: Colors.greenAccent, fontSize: 30),
            ),
            TextSpan(
              text: 'urista',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: [
        _userEmail(),
        _userPassword(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            Positioned(
              // top: -height * .15,
              // right: -MediaQuery.of(context).size.width * .3,
              // child: BezierContainer()),
              child: Container(
                child: ClipPath(
                  clipper: CustomClipPath(),
                  child: Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.green[200], Colors.green[500]],
                      // colors: [Color(0xfffbb448), Color(0xffe46b10)],
                    )),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _emailPasswordWidget(),
                    SizedBox(height: 20),
                    // _submitButton(),
                    _buttonLogin(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      alignment: Alignment.centerRight,
                      child: Text('¿Olvidó contraseña?',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                    ),
                    // _divider(),
                    // _facebookButton(),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
