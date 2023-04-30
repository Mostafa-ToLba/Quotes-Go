
 import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class notificationScreen extends StatefulWidget {
   const notificationScreen({Key? key}) : super(key: key);

   @override
   _notificationScreenState createState() => _notificationScreenState();
 }

 class _notificationScreenState extends State<notificationScreen> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         titleSpacing: 0,
         title: Text('Notifications',style: TextStyle(color:Colors.white,fontSize: 20.sp,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',),),
       ),
       body:Padding(
         padding:  EdgeInsets.all(10.sp),
         child: ListView.separated(
             itemBuilder: (BuildContext, index)=>NotificationItem(),
             separatorBuilder: (BuildContext, index)=>Container(height: 2.h),
             itemCount: 10),
       ),
     );
   }
 }

 NotificationItem()=>Container(
   height: 18.h,
   width: double.infinity,
   decoration: BoxDecoration(
       border: Border.all(
         color: Colors.black,
         width: .5.sp,
       ),
       color:Colors.blue,borderRadius: BorderRadius.circular(5.sp)),
   child: Column(
     children:
     [
       Padding(
         padding:  EdgeInsets.all(8.sp),
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children:
           [
             Column(
               children: [
                 Text('Exclusive on Quotes Go!',style: TextStyle(color:Colors.white,fontSize: 13.sp,fontWeight: FontWeight.w800,fontFamily:'VarelaRound'),),
                 SizedBox(height: 1.h),
                 SizedBox(
                     width: 50.w,
                     child: Text('discover new quotes and photoes added this week on quotes qo',style: TextStyle(color:Colors.white,fontSize:10.sp,fontFamily:'VarelaRound',),)),
               ],
             ),
             Spacer(),
             Container(
               height:15.h,
               width: 30.w,
               decoration: BoxDecoration(
               border: Border.all(
               color: Colors.white,
                 width: 1.sp,
                   ),
                   borderRadius: BorderRadius.circular(5.sp),
                   color: Colors.black,image:DecorationImage(
                   image:NetworkImage('https://images.unsplash.com/photo-1554177255-61502b352de3?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'),
               )),
             ),
           ],
         ),
       ),
     ],
   ),
 );
