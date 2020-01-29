import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_app/db/OrdersDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/Alerts/ConfirmSale.dart';
import'package:test_app/HPComponents/HomePage.dart';


class ShipmentPage extends StatefulWidget {
  DocumentSnapshot _documentSnapshot;
  String selectedsize;
  String selectedcolor;
  int selectedquantity;
  String userid = '';
  List<DocumentSnapshot> list;
  ShipmentPage({DocumentSnapshot doc, String selectedsize, String selectedcolor,
  int selectedquantity,String userid,List<DocumentSnapshot> list}) {
    this._documentSnapshot = doc;
    this.selectedsize = selectedsize;
    this.selectedcolor = selectedcolor;
    this.selectedquantity = selectedquantity;
    this.userid = userid;
    this.list = list;

  }

  @override
  _ShipmentPageState createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  final formkey = new GlobalKey<FormState>();
  OrderstDatabase _orderstDatabase = new OrderstDatabase();
  ConfirmSale _confirmSale = new ConfirmSale();
  bool valid = false;
  String username;
  String phonenum;
  String homeaddress;
  String city;
  String selectedsize;
  String selectedcolor;
  int selectedquantity;
  String userid = '';

  String dateAndtime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shipment Datails"),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: username,
                          decoration: InputDecoration(hintText: "Your name"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Name required";
                            } else {
                              username = value;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(hintText: "Your phone number"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "phone number required";
                            } else if (value.length < 11) {
                              return "phone number must be 11 digits";
                            } else {
                              phonenum = value;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration:
                              InputDecoration(hintText: "Your home address"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return " home address required";
                            } else {
                              homeaddress = value;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Your City"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return " city required";
                            } else {
                              city = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _valid();
                  if (valid) {
                    _confirmSale.confirmsale(() {
                      if(widget._documentSnapshot!=null){
                        _orderstDatabase.addOrder(
                          username,
                          phonenum,
                          homeaddress,
                          city,
                          widget.userid,
                          widget.selectedcolor,
                          widget.selectedquantity,
                          widget.selectedsize, widget._documentSnapshot,
                        );
                      }
                      else if(widget.list!=null){
                        _orderstDatabase.cartorder(username, phonenum, homeaddress, city, widget.userid, widget.list);
                      }

                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()),(Route<dynamic> route) => false);
                      Fluttertoast.showToast(msg: "The order is confimed ");
                    }, context, "Do you want to confirm buying this product");
                  }
                },
                child: Text("Confirm"),
                color: Colors.red,
                textColor: Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }

  void _valid() {
    if (formkey.currentState.validate()) {
      setState(() {
        valid = true;
      });
    }
  }

}
