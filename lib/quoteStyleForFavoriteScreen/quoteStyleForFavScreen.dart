
 import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
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
import 'package:statuses_only/shared/styles/icon_broken.dart';

class QuoteStyleForFav extends StatefulWidget {
  var model;

    QuoteStyleForFav(this.model, {Key? key}) : super(key: key);
   @override
   _QuoteStyleForFavState createState() => _QuoteStyleForFavState();
 }

 class _QuoteStyleForFavState extends State<QuoteStyleForFav> {
   Future<bool> onLikeButtonTapped(bool isLiked) async{
     if(AppCubit.get(context).music==true)
     {
       final file = await AudioCache().loadAsFile('mixin.wav');
       final bytes = await file.readAsBytes();
       AudioCache().playBytes(bytes);
     }
     if(AppCubit.get(context).IsFavoriteList.containsValue(widget.model))
     {
       AppCubit.get(context).deleteeDataForQuoteStylePage(qoute:widget.model);
     }
     else
     {
       AppCubit.get(context).insertToDatabaseForQuoteStyle(qoute:widget.model);

     }

     return !isLiked;
   }
   bool isLiked =false;
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
   @override
  void initState() {
     _createBottomBannerAd();
    super.initState();
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<AppCubit,AppCubitStates>(
       listener: (BuildContext context, state) {  },
       builder: (BuildContext context, Object? state) {
         return AnnotatedRegion<SystemUiOverlayStyle>(
           value:const SystemUiOverlayStyle(
           statusBarColor: Colors.transparent,
           statusBarIconBrightness:  Brightness.light,
         ),
           child: Scaffold(
             body:Stack(
               children: [
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Expanded(
                       child:Container(
                         decoration:  BoxDecoration(image:  DecorationImage(fit: BoxFit.cover,image: AppCubit.get(context).Photoess[AppCubit.get(context).change])),
                         child: InkWell(
                           splashColor: Colors.transparent,
                           highlightColor: Colors.transparent,
                           onTap: ()
                           async {
                             if(AppCubit.get(context).music==true)
                             {
                               final file = await AudioCache().loadAsFile('mix.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             setState(() {
                               AppCubit.get(context).ChangePhoto();
                             });
                           },
                           child: Column(
                             mainAxisSize: MainAxisSize.max,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Expanded(flex: 2,
                                   child: Container(height: 30.h,)),
                               Expanded(flex: 10,
                                 child: Padding(
                                   padding:  EdgeInsets.only(top: 30.sp,bottom: 30.sp,left: 15.sp,right: 15.sp),
                                   child: Center(
                                     child: Text(
                                       '${widget.model}',
                                       textAlign: TextAlign.center,
                                       style: TextStyle(
                                           height: AppCubit.get(context).GetDeviceTypeOfStyleScreen(),
                                           color: Colors.white,
                                           fontFamily: AppCubit.get(context).Texts[AppCubit.get(context).changeText],
                                           fontSize: AppCubit.get(context).forChangeFontSize(context),
                                           fontWeight: FontWeight.bold),
                                       overflow:TextOverflow.visible,
                                     ),
                                   ),
                                 ),
                               ),
                               const Spacer(),
                               if(SizerUtil.deviceType==DeviceType.mobile)
                                 Expanded(flex: 1,
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       Container(
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(
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
                                               final data = ClipboardData(text: widget.model);
                                               Clipboard.setData(data);
                                               Fluttertoast.showToast(msg: 'copied to clipboard',gravity: ToastGravity.CENTER);
                                             },
                                             padding: EdgeInsets.zero,
                                             icon: const Icon(
                                               MdiIcons.contentCopy,
                                               color: Colors.white,
                                             )),
                                       ),
                                       SizedBox(width: 6.w,),
                                       Container(
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(

                                             splashColor: Colors.transparent,
                                             highlightColor: Colors.transparent,
                                             iconSize: 20.sp,
                                             splashRadius: 26.sp,
                                             onPressed: ()
                                             async {
                                               /*
                                                       if(AppCubit.get(context).music==true)
                                                       {
                                                         final file = await AudioCache().loadAsFile('mixin.wav');
                                                         final bytes = await file.readAsBytes();
                                                         AudioCache().playBytes(bytes);
                                                       }

                                                       ShareFilesAndScreenshotWidgets().shareScreenshot(
                                                         AppCubit.get(context).previewContainer,
                                                         1000,
                                                         "Title",
                                                         "Name.png",
                                                         "image/png",
                                                       );

                                                        */
                                               if(AppCubit.get(context).music==true)
                                               {
                                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                                 final bytes = await file.readAsBytes();
                                                 AudioCache().playBytes(bytes);
                                               }
                                               Clipboard.setData(ClipboardData());
                                               Share.share('${widget.model}');

                                             },
                                             padding: EdgeInsets.zero,
                                             icon: const Icon(
                                               MdiIcons.shareVariant,
                                               color: Colors.white,
                                             )),
                                       ),
                                       SizedBox(width: 6.w,),
                                       Container(
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(
                                             splashColor: Colors.transparent,
                                             highlightColor: Colors.transparent,
                                             alignment: AlignmentDirectional.center,
                                             iconSize: 20.sp,
                                             splashRadius: 26.sp,
                                             onPressed: () async{
                                               if(AppCubit.get(context).music==true)
                                               {
                                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                                 final bytes = await file.readAsBytes();
                                                 AudioCache().playBytes(bytes);
                                               }
                                               setState(() {
                                                 AppCubit.get(context).ChangeText();
                                               });
                                             },
                                             padding: EdgeInsets.zero,
                                             icon: Image(fit: BoxFit.cover,color: Colors.white,
                                               alignment: AlignmentDirectional.center,
                                               height: 17.5.sp,
                                               image: const AssetImage('assets/images/type.png'),
                                             )),
                                       ),
                                       SizedBox(width: 6.w,),
                                       /*
                                   IconButton(
                                       iconSize: 20.sp,
                                       splashRadius: 26.sp,
                                       splashColor: Colors.grey,
                                       onPressed: ()
                                       {
                                           AppCubit.get(context).insertToDatabase(qoute: widget.qoute);
                                           Fluttertoast.showToast(msg: 'Added Successfully to favorites',gravity: ToastGravity.CENTER);
                                       },
                                       padding: EdgeInsets.zero,
                                       icon: Icon(
                                           Icons.favorite,
                                           color: Colors.blue,
                                       )),

                                    */
                                       Container(
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(
                                           onPressed: () {  },
                                           icon: LikeButton(
                                             padding: EdgeInsets.zero,
                                             size: 18.sp,
                                             circleColor:
                                             const CircleColor(start: Colors.white, end: Colors.white),
                                             bubblesColor: const BubblesColor(
                                               dotPrimaryColor: Colors.white,
                                               dotSecondaryColor: Colors.white,
                                               dotLastColor: Colors.white,
                                               dotThirdColor: Colors.white,
                                             ),
                                             onTap: onLikeButtonTapped,
                                             isLiked: isLiked,
                                             likeBuilder: ( isLiked) {
                                               return Padding(
                                                 padding:  EdgeInsets.only(top: 0),
                                                 child: Icon(
                                                   AppCubit.get(context).function(widget.model)? Icons.favorite_outline:Icons.favorite,
                                                   color: isLiked ? Colors.white : Colors.white,
                                                   size: 20.sp,
                                                 ),
                                               );
                                             },
                                           ),
                                         ),
                                       ),
                                       SizedBox(width: 6.w,),
                                       Container(
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(
                                             splashColor: Colors.transparent,
                                             highlightColor: Colors.transparent,
                                             alignment: AlignmentDirectional.center,
                                             iconSize: 20.sp,
                                             splashRadius: 26.sp,
                                             onPressed: () async{
                                               if(AppCubit.get(context).music==true)
                                               {
                                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                                 final bytes = await file.readAsBytes();
                                                 AudioCache().playBytes(bytes);
                                               }
                                               setState(() {
                                                 AppCubit.get(context).ChangePhoto();
                                               });
                                             },
                                             padding: EdgeInsets.zero,
                                             icon: Padding(
                                               padding:  EdgeInsets.only(top: .0.sp,left: 3.sp),
                                               child: Image(fit: BoxFit.cover,color: Colors.white,
                                                 alignment: AlignmentDirectional.center,
                                                 height: 20.5.sp,
                                                 image:  AssetImage('assets/images/paint.png'),
                                               ),
                                             )),
                                       ),
                                     ],
                                   ),
                                 ),
                               if(SizerUtil.deviceType==DeviceType.tablet)
                                 Expanded(flex: 1,
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       Container(
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(
                                             splashColor: Colors.transparent,
                                             highlightColor: Colors.transparent,
                                             iconSize: 17.sp,
                                             splashRadius: 26.sp,
                                             onPressed: () async{
                                               if(AppCubit.get(context).music==true)
                                               {
                                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                                 final bytes = await file.readAsBytes();
                                                 AudioCache().playBytes(bytes);
                                               }
                                               final data = ClipboardData(text: widget.model);
                                               Clipboard.setData(data);
                                               Fluttertoast.showToast(msg: 'copied to clipboard',gravity: ToastGravity.CENTER);
                                             },
                                             padding: EdgeInsets.zero,
                                             icon: const Icon(
                                               MdiIcons.contentCopy,
                                               color: Colors.white,
                                             )),
                                         height: 10.h,
                                         width: 10.w,
                                       ),
                                       SizedBox(width: 6.w,),
                                       Container(
                                         height: 10.h,
                                         width: 10.w,
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(

                                             splashColor: Colors.transparent,
                                             highlightColor: Colors.transparent,
                                             iconSize: 17.sp,
                                             splashRadius: 26.sp,
                                             onPressed: ()
                                             async {
                                               /*
                                                         if(AppCubit.get(context).music==true)
                                                         {
                                                           final file = await AudioCache().loadAsFile('mixin.wav');
                                                           final bytes = await file.readAsBytes();
                                                           AudioCache().playBytes(bytes);
                                                         }
                                                         /*
                                                       ShareFilesAndScreenshotWidgets().shareScreenshot(
                                                         previewContainer,
                                                         1000,
                                                         "Title",
                                                         "Name.png",
                                                         "image/png",
                                                       );

                                                        */

                                                         Clipboard.setData(ClipboardData());
                                                         HapticFeedback.heavyImpact();
                                                         Share.share('${widget.qoute}');

                                                          */
                                               if(AppCubit.get(context).music==true)
                                               {
                                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                                 final bytes = await file.readAsBytes();
                                                 AudioCache().playBytes(bytes);
                                               }
                                               Clipboard.setData(ClipboardData());
                                               Share.share('${widget.model}');
                                             },
                                             padding: EdgeInsets.zero,
                                             icon: const Icon(
                                               MdiIcons.shareVariant,
                                               color: Colors.white,
                                             )),
                                       ),
                                       SizedBox(width: 6.w,),
                                       Container(
                                         height: 10.h,
                                         width: 10.w,
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(
                                             splashColor: Colors.transparent,
                                             highlightColor: Colors.transparent,
                                             alignment: AlignmentDirectional.center,
                                             iconSize: 17.sp,
                                             splashRadius: 26.sp,
                                             onPressed: () async{
                                               if(AppCubit.get(context).music==true)
                                               {
                                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                                 final bytes = await file.readAsBytes();
                                                 AudioCache().playBytes(bytes);
                                               }
                                               setState(() {
                                                 AppCubit.get(context).ChangeText();
                                               });
                                             },
                                             padding: EdgeInsets.zero,
                                             icon: Image(fit: BoxFit.cover,color: Colors.white,
                                               alignment: AlignmentDirectional.center,
                                               height: 15.sp,
                                               image: const AssetImage('assets/images/type.png'),
                                             )),
                                       ),
                                       SizedBox(width: 6.w,),
                                       /*
                                   IconButton(
                                       iconSize: 20.sp,
                                       splashRadius: 26.sp,
                                       splashColor: Colors.grey,
                                       onPressed: ()
                                       {
                                           AppCubit.get(context).insertToDatabase(qoute: widget.qoute);
                                           Fluttertoast.showToast(msg: 'Added Successfully to favorites',gravity: ToastGravity.CENTER);
                                       },
                                       padding: EdgeInsets.zero,
                                       icon: Icon(
                                           Icons.favorite,
                                           color: Colors.blue,
                                       )),

                                    */
                                       Container(
                                         height: 10.h,
                                         width: 10.w,
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(
                                           onPressed: () {  },
                                           icon: LikeButton(
                                             padding: EdgeInsets.zero,
                                             size: 20.sp,
                                             circleColor:
                                             const CircleColor(start: Colors.white, end: Colors.white),
                                             bubblesColor: const BubblesColor(
                                               dotPrimaryColor: Colors.white,
                                               dotSecondaryColor: Colors.white,
                                               dotLastColor: Colors.white,
                                               dotThirdColor: Colors.white,
                                             ),
                                             onTap: onLikeButtonTapped,
                                             isLiked: isLiked,
                                             likeBuilder: ( isLiked) {
                                               return Padding(
                                                 padding:  EdgeInsets.only(top: .5.sp),
                                                 child: Icon(
                                                   AppCubit.get(context).function(widget.model)? Icons.favorite_outline:Icons.favorite,
                                                   color: isLiked ? Colors.white : Colors.white,
                                                   size: 18.sp,
                                                 ),
                                               );
                                             },
                                           ),
                                         ),
                                       ),
                                       SizedBox(width: 6.w,),
                                       Container(
                                         height: 10.h,
                                         width: 10.w,
                                         decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                                         child: IconButton(
                                             splashColor: Colors.transparent,
                                             highlightColor: Colors.transparent,
                                             alignment: AlignmentDirectional.center,
                                             iconSize: 17.sp,
                                             splashRadius: 26.sp,
                                             onPressed: () async{
                                               if(AppCubit.get(context).music==true)
                                               {
                                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                                 final bytes = await file.readAsBytes();
                                                 AudioCache().playBytes(bytes);
                                               }
                                               setState(() {
                                                 AppCubit.get(context).ChangePhoto();
                                               });
                                             },
                                             padding: EdgeInsets.zero,
                                             icon: Padding(
                                               padding:  EdgeInsets.only(top: .0.sp,left: 3.sp),
                                               child: Image(fit: BoxFit.cover,color: Colors.white,
                                                 alignment: AlignmentDirectional.center,
                                                 height: 18.sp,
                                                 image:  AssetImage('assets/images/paint.png'),
                                               ),
                                             )),
                                       ),
                                     ],
                                   ),
                                 ),
                               SizedBox(height: 3.h),
                             ],
                           ),
                         ),
                       ),
                     ),
                     /*
                               Container(
                                 padding: EdgeInsets.zero,
                                 //  height: 7.h,
                                 width: double.infinity,
                                 /*
                                 decoration:  BoxDecoration(
                                   color: Colors.grey[300],
                                 ),

                                  */

                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     IconButton(
                                         splashColor: Colors.transparent,
                                         highlightColor: Colors.transparent,
                                         iconSize: 20.sp,
                                         splashRadius: 26.sp,
                                         onPressed: () async{
                                           final data = ClipboardData(text: widget.qoute);
                                           Clipboard.setData(data);
                                           Fluttertoast.showToast(msg: 'copied to clipboard',gravity: ToastGravity.CENTER);
                                           final file = await AudioCache().loadAsFile('mixin.wav');
                                           final bytes = await file.readAsBytes();
                                           AudioCache().playBytes(bytes);
                                         },
                                         padding: EdgeInsets.zero,
                                         icon: const Icon(
                                           MdiIcons.contentCopy,
                                           color: Colors.blue,
                                         )),
                                     SizedBox(width: 6.w,),
                                     IconButton(

                                         splashColor: Colors.transparent,
                                         highlightColor: Colors.transparent,
                                         iconSize: 20.sp,
                                         splashRadius: 26.sp,
                                         onPressed: ()
                                         async{
                                           final file = await AudioCache().loadAsFile('mixin.wav');
                                           final bytes = await file.readAsBytes();
                                           AudioCache().playBytes(bytes);
                                           ShareFilesAndScreenshotWidgets().shareScreenshot(
                                             previewContainer,
                                             1000,
                                             "Title",
                                             "Name.png",
                                             "image/png",
                                           );
                                         },
                                         padding: EdgeInsets.zero,
                                         icon: const Icon(
                                           MdiIcons.shareVariant,
                                           color: Colors.blue,
                                         )),
                                     SizedBox(width: 6.w,),
                                     IconButton(
                                         splashColor: Colors.transparent,
                                         highlightColor: Colors.transparent,
                                         alignment: AlignmentDirectional.center,
                                         iconSize: 20.sp,
                                         splashRadius: 26.sp,
                                         onPressed: () async{
                                           final file = await AudioCache().loadAsFile('mixin.wav');
                                           final bytes = await file.readAsBytes();
                                           AudioCache().playBytes(bytes);
                                           AppCubit.get(context).ChangeText();
                                         },
                                         padding: EdgeInsets.zero,
                                         icon: Padding(
                                           padding:  EdgeInsets.only(top: .8.sp),
                                           child: Image(fit: BoxFit.cover,color: Colors.blue,
                                             alignment: AlignmentDirectional.center,
                                             height: 18.sp,
                                             image: const AssetImage('assets/images/change.png'),
                                           ),
                                         )),
                                     SizedBox(width: 6.w,),
                                     /*
                                     IconButton(
                                         iconSize: 20.sp,
                                         splashRadius: 26.sp,
                                         splashColor: Colors.grey,
                                         onPressed: ()
                                         {
                                           AppCubit.get(context).insertToDatabase(qoute: widget.qoute);
                                           Fluttertoast.showToast(msg: 'Added Successfully to favorites',gravity: ToastGravity.CENTER);
                                         },
                                         padding: EdgeInsets.zero,
                                         icon: Icon(
                                           Icons.favorite,
                                           color: Colors.blue,
                                         )),

                                      */
                                     LikeButton(
                                       padding: EdgeInsets.zero,
                                       size: 20.sp,
                                       circleColor:
                                       const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                       bubblesColor: const BubblesColor(
                                         dotPrimaryColor: Colors.red,
                                         dotSecondaryColor: Colors.orange,
                                         dotLastColor: Colors.purple,
                                         dotThirdColor: Colors.pink,
                                       ),
                                       onTap: onLikeButtonTapped,
                                       isLiked: isLiked,
                                       likeBuilder: ( isLiked) {
                                         return Padding(
                                           padding:  EdgeInsets.only(top: .5.sp),
                                           child: Icon(
                                             AppCubit.get(context).function(widget.qoute)? Icons.favorite_outline:Icons.favorite,
                                             color: isLiked ? Colors.red : Colors.blue,
                                             size: 21.sp,
                                           ),
                                         );
                                       },
                                     ),
                                     SizedBox(width: 6.w,),
                                     IconButton(
                                         splashColor: Colors.transparent,
                                         highlightColor: Colors.transparent,
                                         alignment: AlignmentDirectional.center,
                                         iconSize: 20.sp,
                                         splashRadius: 26.sp,
                                         onPressed: () async{
                                           final file = await AudioCache().loadAsFile('mixin.wav');
                                           final bytes = await file.readAsBytes();
                                           AudioCache().playBytes(bytes);
                                           AppCubit.get(context).ChangePhoto();
                                         },
                                         padding: EdgeInsets.zero,
                                         icon: Padding(
                                           padding:  EdgeInsets.only(top: .8.sp),
                                           child: Image(fit: BoxFit.cover,color: Colors.blue,
                                             alignment: AlignmentDirectional.center,
                                             height: 20.sp,
                                             image: const AssetImage('assets/images/paint.png'),
                                           ),
                                         )),
                                   ],
                                 ),
                               ),

                                */
                   ],
                 ),
                 if(SizerUtil.deviceType==DeviceType.mobile)
                   Padding(
                     padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                     child: Container(
                       decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                       child: IconButton(onPressed: () async {
                         if(AppCubit.get(context).music==true)
                         {
                           final file = await AudioCache().loadAsFile('mixin.wav');
                           final bytes = await file.readAsBytes();
                           AudioCache().playBytes(bytes);
                         }
                         Navigator.pop(context);
                       }, icon: Icon(IconBroken.Arrow___Left,size:18.sp),
                         splashColor: Colors.transparent,color: Colors.white,
                         highlightColor: Colors.transparent,

                       ),
                     ),
                   ),
                 if(SizerUtil.deviceType==DeviceType.tablet)
                   Padding(
                     padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                     child: Container(
                       decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                       child: IconButton(onPressed: () async {
                         if(AppCubit.get(context).music==true)
                         {
                           final file = await AudioCache().loadAsFile('mixin.wav');
                           final bytes = await file.readAsBytes();
                           AudioCache().playBytes(bytes);
                         }
                         Navigator.pop(context);
                       }, icon: Icon(IconBroken.Arrow___Left,size:18.sp),
                         splashColor: Colors.transparent,color: Colors.white,
                         highlightColor: Colors.transparent,

                       ),
                       height: 10.h,
                       width: 10.w,
                     ),
                   ),
               ],
             ),
             bottomNavigationBar: _isBottomBannerAdLoaded
                 ? Container(
               color: AppCubit.get(context).isDark
                   ? Colors.black
                   : Colors.white,
               height: _bottomBannerAd.size.height.toDouble(),
               width: _bottomBannerAd.size.width.toDouble(),
               child: AdWidget(ad: _bottomBannerAd),
             )
                 : null,
           ),
         );
       },
     );
   }
   @override
  void dispose() {
     _bottomBannerAd.dispose();
    super.dispose();
  }
 }
