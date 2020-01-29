import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDatabase {
 Firestore _firestore=Firestore.instance;
 Future<List<DocumentSnapshot>> getallProducts()async{
   List<DocumentSnapshot> _list;
  QuerySnapshot _querySnapshot =await _firestore.collection("products").getDocuments();
  _list=_querySnapshot.documents;
  return _list;
 }


Future<List<DocumentSnapshot>> CATProducts(String CATID)async{
  List<DocumentSnapshot> _list;
  QuerySnapshot _querySnapshot =await _firestore.collection("products").where("category",isEqualTo:CATID ).getDocuments();
  _list=_querySnapshot.documents;
  return _list;
}

 Future<List<DocumentSnapshot>> getallproducts(
     String CAT) async {
   List<DocumentSnapshot> documentSnapshot;

   if ((CAT != null && CAT != "All")) {
     if (CAT != "All" ) {
       QuerySnapshot querytSnapshot = await Firestore.instance
           .collection("products")
           .where("category", isEqualTo: CAT)
           .getDocuments();
       documentSnapshot = querytSnapshot.documents;
     } else if (CAT == "All") {
       QuerySnapshot querytSnapshot = await Firestore.instance
           .collection("products")
           .getDocuments();
       documentSnapshot = querytSnapshot.documents;
     }
   } else {
     QuerySnapshot querytSnapshot =
     await Firestore.instance.collection("products").getDocuments();
     documentSnapshot = querytSnapshot.documents;
   }
   return documentSnapshot;
 }
 Future<List<DocumentSnapshot>> getSuggestions(
     String pattern) async {
   List<DocumentSnapshot> documentSnapshot;
   List<DocumentSnapshot> finalresult=[];
   QuerySnapshot querytSnapshot =
   await _firestore.collection("products").getDocuments();
   documentSnapshot = querytSnapshot.documents;
   documentSnapshot.forEach((value){
     if(value.data["name"].toString().startsWith(pattern)){
       finalresult.add(value);

     }
   });

   return finalresult;
 }



}