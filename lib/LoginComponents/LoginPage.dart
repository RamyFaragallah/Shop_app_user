import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_app/HPComponents/HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FORMTYPE { login, register }

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool loading = false;
  bool islogged = false;
  SharedPreferences sharedPreferences;
  GlobalKey<ScaffoldState> newkey = new GlobalKey<ScaffoldState>();
  Future<void> showsnacks(String txt) {
    newkey.currentState.showSnackBar(
        new SnackBar(content: Text(txt), duration: Duration(seconds: 3)));
  }

  final formkey = new GlobalKey<FormState>();
  FORMTYPE formtype;
  String _E_MAIL = "";
  String _NAME = "";
  String PASS = "";

  AnimationController _AnimController;
  Animation<double> _animation;

  movetoregister() {
    formkey.currentState.reset();
    setState(() {
      formtype = FORMTYPE.register;
    });
  }

  movetologin() {
    formkey.currentState.reset();
    setState(() {
      formtype = FORMTYPE.login;
    });
  }

  Future<void> login() async {
    print(formkey.currentState.toString());
    final formstate = formkey.currentState;
    if (formstate.validate()) {
      formstate.save();
      try {
        sharedPreferences = await SharedPreferences.getInstance();
        setState(() {
          loading = true;
        });
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _E_MAIL, password: PASS))
            .user;
        if (user != null) {
          Firestore.instance
              .collection('users')
              .document('${user.uid}')
              .get()
              .then((DocumentSnapshot ds) {
            if(!ds.exists){
//            name=ds.data["username"];
              Firestore.instance.collection("users").document(user.uid).setData({
                "id": user.uid,
                "photourl": user.photoUrl,
                "email":user.email,
                "username":user.displayName
              });
               sharedPreferences.setString("id", user.uid);
               sharedPreferences.setString("username", user.displayName);
               sharedPreferences.setString("photourl", user.photoUrl);
            }
            else {
               sharedPreferences.setString("id", ds["id"]);
               sharedPreferences.setString(
                  "username", ds["username"]);
               sharedPreferences.setString(
                  "photourl", ds["photourl"]);
            }
          });


          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage(

                      )));
          setState(() {
            loading = false;
          });

        }
      } catch (PlatformException) {
        Fluttertoast.showToast( msg: PlatformException.toString().contains("ERROR_USER_NOT_FOUND")
            ? "ERROR_USER_NOT_FOUND"
            : PlatformException.toString());
        setState(() {
          loading = false;
        });
      }
    }
  }

  register() async {
    final formstate = formkey.currentState;
    if (formstate.validate()) {
      formstate.save();
      try {
        sharedPreferences = await SharedPreferences.getInstance();
        setState(() {
          loading = true;
        });
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: _E_MAIL, password: PASS))
            .user;
        if (user != null) {
          Firestore.instance
              .collection('users')
              .document('${user.uid}')
              .get()
              .then((DocumentSnapshot ds) {
            if (!ds.exists) {
//            name=ds.data["username"];
              Firestore.instance.collection("users").document(user.uid).setData(
                  {
                    "id": user.uid,
                    "username": _NAME,
                    "photourl": user.photoUrl,
                    "email": user.email,
                  });
              sharedPreferences.setString("id", user.uid);
              sharedPreferences.setString("username", user.displayName);
              sharedPreferences.setString("photourl", user.photoUrl);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MyHomePage(

                          )));
              setState(() {
                loading = false;
              });
            }
            else {
              Fluttertoast.showToast(
                  msg: "You already have account enter email and password to sign in");
//              sharedPreferences.setString("id", ds["id"]);
//              sharedPreferences.setString(
//                  "username", ds["username"]);
//              sharedPreferences.setString(
//                  "photourl", ds["photourl"]);
            }
          });
        }
      } catch (PlatformException) {
        Fluttertoast.showToast(msg: PlatformException.toString(),toastLength: Toast.LENGTH_LONG);
        setState(() {
          loading=false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    issigned();
    formtype = FORMTYPE.login;
    _AnimController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 6000));
    _animation =
        new CurvedAnimation(parent: _AnimController, curve: Curves.bounceOut);
    _animation.addListener(() => this.setState(() {}));
    _AnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: newkey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("images/bg.jpg"),
            fit: BoxFit.cover,
            color: Colors.grey[500],
            colorBlendMode: BlendMode.darken,
          ),
          SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              SizedBox(
                height: 30,
              ),
                FadeTransition(
                  child: Image(
                    image: AssetImage("images/logo.png"),
                    height: 100,
                    width: 100,
                  ),
                  opacity: _animation,
                ),
                Form(
                    key: formkey,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        children: <Widget>[
                          Visibility(
                            child: TextFormField(
                              validator: (value) {
                                return value.isEmpty
                                    ? "Please enter your name"
                                    : null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  _NAME = val;

                                });
                              },
                              decoration: new InputDecoration(
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.yellowAccent),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                errorStyle: TextStyle(
                                    color: Colors.yellowAccent,
                                    fontWeight: FontWeight.bold),
                                filled: true,
                                fillColor: Colors.black.withOpacity(.5),
                                labelText: "Name",
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.white),
                            ),
                            visible: formtype == FORMTYPE.register,
                          ),
                          new Container(
                            height: 20.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              return value.isEmpty
                                  ? "Please enter your email"
                                  : null;
                            },
                            onSaved: (val) {
                              _E_MAIL = val;
                            },
                            decoration: new InputDecoration(
                              errorBorder:  OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.yellowAccent),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.black.withOpacity(.5),
                              labelText: "Email",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.white)),
                              labelStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                          ),
                          new Container(
                            height: 20.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              return value.isEmpty
                                  ? "Please enter your password"
                                  : null;
                            },
                            onSaved: (val) {
                              PASS = val;
                            },
                            decoration: new InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.yellowAccent),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.black.withOpacity(.5),
                              labelText: "password",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                          ),
                        ],
                      ),
                    )),
                _custombuttons(),
              ],
            ),
          ),
          Visibility(
            child: Center(
                child: Container(
                    alignment: Alignment.center,
                    color: Colors.red.withOpacity(.8),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ))),
            visible: loading ?? true,
          )
        ],
      ),
    );
  }

  void issigned() async {
    setState(() {
      loading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    islogged = await googleSignIn.isSignedIn();
    if (islogged) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage(

                  )));
    }
    setState(() {
      loading = false;
    });
  }

  Future handlesigning() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });
    try{

      GoogleSignInAccount googleaccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleautha = await googleaccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleautha.accessToken,
        idToken: googleautha.idToken,
      );
      final FirebaseUser user =
          (await auth.signInWithCredential(credential)).user;
      if (user != null) {

        Firestore.instance
            .collection('users')
            .document('${user.uid}')
            .get()
            .then((DocumentSnapshot ds) {
          if(!ds.exists){
//            name=ds.data["username"];
            Firestore.instance.collection("users").document(user.uid).setData({
              "id": user.uid,
              "photourl": user.photoUrl,
              "email":user.email,
              "username":user.displayName
            });
            sharedPreferences.setString("id", user.uid);
            sharedPreferences.setString("username", user.displayName);
            sharedPreferences.setString("photourl", user.photoUrl);
          }
          else {
            sharedPreferences.setString("id", ds["id"]);
            sharedPreferences.setString(
                "username", ds["username"]);
            sharedPreferences.setString(
                "photourl", ds["photourl"]);
          }
        });


        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(
                )));
        setState(() {
          loading = false;
        });

      } else {
        Fluttertoast.showToast(msg: "Login failed");
        setState(() {
          loading = false;

        });
      }
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
      setState(() {
        loading=false;
      });
    }
  }

  Widget _custombuttons() {
    if (formtype == FORMTYPE.login) {
      return Column(
        children: <Widget>[
          Container(
            width: 240,
            child: RaisedButton(
              onPressed: () {
                login();
              },
              child: Text("Login"),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(left: 50, right: 50),
            ),
          ),
          Container(
            width: 240,
            child: RaisedButton(
              onPressed: () {
                handlesigning();
              },
              child: Text("Sign in with google "),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(left: 50, right: 50),
              textColor: Colors.white,
              color: Colors.red,
            ),
          ),
          FlatButton(
            onPressed: () {
              movetoregister();
            },
            child: Text(
              "Create new account",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            width: 240,
            child: RaisedButton(
              onPressed: () {
                register();
              },
              child: Text("Create account"),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(left: 50, right: 50),
            ),
          ),
          Container(
            width: 240,
            child: RaisedButton(
              onPressed: () {

                handlesigning();
              },

              child: Text("Sign in with google "),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(left: 50, right: 50),
              textColor: Colors.white,
              color: Colors.red,
            ),
          ),
          FlatButton(
            onPressed: () {
              movetologin();
            },
            child: Text(
              "back to login",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    }
  }

  @override
  void dispose() {
    _AnimController.dispose();
    super.dispose();

  }
}
