import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webmarket/Config/config.dart';
import 'package:webmarket/Address/address.dart';
import 'package:webmarket/Widgets/customAppBar.dart';
import 'package:webmarket/Widgets/loadingWidget.dart';
import 'package:webmarket/Models/item.dart';
import 'package:webmarket/Counters/cartitemcounter.dart';
import 'package:webmarket/Counters/totalMoney.dart';
import 'package:webmarket/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webmarket/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double totalAmount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context,listen: false).display(0);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed:(){
          if(EcommerceApp.sharedPreferences.getStringList(
              EcommerceApp.userCartList).length==1){
            Fluttertoast.showToast(msg: "your Cart is empty");
          }
          else {
            Route route = MaterialPageRoute(builder:(c)=> Address(totalAmount:totalAmount));
            Navigator.pushReplacement(context, route);
          }

        } ,
        label: Text("Checkout"),
        icon: Icon(Icons.navigate_next),
        backgroundColor: Colors.pinkAccent,

      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context,
                amountProvider,cartProvider,c){
              return Padding(padding: EdgeInsets.all(8),
              child: Center(
                child: cartProvider.count==0 ? Container(
                  
                ): Text("Total amount of money ${totalAmount.toString()} Dh",
                style: TextStyle(color:Colors.black,fontSize: 20,
                    fontWeight: FontWeight.w500 ),)
              ),);
            },)
          ),
          StreamBuilder<QuerySnapshot>(stream: EcommerceApp.firestore.
          collection("items").where("shortInfo",
              whereIn: EcommerceApp.sharedPreferences.
              getStringList(EcommerceApp.userCartList)).snapshots(),
          builder: (context ,snapshot){
            return !snapshot.hasData ? SliverToBoxAdapter(
              child:Center(child:
                circularProgress(),)
            ):snapshot.data.documents.length==0 ?
                beginbuilderCart() : SliverList(delegate:
            SliverChildBuilderDelegate(
                (context,index){
                  ItemModel model = ItemModel.fromJson(snapshot.data.
                  documents[index].data);
                  if(index==0){
                    totalAmount = 0;
                    totalAmount = model.price + totalAmount;

                  }
                  else {
                    totalAmount = model.price + totalAmount;
                  }
                  if(snapshot.data.documents.length - 1 == index)
                  {
                    WidgetsBinding.instance.addPostFrameCallback((t) {
                      Provider.of<TotalAmount>(context,listen: false).
                      display(totalAmount);
                    });
                  }
                 return sourceInfo(model, context,removeCartFunction:()=>
                 removeItemFromUserCart(model.shortInfo));
                },
              childCount: snapshot.hasData ? snapshot.data.documents.length :0,
            ),
            );
          },)
        ],
      ),
    );
  }
  beginbuilderCart()
  {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon,color: Colors.white,
              ),
              Text("your Card Is Empty"),
              Text("Star adding Items"),
            ],
          ),
        ),
      ),
    );
  }
  removeItemFromUserCart(String shortinfoAsID){
    List tempCartList = EcommerceApp.sharedPreferences.getStringList(
        EcommerceApp.userCartList);
    tempCartList.remove(shortinfoAsID);
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser).
    document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).
    updateData({
      EcommerceApp.userCartList : tempCartList
    }).then((v){
      Fluttertoast.showToast(msg: "Item removed , Successfully.");
      EcommerceApp.sharedPreferences.
      setStringList(EcommerceApp.userCartList,tempCartList);
      Provider.of<CartItemCounter>(context , listen: false).displayResult();
      totalAmount = 0;


    });
  }
}
