import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/db/CartDatabase.dart';
import"package:test_app/Alerts/Alert.dart";

import 'CartPage.dart';

class CartProducts extends StatefulWidget {
  String uid;
  CartProducts(String userid) {
    this.uid = userid;
  }
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  @override
  Widget build(BuildContext context) {
    CartDatabase _cartDatabase = new CartDatabase();
    Alert _deletealert=new Alert();
    return FutureBuilder<List<DocumentSnapshot>>(
        future: _cartDatabase.getallcart(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.isNotEmpty){
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return CartSingleProduct(
                      snapshot.data[index]["name"],
                      snapshot.data[index]["images url"][0],
                      snapshot.data[index]["price"],
                      snapshot.data[index]["sizes"],
                      snapshot.data[index]["colors"],
                      snapshot.data[index]["quantuty"], () {
                    _deletealert.confirm((){setState(() {
                      print(                      snapshot.data[index]["colors"],
                      );
                      _cartDatabase.deletefromcart(
                          snapshot.data[index].documentID, widget.uid);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>CartPage(widget.uid)),(Route<dynamic> route) => false,);
                      
                    });}, context, "Do you want to delete ${snapshot.data[index]["name"]} from the cart","Warnning","Cancel","Delete");

                  });
                });}          else {
              return Center(child:Text("The shopping Cart is empty "));
            }
          }else if(snapshot.hasError){
            print(snapshot.error.toString());
            return Center(child: Text(snapshot.error.toString()),);
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}

class CartSingleProduct extends StatelessWidget {
  final Pname, PImag, pqty, pcolor, psize, pcprice;
  Function func;
  CartSingleProduct(this.Pname, this.PImag, this.pcprice, this.psize,
      this.pcolor, this.pqty, this.func);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          onTap: () {},
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(Pname, style: TextStyle(fontWeight: FontWeight.bold)),
              InkWell(
                onTap: func,
                child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 15,
                    ))),
              )
            ],
          ),
          leading: Container(width: 60, child: Image.network(PImag)),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Text("Color:  ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 40,
                        height: 15,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(int.parse(pcolor))),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        "Size:  " + psize.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("Quantity :  " + pqty.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        "Price:   " + pcprice.toString() + "  L.E",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.red),
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
