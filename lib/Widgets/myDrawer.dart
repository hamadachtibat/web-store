import 'package:webmarket/Authentication/authenication.dart';
import 'package:webmarket/Config/config.dart';
import 'package:webmarket/Address/addAddress.dart';
import 'package:webmarket/Store/Search.dart';
import 'package:webmarket/Store/cart.dart';
import 'package:webmarket/Orders/myOrders.dart';
import 'package:webmarket/Store/storehome.dart';
import 'package:webmarket/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
       children: [
         Container(
           padding: EdgeInsets.only(top: 25,bottom:10 ),
           decoration: new BoxDecoration(
             gradient: new LinearGradient(
               colors: [Colors.pink , Colors.greenAccent],
               begin:  const FractionalOffset(0.0, 0.0),
               end: const FractionalOffset(1.0, 0.0),
               stops: [0.0,1.0],
               tileMode: TileMode.clamp,
             ),
           ),
           child: Column(
             children: [
               Material(
                 borderRadius: BorderRadius.all(Radius.circular(80)),
                 elevation: 8.0,
                 child: Container(
                   height: 160,
                   width: 160,
                   child: CircleAvatar(
                     backgroundImage: NetworkImage(
                         EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl)),
                   ),
                 ),

               ),
               SizedBox(height: 10,),
               Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                 style: TextStyle(color: Colors.white,fontSize: 35,fontFamily:"signatra"),),
             ],
           ),
         ),
         SizedBox(height: 12,),
         Container(
           padding: EdgeInsets.only(top: 1),
           decoration: new BoxDecoration(
             gradient: new LinearGradient(
               colors: [Colors.pink , Colors.greenAccent],
               begin:  const FractionalOffset(0.0, 0.0),
               end: const FractionalOffset(1.0, 0.0),
               stops: [0.0,1.0],
               tileMode: TileMode.clamp,
             ),
           ),
           child: Column(
           children: [
             ListTile(
               leading: Icon(Icons.home,color: Colors.white,),
               title: Text("Home",style: TextStyle(color: Colors.white),),
               onTap: (){
                 Route route = MaterialPageRoute(builder:(c)=> StoreHome());
                 Navigator.pushReplacement(context, route);
               },

             ),
             Divider(height: 10,color: Colors.white,thickness: 6,),

             ListTile(
               leading: Icon(Icons.reorder,color: Colors.white,),
               title: Text("My Orders",style: TextStyle(color: Colors.white),),
               onTap: (){
                 Route route = MaterialPageRoute(builder:(c)=>MyOrders());
                 Navigator.pushReplacement(context, route);
               },

             ),
             Divider(height: 10,color: Colors.white,thickness: 6,),
             ListTile(
               leading: Icon(Icons.shopping_cart_sharp,color: Colors.white,),
               title: Text("My Cart",style: TextStyle(color: Colors.white),),
               onTap: (){
                 Route route = MaterialPageRoute(builder:(c)=>CartPage());
                 Navigator.pushReplacement(context, route);
               },

             ),
             Divider(height: 10,color: Colors.white,thickness: 6,),
             ListTile(
               leading: Icon(Icons.search,color: Colors.white,),
               title: Text("Search",style: TextStyle(color: Colors.white),),
               onTap: (){
                 Route route = MaterialPageRoute(builder:(c)=>SearchProduct());
                 Navigator.pushReplacement(context, route);
               },

             ),
             Divider(height: 10,color: Colors.white,thickness: 6,),
             ListTile(
               leading: Icon(Icons.location_on,color: Colors.white,),
               title: Text("Add New Address",style: TextStyle(color: Colors.white),),
               onTap: (){
                 Route route = MaterialPageRoute(builder:(c)=>AddAddress());
                 Navigator.pushReplacement(context, route);
               },

             ),
             Divider(height: 10,color: Colors.white,thickness: 6,),
             ListTile(
               leading: Icon(Icons.exit_to_app,color: Colors.white,),
               title: Text("Logout",style: TextStyle(color: Colors.white),),
               onTap: (){
                 EcommerceApp.auth.signOut().then((value){
                   Route route = MaterialPageRoute(builder:(c)=>AuthenticScreen());
                   Navigator.pushReplacement(context, route);
                 });
               },
             ),
             Divider(height: 10,color: Colors.white,thickness: 6,),

           ],
           ),
         ),
       ],

      ),
    );
  }
}
