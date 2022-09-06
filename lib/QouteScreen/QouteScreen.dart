
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/QouteStyle/QouteStyle.dart';
import 'package:statuses_only/adHelper/adHelper.dart';
import 'package:statuses_only/model/typeOfQoutes/typeOfQoutes.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';


class QouteScreen extends StatefulWidget {
  var name;
  var id;

    QouteScreen( this.name,  this.id, {Key? key}) : super(key: key);

  @override
  State<QouteScreen> createState() => _QouteScreenState();
}

class _QouteScreenState extends State<QouteScreen> {
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-6775155780565884/1588965913'
          : 'ca-app-pub-3940256099942544/2934735716',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }
  final _inlineAdIndex = 6;
  late BannerAd _inlineBannerAd;
  bool _isInlineBannerAdLoaded = false;
  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: Platform.isAndroid?'ca-app-pub-6775155780565884/1588965913':'ca-app-pub-3940256099942544/2934735716',
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isInlineBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _inlineBannerAd.load();
  }
  int _getListViewItemIndex(index) {
    if (index >= _inlineAdIndex && _isInlineBannerAdLoaded) {
      return index - 1;
    }
    return index;
  }
  @override
  void initState() {
    _createBottomBannerAd();
    _createInlineBannerAd();
   // AppCubit.get(context).MyBanner.load();
    super.initState();
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<AppCubit,AppCubitStates>(
       listener: (BuildContext context, state) {  },
       builder: (BuildContext context, Object? state) {
         return Scaffold(
           appBar: AppBar(
             titleSpacing: 0,
             toolbarHeight: 7.6.h,
             title: SizerUtil.deviceType==DeviceType.mobile?Text('${widget.name}',style: TextStyle(color: Colors.white,fontSize: 15.5.sp,fontWeight: FontWeight.w600,fontFamily:'VarelaRound',),)
                 :Padding(
                   padding: EdgeInsets.only(left: 0.w),
                   child: Text('${widget.name}',style: TextStyle(color: Colors.white,fontSize: 15.5.sp,fontWeight: FontWeight.w600,fontFamily:'VarelaRound',),),
                 ),
             leadingWidth: 14.2.w,
             leading:IconButton(
               icon:  Icon(
                 IconBroken.Arrow___Left,
                 color: Colors.white,
                 size: 18.sp,
               ),
               onPressed: () async {
                 if(AppCubit.get(context).music==true)
                 {
                   final file = await AudioCache().loadAsFile('mixin.wav');
                   final bytes = await file.readAsBytes();
                   AudioCache().playBytes(bytes);
                 }
                 Navigator.pop(context);
               },
             ),
           ),

           bottomNavigationBar:_isBottomBannerAdLoaded ? Container(
             color: AppCubit.get(context).isDark
                 ? Colors.black
                 : Colors.white,
             height: _bottomBannerAd.size.height.toDouble(),
             width: _bottomBannerAd.size.width.toDouble(),
             child: AdWidget(ad: _bottomBannerAd),
           ) : null,
           body: StreamBuilder<QuerySnapshot>(
             stream: AppCubit.get(context).GetQoutesFromTypeOfQoutes(widget.id),
             builder: (context, snapshot) {
               if (!snapshot.hasData) {
                 return const Center(child: CircularProgressIndicator());
               } else {
                 AppCubit.get(context).Qoutess = [];
                 for (var doc in snapshot.data!.docs) {
                   AppCubit.get(context).Qoutess.add(TypeOfQoutesModel(Qoute:doc['qoute'],));
                   AppCubit.get(context).LIST=List.filled(AppCubit.get(context).Qoutess.length, false);
                 }
                 return  ConditionalBuilder(
                   condition: AppCubit.get(context).Qoutess.isNotEmpty,
                   builder: (BuildContext context) =>  ListView.separated(
                     itemBuilder: (context, index) {
                       /*
                       if (_isInlineBannerAdLoaded && index == _inlineAdIndex) {
                         return Container(
                           padding: EdgeInsets.only(
                             bottom: 0,
                           ),
                           width: _inlineBannerAd.size.width.toDouble(),
                           height: _inlineBannerAd.size.height.toDouble(),
                           child: AdWidget(ad: _inlineBannerAd),
                         );
                       }
                       else
                         {
                           return BuilViewForQoute(context,AppCubit.get(context).Qoutess[_getListViewItemIndex(index)],_getListViewItemIndex(index));
                         }

                        */
                       return BuilViewForQoute(context,AppCubit.get(context).Qoutess[index],index);
                     } ,
                     separatorBuilder: (BuildContext context, int index)
                     {
                       if (index == 5&&_isInlineBannerAdLoaded ) {
                         return Container(
                           padding: EdgeInsets.only(
                             bottom: 0,
                           ),
                           width: _inlineBannerAd.size.width.toDouble(),
                           height: _inlineBannerAd.size.height.toDouble(),
                           child: AdWidget(ad: _inlineBannerAd),
                         );
                       }
                       else {
                         return Container(height: 0,);
                       }
                     },
                     itemCount: AppCubit.get(context).Qoutess.length,
                     /*
                     separatorBuilder: (BuildContext context, int index) {

                       if (index % 5 == 0&&index!=0) {
                        return AppCubit.get(context).getAd();
                       }
                       else {
                         return Container();
                       }
                       /*
                         if (_isAdLoaded && index %2==0) {
                           return Container(
                             child: AdWidget(ad: _ad),
                             width: _ad.size.width.toDouble(),
                             height:_ad.size.height.toDouble(),
                             alignment: Alignment.center,
                           );
                         } else {
                           // TODO: Get adjusted item index from _getDestinationItemIndex()
                           return Container();
                         }

                        */
                       },

                      */
                   ),
                   fallback: (BuildContext context) =>  Center(child: Text('No Quotes..',style: TextStyle(fontSize: 27.sp,fontFamily:'Dongle',fontWeight: FontWeight.w400,color: AppCubit.get(context).isDark?Colors.white:Colors.black),)),
                 );
               }
             },
           ),
         );
       },

     );
   }
   @override
  void dispose() {
     _bottomBannerAd.dispose();
     _inlineBannerAd.dispose();
  //   AppCubit.get(context).MyBanner.dispose();
    super.dispose();
  }
}
 class BuilViewForQoute extends StatefulWidget {
  TypeOfQoutesModel qout;
  int index;
    BuilViewForQoute(BuildContext context, TypeOfQoutesModel this.qout,this.index, {Key? key}) : super(key: key);

  @override
  State<BuilViewForQoute> createState() => _BuilViewForQouteState();
}


