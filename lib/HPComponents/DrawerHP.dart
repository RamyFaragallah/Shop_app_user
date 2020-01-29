import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/Alerts/ShowPic.dart';
import 'package:test_app/FavouritesPage/FavouritesPage.dart';
import 'package:test_app/LoginComponents/LoginPage.dart';
import'package:test_app/Orders/OrdersPage.dart';


class DrawerHP extends StatefulWidget {
  String _uid;
  VoidCallback _showsnacks;
  DrawerHP(String uid,VoidCallback showsnacks){
    this._uid=uid;
    this._showsnacks=showsnacks;
  }

  @override
  _DrawerHPState createState() => _DrawerHPState(_uid,_showsnacks);
}

class _DrawerHPState extends State<DrawerHP> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
   String name,photourl,email;
   ShowPic _showPic=new ShowPic();

String _uid;
  VoidCallback _showsnacks;
  _DrawerHPState(
      String uid,VoidCallback showsnacks
      ){this._uid=uid;
  this._showsnacks=showsnacks;}

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        Firestore.instance
            .collection('users')
            .document('${user.uid}')
            .get()
            .then((DocumentSnapshot ds) {
          if(ds.exists){
            setState(() {
              name=ds.data["username"];
              email=ds.data["email"];
              photourl=ds.data["photourl"];
            });
          }
        });
        // homePage();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:name!=null?Text("$name"):Text("User name"),
              accountEmail: email==null?Text("email isn't available"):Text(email),
              decoration:
                  BoxDecoration(color: Colors.red[200].withOpacity(.5)),
              currentAccountPicture: InkWell(onTap: ()async{
                await _showPic.show(context,photourl);
              },
                child: photourl==null?CircleAvatar(
                  child: Image.asset("images/pro.png"),
                ):CircleAvatar(
                  child: Image.network(photourl),),
              )
            ),

            draweritem("My Orders", Icons.add_shopping_cart, () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrdersPage(uid:  _uid,)));
            }, Colors.red),
            draweritem("Favourites", Icons.favorite, () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>FavouritePage(uid: _uid,)));
            }, Colors.red),
            Divider(),
            draweritem("Settings", Icons.settings, () {
              _showsnacks();
              Navigator.of(context).pop();
            }, Colors.grey),
            draweritem("About", Icons.help, () {
              _showsnacks();
              Navigator.of(context).pop();
            }, Colors.blue),
            draweritem("Log out", Icons.exit_to_app, () async{

              auth.signOut();
              _showsnacks();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
            }, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget draweritem(
      String title, IconData icon, VoidCallback func, MaterialColor color) {
    return InkWell(
      onTap: func,
      child: ListTile(
        title: Text(title),
        leading: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
  Future<FirebaseUser> getUser() async {
    return await auth.currentUser();
  }

}
