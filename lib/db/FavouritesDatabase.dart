
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesDatabase{
  Firestore _firestore=Firestore.instance;

  void saveProduct(bool saved,String uid,DocumentSnapshot documentSnapshot){

    switch(saved){
      case false:{
        deletesaved(documentSnapshot.documentID,uid);
      }
      break;
      case true :{
         _firestore.collection('saved').document(documentSnapshot.documentID).setData(documentSnapshot.data);
         _firestore.collection('saved').document(documentSnapshot.documentID).updateData({"userid":uid});

      }
      break;
    }
  }
  Future<List<DocumentSnapshot>> getallsaved(String uid)async{
    List<DocumentSnapshot> savedlist=[];
    QuerySnapshot querySnapshot=await _firestore.collection('saved').where("userid",isEqualTo: uid).getDocuments();
    savedlist=querySnapshot.documents;
    return savedlist;
  }
  void deletesaved(String id,String uid)async{
    await  _firestore.collection('saved').document(id).delete();
  }
  void deleteproducts(List<String> products,String uid) async {
    List<String> alternative=[];
    for (String id in products) {
      alternative.add(id);
    }
    alternative.forEach((value)async{
      await _firestore.collection('saved')
          .document(value)
          .delete();
    });
  }}