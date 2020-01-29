import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class OrderstDatabase {
  Firestore _firestore = Firestore.instance;
  String dateAndtime;

  addOrder(
      String name,
      String phonnum,
      String address,
      String city,
      String uid,
      String color,
      int quantity,
      String size,
      DocumentSnapshot documentSnapshot) async {
    var id1 = Uuid().v1();
    _getTime();
   await _firestore
        .collection("orders")
        .document(id1)
        .setData(documentSnapshot.data);
    await _firestore
        .collection("orders")
        .document(id1)
        .updateData({
      "userid":uid,
      "sizes": size,
      "colors": color,
      "quantuty": quantity,
      "username": name,
      "Phonenumber": phonnum,
      "home address": address,
      "city": city,
      "shipped": null,
      "ordered": dateAndtime,
      "delivered": null
    });
  }

  cartorder(
      String name, String phonnum, String address, String city, String uid,List<DocumentSnapshot> list) {
    list.forEach((item)async{
      var id1 = Uuid().v1();
      _getTime();
     await _firestore
          .collection("orders")
          .document(id1)
          .setData(item.data);
      await _firestore
          .collection("orders")
          .document(id1)
          .updateData({
        "userid":uid,
        "username": name,
        "Phonenumber": phonnum,
        "home address": address,
        "city": city,
        "shipped": null,
        "ordered": dateAndtime,
        "delivered": null
      });

      await _firestore.collection("cart").document(item.documentID).delete();
    });
  }
  Future<List<DocumentSnapshot>> getallorders(
      String uid, String orderCase) async {
    List<DocumentSnapshot> orders = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('orders').where("userid",isEqualTo: uid)
        .getDocuments();
    orders = querySnapshot.documents;
    switch (orderCase) {
      case "ordered":
        {
          List<DocumentSnapshot> orderedlist = [];
          orders.forEach((doc) {
            if (doc.data["ordered"] != null &&
                doc.data["shipped"] == null &&
                doc.data["canceled"] == null &&
                doc.data["delivered"] == null) {
              orderedlist.add(doc);
            }
          });
          return orderedlist;
        }
        break;
      case "shipped":
        {
          List<DocumentSnapshot> shippedlist = [];
          orders.forEach((doc) {
            if (doc.data["shipped"] != null && doc.data["delivered"] == null) {
              shippedlist.add(doc);
            }
          });
          return shippedlist;
        }
        break;
      case "delivered":
        {
          List<DocumentSnapshot> deliveredlist = [];
          orders.forEach((doc) {
            if (doc.data["delivered"] != null) {
              deliveredlist.add(doc);
            }
          });
          return deliveredlist;
        }
        break;
      case "canceled":
        {
          List<DocumentSnapshot> canceledlist = [];
          orders.forEach((doc) {
            if (doc.data["canceled"] != null) {
              canceledlist.add(doc);
            }
          });
          return canceledlist;
        }
        break;
    }
    return [];
  }

  void deleteOneOrder(String id) async {
    await _firestore
        .collection('orders')
        .document(id)
        .delete();
  }

  void deleteproducts(List<String> products) async {
    List<String> alternative = [];
    for (String id in products) {
      alternative.add(id);
    }
    alternative.forEach((value) async {
      await _firestore
          .collection('orders')
          .document(value)
          .delete();
    });
  }

  void cancelOrder(String orderID) async {
    _getTime();
    await _firestore
        .collection("orders")
        .document(orderID)
        .updateData({ "canceled": dateAndtime});
  }

  void _getTime() {
    DateTime now = DateTime.now();
    dateAndtime = DateFormat('EEE d MMM').format(now);
  }
}
