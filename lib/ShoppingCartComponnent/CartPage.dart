import 'package:cloud_firestore/cloud_firestore.dart';
import"package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_app/HPComponents/HomePage.dart';
import 'package:test_app/ShipmentDetails/ShipmentPage.dart';
import 'package:test_app/db/CartDatabase.dart';
import 'CartProducts.dart';
import 'package:test_app/Alerts/ConfirmSale.dart';

class CartPage extends StatefulWidget {
  String uid;
  CartPage(String userid){this.uid=userid;}
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartDatabase _cartDatabase=new CartDatabase();
  ConfirmSale _confirmSale=new ConfirmSale();
  double total=0;
  List<DocumentSnapshot>_list;
  @override
  void initState() {
    _cartDatabase.getallcart(widget.uid) .then((list){
      setState(() {
        _list=list;
      });
    });    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
        leading:IconButton(icon:  Icon(Icons.arrow_back), onPressed: (){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()),(Route<dynamic> route) => false);}),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(child:  Text("Total :  ",style: TextStyle(
            fontSize: 15,fontWeight: FontWeight.bold
        ),),),
            Expanded(child:FutureBuilder<double>(future: _cartDatabase.getcarttoatal(widget.uid),
              builder:(context,snapshot){
              _cartDatabase.getcarttoatal(widget.uid).then((value){
              });

              if(snapshot.hasData){
                  total=snapshot.data;
                return Text(snapshot.data.toString()+"  L.E",style: TextStyle(fontSize: 15,color: Colors.red[800],fontWeight: FontWeight.bold),);
              }
              else if(snapshot.hasError){

                Fluttertoast.showToast(msg: "error in getting total");
                return Text("Error");
              }
              return Text("0  L.E",style: TextStyle(fontSize: 15,color: Colors.red[800],fontWeight: FontWeight.bold),);

            },),)
          , MaterialButton(onPressed: (){
            print(total);
              _buynow();
            },
              child:
              Text("Check out"),
              color: Colors.red,
              textColor: Colors.white,)],
        ),
      ),
      body: CartProducts(widget.uid),
    );
  }

  void _buynow() {
    if (total>0) {
      _confirmSale.confirmsale(()async{  Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShipmentPage(userid:widget.uid ,list: _list,)));
      }, context, "Do you want to order all this products");

    } else {
      Fluttertoast.showToast(
          msg: "Shopping cart is empty",
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
