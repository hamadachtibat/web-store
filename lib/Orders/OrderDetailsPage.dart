import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webmarket/Address/address.dart';
import 'package:webmarket/Config/config.dart';
import 'package:webmarket/Store/storehome.dart';
import 'package:webmarket/Widgets/loadingWidget.dart';
import 'package:webmarket/Widgets/orderCard.dart';
import 'package:webmarket/Models/address.dart';
import 'package:webmarket/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId="";
class OrderDetails extends StatelessWidget {
  final String orderID;
  OrderDetails({Key key,this.orderID}):super(key: key);


  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences.
            getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).
            document(orderID).get(),

            builder: (c,snapshot){
              Map dataMap;
              if(snapshot.hasData)
              {
                dataMap = snapshot.data.data;

              }
              return snapshot.hasData ? Container(
                child: Column(
                  children: [
                    StatusBanner(status: dataMap[EcommerceApp.isSuccess],),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.all(4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(dataMap[EcommerceApp.totalAmount].toString() + "Dh",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                    ),),
                    Padding(padding: EdgeInsets.all(4),
                    child: Text("OrderID:"+ getOrderId),),
                    Padding(padding: EdgeInsets.all(4),
                      child: Text("Ordred-At:"+ DateFormat("dd MMMM ,yyyy-hh:mm aa").
                      format(
                          DateTime.fromMillisecondsSinceEpoch
                            (int.parse(dataMap["orderTime"]))),
                        style: TextStyle(color: Colors.grey,fontSize: 16.0),

                      ),
                      ),
                    Divider(height: 2,),
                    FutureBuilder<QuerySnapshot>(
                      future: EcommerceApp.firestore.collection("items").
                      where("shortInfo",
                          whereIn:dataMap[EcommerceApp.productID] ).
                      getDocuments(),
                      builder: (c,dasnapshot){
                        return dasnapshot.hasData ? OrderCard(
                          itemCount: dasnapshot.data.documents.length,
                          data: dasnapshot.data.documents,
                        ):Center(
                          child:circularProgress() ,);
                      },
                    ),
                    Divider(height: 2,),
                FutureBuilder<DocumentSnapshot>(
                  future: EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences.
                  getString(EcommerceApp.userUID)).
                  collection(EcommerceApp.subCollectionAddress).
                  document(dataMap[EcommerceApp.addressID]).get(),
                  builder: (c,snap){
                    return snapshot.hasData ? ShippingDetails(model:
                    AddressModel.fromJson(snap.data.data),):
                    Center(child: circularProgress(),);
                  },
                ),
                  ],
                ),
              ):
              Center(child: circularProgress(),);

            },
          ),
        ),
      ),
    );
  }
}



class StatusBanner extends StatelessWidget {

  final bool status;
  StatusBanner({Key key , this.status}):super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : Icons.cancel;
    status ? msg = "Successful" : msg= "UnSuccessful" ;


    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin:  const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0,1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              SystemNavigator.pop();

            },
            child: Container(
              child: Icon(
                Icons.arrow_circle_down,
                color: Colors.white,

              ),
            ),
          ),
          SizedBox(width: 20,),
          Text("Order Placed" + msg,style: TextStyle(
              color: Colors.white,
          ),
          ),
          SizedBox(width: 5,),
          CircleAvatar(
           radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,

              ),
            ),


          ),
        ],
      ),

    );
  }
}








class ShippingDetails extends StatelessWidget {

  final AddressModel model;

  ShippingDetails({Key key, this.model}):super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text("Shipment Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,

          ),
        ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90,vertical: 5),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(msg: "NAME",),
                  Text(model.name),

                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Phone Number",),
                  Text(model.phoneNumber),

                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "City",),
                  Text(model.city),

                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Your Address",),
                  Text(model.state),

                ],
              ),
            ],
          ),

        ),
        Padding(padding: EdgeInsets.all(10),
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
          width: screenWidth - 40.0,
          height: 50,

          child: Center(
            child: InkWell(
              onTap: (){
                confirmedUserOrderReceived(context,getOrderId);
              },
              child: Center(
                child: Text(
                  "Confirmed || Items Received",
                  style: TextStyle(
                    color: Colors.white,fontSize: 15,
                  ),
                ),
              ),

            ),
          ),
        ),),
      ],

    );
  }
  confirmedUserOrderReceived(BuildContext context,String mOrderId)
  {
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.
    getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).
    document(mOrderId).delete();

    getOrderId = "";
    Route route = MaterialPageRoute( builder: (c)=> SplashScreen());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: "Order Has Been Received .Successfully");


  }
}




