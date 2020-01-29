import 'package:cloud_firestore/cloud_firestore.dart';

class BrandDatabase{
Firestore _firestore=Firestore.instance;
  Future<DocumentSnapshot>getbrand(String brandID)async{
    DocumentSnapshot brandsnapshot;
    brandsnapshot=await _firestore.collection("brands").document(brandID).get();
    return brandsnapshot;
  }
}