class _BuilViewForQouteState extends State<BuilViewForQoute> {

  bool isLiked =false;
  Future<bool> onLikeButtonTapped(bool isLiked,) async{

    if(AppCubit.get(context).music==true)
    {
      final file = await AudioCache().loadAsFile('mixin.wav');
      final bytes = await file.readAsBytes();
      AudioCache().playBytes(bytes);
    }
    if(AppCubit.get(context).IsFavoriteList.containsValue(widget.qout.Qoute))
    {
      AppCubit.get(context).deleteeData(qoute: widget.qout.Qoute).then((value)
      {
        setState(() {
          AppCubit.get(context).getDataFromDatabaseForLikeButton(AppCubit.get(context).database);
        });
      });
      /*
                 .then((value)
             {

               Fluttertoast.showToast(msg: 'Deleted from favorites',gravity: ToastGravity.CENTER,backgroundColor: Colors.red);
             });

              */
    }
    else
    {
      AppCubit.get(context).insertToDatabase(qoute: widget.qout.Qoute).then((value){
        setState(() {
          AppCubit.get(context).getDataFromDatabaseForLikeButton(AppCubit.get(context).database);
      });});
      /*
                 .then((value)
             {
               Fluttertoast.showToast(msg: 'Added to favorites',gravity: ToastGravity.CENTER);

             });

                  */
    }

    return !isLiked;
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<AppCubit,AppCubitStates>(
       listener: (BuildContext context, state) {  },
       builder: (BuildContext context, Object? state) {
         return Padding(
           padding:  EdgeInsets.all(1.1.h),
           child:Container(
             //    width: double.infinity,
             //    height: 22.h,
             decoration: BoxDecoration(
               //  ${AppCubit.get(context).Images[AppCubit.get(context).change]}
               color:AppCubit.get(context).isDark==false?Colors.white:Colors.black,
               boxShadow: [
                 BoxShadow(
                   offset: const Offset(0, 1),
                   blurRadius: 5,
                   color: AppCubit.get(context).isDark==false?Colors.black.withOpacity(0.3):Colors.white,
                 ),
               ],
               borderRadius: BorderRadius.circular(1.1.h),
             ),

             child: Column(
               children: [
                 InkWell(
                   onTap: ()
                   async{
                     if(AppCubit.get(context).music==true)
                     {
                       final file = await AudioCache().loadAsFile('mixin.wav');
                       final bytes = await file.readAsBytes();
                       AudioCache().playBytes(bytes);
                     }
                     AppCubit.get(context).change=0;
                     AppCubit.get(context).changeText=0;
                     if(AppCubit.get(context).interstialadCount==5)
                     {
                       AppCubit.get(context).showInterstialAd();
                     }
                      else if(AppCubit.get(context).interstialadCount==0) {
                       AppCubit.get(context).loadInterstialAd();
                     }
                     AppCubit.get(context).adCount();
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => QouteStyle('${widget.qout.Qoute}',widget.index),
                       ),
                     );
                   },
                   child: Padding(
                     padding:  EdgeInsets.all(4.h),
                     child: Text(
                       '${widget.qout.Qoute}',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                     //      height: 1.2.sp,
                             height:AppCubit.get(context).GetDeviceType(),
                           color: AppCubit.get(context).isDark==false?Colors.grey[700]:Colors.white,
                           fontFamily:'Dongle',
                       //    fontSize: 14.3.sp,
                           fontSize: 24.5.sp,
                           fontWeight: FontWeight.w600),
                     ),
                   ),
                 ),
                 Container(
                   padding: EdgeInsets.zero,
                     height: 7.h,
                   width: double.infinity,
                   color: AppCubit.get(context).isDark==false?Colors.grey[300]:Colors.grey[900],
                   alignment: Alignment.center,
                   child: Center(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             iconSize: 20.sp,
                             splashRadius: 26.sp,
                             onPressed: ()
                             async{
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               final data = ClipboardData(text: '${widget.qout.Qoute}');
                               Clipboard.setData(data);
                               Fluttertoast.showToast(msg: 'copied to clipboard',gravity: ToastGravity.CENTER);
                             },
                             padding: EdgeInsets.zero,
                             icon: const Icon(
                               MdiIcons.contentCopy,
                               color: Colors.blue,
                             )),
                         if(SizerUtil.deviceType==DeviceType.mobile)
                         SizedBox(width:1.w,),
                         if(SizerUtil.deviceType==DeviceType.tablet)
                           SizedBox(width:4.w,),
                         IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             iconSize: 20.sp,
                             splashRadius: 26.sp,
                             onPressed: () async{
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               Clipboard.setData(ClipboardData());
                               Share.share('${widget.qout.Qoute}');
                             },
                             padding: EdgeInsets.zero,
                             icon: const Icon(
                               MdiIcons.shareVariant,
                               color: Colors.blue,
                             )),
                         SizedBox(width: 3.2.w,),
                         /*
                           IconButton(
                               key: Key('${widget.index}'),
                               iconSize: 20.sp,
                               splashRadius: 26.sp,
                               splashColor: Colors.grey,
                               onPressed: ()
                               async{
                                 if(AppCubit.get(context).IsFavoriteList.containsValue(widget.qout.Qoute))
                                    {
                                   AppCubit.get(context).deleteeData(qoute: widget.qout.Qoute).then((value)
                                   {
                                     Fluttertoast.showToast(msg: 'Deleted from favorites',gravity: ToastGravity.CENTER,backgroundColor: Colors.red);
                                     setState(() {

                                     });
                                   });
                                 }
                                 else
                                    {
                                       AppCubit.get(context).insertToDatabase(qoute: widget.qout.Qoute).then((value)
                                      {
                                       Fluttertoast.showToast(msg: 'Added Successfully to favorites',gravity: ToastGravity.CENTER);
                                       setState(() {

                                       });
                                     });

                                   }
                               },
                               padding: EdgeInsets.zero,
                               icon: Icon(AppCubit.get(context).function(widget.qout.Qoute)? Icons.favorite_outline:Icons.favorite,
                                 color: Colors.blue,
                               )),

                            */
                         LikeButton(
                           size: 20.sp,
                           circleColor:
                           const CircleColor(start: Colors.blue, end: Colors.blue),
                           bubblesColor:  BubblesColor(
                             dotPrimaryColor:AppCubit.get(context).isDark?Colors.white:Colors.blue,
                             dotSecondaryColor: AppCubit.get(context).isDark?Colors.white:Colors.blue,
                             dotLastColor: AppCubit.get(context).isDark?Colors.white:Colors.blue,
                             dotThirdColor: AppCubit.get(context).isDark?Colors.white:Colors.blue,
                           ),
                           onTap: onLikeButtonTapped,
                           isLiked: isLiked,
                           likeBuilder: ( isLiked) {
                             return Icon(
                               AppCubit.get(context).function(widget.qout.Qoute)? Icons.favorite_outline:Icons.favorite,
                               color: isLiked ? Colors.blue : Colors.blue,
                               size: 20.sp,
                             );
                           },
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ),
         );
       },
     );
   }
}
 /*
 Widget BuilViewForQoute(context, TypeOfQoutesModel qout, int index)
 {

   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: InkWell(
       onTap: ()
       {
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => QouteStyle('${qout.Qoute}'),
           ),
         );

       },
       child: Container(
         //    width: double.infinity,
         //    height: 22.h,

         decoration: BoxDecoration(
           //  ${AppCubit.get(context).Images[AppCubit.get(context).change]}
           color: Colors.white,
           boxShadow: [
             BoxShadow(
               offset: const Offset(0, 1),
               blurRadius: 5,
               color: Colors.black.withOpacity(0.3),
             ),
           ],
           borderRadius: BorderRadius.circular(8),
         ),

         child: Column(
           children: [
             Padding(
               padding: const EdgeInsets.all(35.0),
               child: Text(
                 '${qout.Qoute}',
                 textAlign: TextAlign.center,
                 style: TextStyle(
                     height: 1.3.sp,
                     color: Colors.black,
                     //     color: Colors.grey[700],
                     fontSize: 16.sp,
                     fontWeight: FontWeight.w400),
               ),
             ),
             Container(
               padding: EdgeInsets.zero,
               //  height: 7.h,
               width: double.infinity,
               color: Colors.grey[300],
               alignment: Alignment.center,
               child: Center(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     IconButton(
                         iconSize: 20.sp,
                         splashRadius: 26.sp,
                         splashColor: Colors.grey,
                         onPressed: ()
                         {
                           final data = ClipboardData(text: '${qout.Qoute}');
                           Clipboard.setData(data);
                           Fluttertoast.showToast(msg: 'copied to clipboard',gravity: ToastGravity.CENTER);
                         },
                         padding: EdgeInsets.zero,
                         icon: Icon(
                           MdiIcons.contentCopy,
                           color: Colors.blue,
                         )),
                     SizedBox(width: 5.w,),
                     IconButton(
                         iconSize: 20.sp,
                         splashRadius: 26.sp,
                         splashColor: Colors.grey,
                         onPressed: () {
                           Share.share('${qout.Qoute}');
                         },
                         padding: EdgeInsets.zero,
                         icon: Icon(
                           MdiIcons.shareVariant,
                           color: Colors.blue,
                         )),
                     SizedBox(width: 5.w,),
                     IconButton(
                       key: Key('${index}'),
                         iconSize: 20.sp,
                         splashRadius: 26.sp,
                         splashColor: Colors.grey,
                         onPressed: ()
                         {
                         AppCubit.get(context).insertToDatabase(qoute: qout.Qoute);
                         Fluttertoast.showToast(msg: 'Added Successfully to favorites',gravity: ToastGravity.CENTER);
                         },
                         padding: EdgeInsets.zero,
                         icon: Icon(AppCubit.get(context).IsFavoriteList.containsValue(qout.Qoute)? Icons.favorite:Icons.favorite_outline,
                           color: Colors.blue,
                         )),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),
     ),
   );
 }

  */

