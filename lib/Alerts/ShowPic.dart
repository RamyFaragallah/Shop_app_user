import 'package:flutter/material.dart';

class ShowPic {
  Future<void> show(BuildContext context,String imgsrc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(height: 250,
              width: 50,
              child: imgsrc==null?CircleAvatar(
                child: Image.asset("images/pro.png"),
              ):CircleAvatar(
                child: Image.network(imgsrc),),
            ),
          ),
        );
      },
    );
  }
}
