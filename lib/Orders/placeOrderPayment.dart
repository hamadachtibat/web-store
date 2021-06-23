import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_market/Config/config.dart';
import 'package:web_market/Store/storehome.dart';
import 'package:web_market/Counters/cartitemcounter.dart';
import 'package:web_market/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {

  final String addressId;
  final double totalAmount;
  PaymentPage({Key key , this.addressId,this.totalAmount}):super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin:  const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(8),
              child: Image.asset("images/cash.png"),),
              SizedBox(height: 10,),
              FlatButton(
                color: Colors.pinkAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(8),
                splashColor: Colors.deepOrange,
                onPressed: ()=> {sendEmail(),addOrderDetails(),},
                child: Text("Place Order",style: TextStyle(
                  fontSize: 30,

                ),),


              ),

            ],
          ),
        ),


      ),
    );
  }

  addOrderDetails(){
    writeOrderDetailsForUser({
      EcommerceApp.addressID:widget.addressId,
      EcommerceApp.totalAmount:widget.totalAmount,
      "orderBy":EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences.
      getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails:"cash on delivery",
      EcommerceApp.orderTime:DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess:true,
    });

   writeOrderDetailsForAdmin({
     EcommerceApp.addressID:widget.addressId,
     EcommerceApp.totalAmount:widget.totalAmount,
     "orderBy":EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
     EcommerceApp.productID: EcommerceApp.sharedPreferences.
     getStringList(EcommerceApp.userCartList),
     EcommerceApp.paymentDetails:"cash on delivery",
     EcommerceApp.orderTime:DateTime.now().millisecondsSinceEpoch.toString(),
     EcommerceApp.isSuccess:true,

   }).whenComplete(() => {
     emptyCartNow()
   });

  }


  emptyCartNow(){

    EcommerceApp.sharedPreferences.
    setStringList(EcommerceApp.userCartList ,["carbageValue"]);
    List tempList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);


    Firestore.instance.collection("users").document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)
    ).updateData({

      EcommerceApp.userCartList : tempList,

    }).then((value){
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context,listen: false).displayResult();
    });
 Fluttertoast.showToast(msg: "Congratulation Your Order is Placed Successfully.");
    Route route = MaterialPageRoute(builder:(c)=> SplashScreen());
    Navigator.pushReplacement(context, route);

  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.
    sharedPreferences.getString(EcommerceApp.userUID)).
    collection(EcommerceApp.collectionOrders).document(EcommerceApp.
    sharedPreferences.getString(EcommerceApp.userUID) + data['orderTime']).
    setData(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async
  {
    await EcommerceApp.firestore.
    collection(EcommerceApp.collectionOrders).document(EcommerceApp.
    sharedPreferences.getString(EcommerceApp.userUID) + data['orderTime']).
    setData(data);
  }
  sendEmail()async{
    String username = 'hamada.achtibat@gmail.com';
    String password = 'maradonajiraya';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Ahmed')
      ..recipients.add('achtibat.ahmed@gmail.com')
      ..subject = 'You Have a new Order :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1> WEB STORE || NEW ORDER ADMIN </h1>\n"
          "<p> CHECK YOUR APP ADMIN</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

}