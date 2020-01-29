import"package:cloud_firestore/cloud_firestore.dart";

class CATDatabse{
  Firestore _firestore = Firestore.instance;
  Future<List<DocumentSnapshot>>getAllCAT()async{
    List<DocumentSnapshot> docs;
    QuerySnapshot _querySnapshot=await _firestore.collection("categories").orderBy("category").getDocuments();
    docs=_querySnapshot.documents;
    return docs;
  }

  Future<DocumentSnapshot>getCAT(String CATID)async{
    DocumentSnapshot CATsnapshot;
    CATsnapshot=await _firestore.collection("categories").document(CATID).get();
    return CATsnapshot;
  }
}