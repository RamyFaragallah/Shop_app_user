import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_app/ShipmentDetails/ShipmentPage.dart';
import 'package:test_app/ShoppingCartComponnent/CartPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/db/CartDatabase.dart';
import 'package:test_app/db/FavouritesDatabase.dart';
import 'package:test_app/db/CATDatabase.dart';
import 'package:test_app/db/BrandDatabase.dart';
import 'package:test_app/Alerts/BuyNow.dart';

class ProductDetails extends StatefulWidget {
  final DocumentSnapshot _documentSnapshot;
  ProductDetails(this._documentSnapshot);
  @override
  _ProductDetailsState createState() => _ProductDetailsState(_documentSnapshot);
}

class _ProductDetailsState extends State<ProductDetails> {
  GlobalKey<ScaffoldState> newkey = new GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();

  FavouritesDatabase _favouritesDatabase = new FavouritesDatabase();
  CartDatabase _cartDatabase = new CartDatabase();
  CATDatabse _CATDatabase = new CATDatabse();
  BrandDatabase _BrandDatabase = new BrandDatabase();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  BuyNow _buyNowalert = new BuyNow();

  final DocumentSnapshot _documentSnapshot;
  _ProductDetailsState(this._documentSnapshot);
  String selectedsize;
  String selectedcolor;
  int selectedquantity = 1;
  bool saved = false;
  bool valid;
  String userid = '';
  @override
  void initState() {
    getUser().then((user) {
      if (user != null) {
        setState(() {
          userid = user.uid;
          _firestore
              .collection('saved')
              .document(_documentSnapshot.documentID)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                saved = true;
              });
            }
          });
        });
      } else {
        print("fool");
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: newkey,
      appBar: AppBar(
        title: Text(_documentSnapshot["name"]),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => CartPage(userid)));
              }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            color: Colors.transparent,
            child: GridTile(
              child: Container(
                child: Carousel(
                  images: [
                    Image.network(_documentSnapshot["images url"][0]),
                    Image.network(_documentSnapshot["images url"][1]),
                    Image.network(_documentSnapshot["images url"][2]),
                  ],
                  autoplay: false,
                  boxFit: BoxFit.cover,
                  dotBgColor: Colors.white.withOpacity(.5),
                  dotSize: 4,
                  indicatorBgPadding: .5,
                  showIndicator: false,
                ),
              ),
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    _documentSnapshot["name"],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _documentSnapshot["price"].toString() + "  L.E",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Description",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            subtitle: Text(_documentSnapshot["description"]),
          ),
          ListTile(
              title: Text(
                "Category",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: FutureBuilder<DocumentSnapshot>(
                future: _CATDatabase.getCAT(
                  _documentSnapshot["category"],
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(snapshot.data["category"]),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error please try later");
                  }
                  return Text("loading ....");
                },
              )),
          ListTile(
              title: Text(
                "Brand",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: FutureBuilder<DocumentSnapshot>(
                future: _BrandDatabase.getbrand(
                  _documentSnapshot["brand"],
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(snapshot.data["brand"]),
                      subtitle: Row(
                        children: <Widget>[
                          Container(
                              width: 100,
                              height: 100,
                              child: Image.network(snapshot.data["imgurl"])),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error please try later");
                  }
                  return Text("loading ....");
                },
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FutureBuilder<List<String>>(
                  future: getelementes("sizes"),
                  builder: (context, data) {
                    if (data.hasData) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 20.0),
                        child: DropdownButton<String>(
                          items: data.data
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: changsize,
                          value: selectedsize,
                          hint: Text("Size"),
                        ),
                      );
                    } else if (data.hasError) {
                      return Center(child: Text(data.error.toString()));
                    }
                    return Center(child: Text("loading ...."));
                  }),
              FutureBuilder<List<String>>(
                  future: getelementes("colors"),
                  builder: (context, data) {
                    if (data.hasData) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 20.0),
                        child: DropdownButton<String>(
                          items: data.data
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                "Color #${data.data.indexOf(value)}",
                                style: TextStyle(
                                    color: Color(int.parse(value)),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              value: value,
                            );
                          }).toList(),
                          onChanged: changcolor,
                          value: selectedcolor,
                          hint: Text("color"),
                        ),
                      );
                    } else if (data.hasError) {
                      return Center(child: Text(data.error.toString()));
                    }
                    return Center(child: Text("loading ...."));
                  }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: _decreaseqty,
                        ),
                        Text(selectedquantity.toString()),
                        IconButton(
                            icon: Icon(Icons.add), onPressed: _increaseqty),
                      ],
                    )),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _buynow();
                      },
                      child: Text("Order  Now"),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.red,
                  ),
                  onPressed: _addCart),
              IconButton(
                  icon: Icon(
                    saved ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: _save),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showsnacks() {
    newkey.currentState.showSnackBar(
      new SnackBar(
        content: Text("No action yet"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.teal[800],
      ),
    );
  }

  void changsize(value) {
    setState(() {
      selectedsize = value;
    });
  }

  void changcolor(value) {
    setState(() {
      selectedcolor = value;
    });
  }

  void _increaseqty() {
    if (selectedquantity < _documentSnapshot.data["quantuty"]) {
      setState(() {
        selectedquantity++;
      });
    } else {
      Fluttertoast.showToast(
          msg:
              "Maximum available quantity is ${_documentSnapshot.data["quantuty"]}");
    }
  }

  void _decreaseqty() {
    if (selectedquantity > 1) {
      setState(() {
        selectedquantity--;
      });
    } else {
      Fluttertoast.showToast(msg: "Minimum quantity is one");
    }
  }

  Future<List<String>> getelementes(String element) async {
    List<String> list = [];
    for (int i = 0; i < _documentSnapshot[element].length; i++) {
      list.add(_documentSnapshot[element][i]);
    }
    return list;
  }

  void _validate() {
    if (selectedcolor != null &&
        selectedsize != null &&
        selectedquantity <= _documentSnapshot.data["quantuty"]) {
      valid = true;
    } else if (selectedcolor == null) {
      valid = false;
      Fluttertoast.showToast(
          msg: "ERROR:  please select color", toastLength: Toast.LENGTH_LONG);
    } else if (selectedsize == null) {
      valid = false;
      Fluttertoast.showToast(
          msg: "ERROR:  please select size", toastLength: Toast.LENGTH_LONG);
    } else if (selectedquantity > _documentSnapshot.data["quantuty"]) {
      valid = false;
      Fluttertoast.showToast(
          msg: "ERROR:  the quantity is over the limits",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void _save() {
    setState(() {
      if (saved) {
        saved = false;
      } else {
        saved = true;
      }
    });

    _favouritesDatabase.saveProduct(saved, userid, _documentSnapshot);
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  void _addCart() {
    _validate();
    if (valid) {
      _cartDatabase.addtocart(
          color: selectedcolor,
          quantity: selectedquantity,
          size: selectedsize,
          uid: userid,
          documentSnapshot: _documentSnapshot);
      Fluttertoast.showToast(
          msg: "the product was added to the shopping cart",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void _buynow() {
    _validate();
    if (valid) {
      _buyNowalert.confirmsale(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShipmentPage(
                doc: _documentSnapshot,
                selectedcolor: selectedcolor,
                selectedquantity: selectedquantity,
                selectedsize: selectedsize,
                userid: userid)));
      }, context, _documentSnapshot["name"], selectedquantity, selectedcolor,
          selectedsize, _documentSnapshot["price"].toString());
    }
  }
}
