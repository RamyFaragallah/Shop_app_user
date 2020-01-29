import 'package:flutter/material.dart';

class BuyNow {
  Future<void> confirmsale(Function function, BuildContext context,String Pname,int pqty,String pcolor,String psize,String pcprice) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm sale'),
          content: SingleChildScrollView(
              child: CartSingleProduct(
                  Pname,
                  pcprice,
                  psize,
                  pcolor,
                  pqty,
                  function)),
        );
      },
    );
  }
}

class CartSingleProduct extends StatelessWidget {
  final Pname, pqty, pcolor, psize, pcprice;
  Function func;
  CartSingleProduct(this.Pname, this.pcprice, this.psize,
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
            ],
          ),
          subtitle: Column(
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
                          fontSize: 15,),
                    )),
                  ],
                ),
              ), Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "Total:   ${int.parse(pcprice)*pqty}  L.E",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                      color: Colors.red[500]),
                    )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                        color: Colors.red,
                        child: Text(
                          'Buy now',
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                        onPressed: func),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
