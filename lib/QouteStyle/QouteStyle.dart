

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:like_button/like_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/model/typeOfQoutes/typeOfQoutes.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';

import '../AppCubit/appCubit.dart';

 class QouteStyle extends StatefulWidget {
   String qoute;
  int index;
  var id;
   QouteStyle(String this.qoute, this.index, this.id, {Key? key}) : super(key: key);

  @override
  State<QouteStyle> createState() => _QouteStyleState();
}

class _QouteStyleState extends State<QouteStyle> {

/*
   late final AudioCache _audioCache;

   @override
   initState()   {
     super.initState();
     _audioCache = AudioCache(
       prefix: 'audio/',
       fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
     );
     AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer = AudioPlayer(playerId: 'my_unique_playerId');
   }


 */
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
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
  PageController? contoller;
  @override
  void initState() {
    _createBottomBannerAd();
    contoller = PageController(initialPage: widget.index, keepPage: true,);
    AppCubit.get(context).fntSize = 0;
    AppCubit.get(context).changeArabicText= 0;
    AppCubit.get(context).changeText= 0;
    super.initState();
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<AppCubit,AppCubitStates>(
       listener: (BuildContext context, state) {  },
       builder: (BuildContext context, Object? state) {
         return ConditionalBuilder(
             condition: AppCubit.get(context).Qoutess!=null,
             builder: (context)=>AnnotatedRegion<SystemUiOverlayStyle>(
               value: const SystemUiOverlayStyle(
                 statusBarColor: Colors.transparent,
                 statusBarIconBrightness:  Brightness.light,
               ),
               child: Scaffold(
                 body: PaginateFirestore(
                   itemBuilder: (context, documentSnapshots, index)
                   {
                     /*
                     AppCubit.get(context).Qoutess = [];
                     for (var doc in documentSnapshots) {
                       AppCubit.get(context).Qoutess.add(TypeOfQoutesModel(Qoute:doc['qoute'],));
                     }

                      */
                     return pageView(AppCubit.get(context).Qoutess[index]);

                   }, // orderBy is compulsary to enable pagination
                   query:AppCubit.get(context).GetQoutesFromTypeOfQoutesForPagination(widget.id),
                   itemBuilderType: PaginateBuilderType.pageView,
                   scrollDirection: Axis.horizontal,
                   onPageChanged:(page){
                     if(AppCubit.get(context).interstialadCountForQuoteStyle==3)
                     {
                       AppCubit.get(context).showInterstialAd();
                     }
                     else if(AppCubit.get(context).interstialadCountForQuoteStyle==0) {
                       AppCubit.get(context).loadInterstialAd();
                     }
                     AppCubit.get(context).adCountForQouteStyle();
                     print('quote == ${AppCubit.get(context).interstialadCountForQuoteStyle}');
                   },
                   pageController:contoller,

                   itemsPerPage:AppCubit.get(context).Qoutess.length,
                   shrinkWrap: false,
                   bottomLoader:Text(''),
                   isLive: true,
                 ),
                 /*
                 PageView.builder(
                   scrollDirection: Axis.horizontal,
                   onPageChanged: (page)
                   {
                     if(AppCubit.get(context).interstialadCountForQuoteStyle==3)
                     {
                       AppCubit.get(context).showInterstialAd();
                     }
                     else if(AppCubit.get(context).interstialadCountForQuoteStyle==0) {
                       AppCubit.get(context).loadInterstialAd();
                     }
                     AppCubit.get(context).adCountForQouteStyle();
                     print('quote == ${AppCubit.get(context).interstialadCountForQuoteStyle}');
                   },
                   itemCount: AppCubit.get(context).Qoutess.length,
                   /*
              List.generate(AppCubit.get(context).videoList.length, (index) => pageView(AppCubit.get(context).videoList[index]),),

               */
                   controller: contoller,
                   itemBuilder: (BuildContext context, int index)=>pageView(AppCubit.get(context).Qoutess[index]),
                 ),

                  */
                 /*
                 Stack(
                   children: [
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Expanded(
                           child:RepaintBoundary(
                             key:AppCubit.get(context).previewContainer ,
                             child:  Container(
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
                                         padding:  EdgeInsets.all(30.sp,),
                                         child: Center(
                                           child: Text(
                                             widget.qoute,
                                             textAlign: TextAlign.center,
                                             style: TextStyle(
                                                 height: AppCubit.get(context).GetDeviceTypeOfStyleScreen(),
                                                 color: Colors.white,
                                                 fontFamily: AppCubit.get(context).Texts[AppCubit.get(context).changeText],
                                                 fontSize: AppCubit.get(context).forChangeFontSize(context),
                                                 fontWeight: FontWeight.w600),
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
                                                   final data = ClipboardData(text: widget.qoute);
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
                                                   Share.share('${widget.qoute}');

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
                                                       AppCubit.get(context).function(widget.qoute)? Icons.favorite_outline:Icons.favorite,
                                                       color: isLiked ? Colors.white : Colors.white,
                                                       size: 21.sp,
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
                                                     final data = ClipboardData(text: widget.qoute);
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
                                                     Share.share('${widget.qoute}');
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
                                                         AppCubit.get(context).function(widget.qoute)? Icons.favorite_outline:Icons.favorite,
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

                  */
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
             ),
             fallback: (context)=>const Center(child: CircularProgressIndicator()));
       },
     );
   }
   @override
  void dispose() {
     _bottomBannerAd.dispose();
  //   AppCubit.get(context).QouteStyleAd.dispose();
    super.dispose();
  }
}

class pageView extends StatefulWidget {
  TypeOfQoutesModel qoutes;

  pageView(TypeOfQoutesModel this.qoutes, {Key? key}) : super(key: key);

  @override
  _pageViewState createState() => _pageViewState();
}

class _pageViewState extends State<pageView> {
  Future<bool> onLikeButtonTapped(bool isLiked) async{
    if(AppCubit.get(context).music==true)
    {
      final file = await AudioCache().loadAsFile('mixin.wav');
      final bytes = await file.readAsBytes();
      AudioCache().playBytes(bytes);
    }
    if(translator.activeLanguageCode!='ar')
    {
      if(AppCubit.get(context).IsFavoriteList.containsValue(widget.qoutes.Qoute))
      {
        AppCubit.get(context).deleteeDataForQuoteStylePage(qoute: widget.qoutes.Qoute);
      }
      else
      {
        AppCubit.get(context).insertToDatabaseForQuoteStyle(qoute: widget.qoutes.Qoute);

      }
    }
    if(translator.activeLanguageCode=='ar')
    {
      if(AppCubit.get(context).IsFavoriteList.containsValue(widget.qoutes.arabicQuote))
      {
        AppCubit.get(context).deleteeDataForQuoteStylePage(qoute: widget.qoutes.arabicQuote);
      }
      else
      {
        AppCubit.get(context).insertToDatabaseForQuoteStyle(qoute: widget.qoutes.arabicQuote);

      }
    }

    return !isLiked;
  }
  bool isLiked =false;
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppCubitStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          body:Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child:Container(
                      decoration:  BoxDecoration(image:  DecorationImage(fit: BoxFit.cover,image:AppCubit.get(context).isDark?AppCubit.get(context).PhotoessForDark[AppCubit.get(context).change]:AppCubit.get(context).Photoess[AppCubit.get(context).change])),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: ()
                        async {
                          /*
                          if(AppCubit.get(context).music==true)
                          {
                            final file = await AudioCache().loadAsFile('mix.wav');
                            final bytes = await file.readAsBytes();
                            AudioCache().playBytes(bytes);
                          }

                           */
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
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(flex: 2,
                                child: Container(height: 30.h,)),
                            Expanded(flex: 10,
                              child: Padding(
                                padding:  EdgeInsets.only(top: 30.sp,bottom: 30.sp,left: 10.sp,right: 10.sp),
                                child: Center(
                                  child: Text(
                                    translator.isDirectionRTL(context)?
                                    '${widget.qoutes.arabicQuote}':'${widget.qoutes.Qoute}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        height: AppCubit.get(context).GetDeviceTypeOfStyleScreen(),
                                        color: Colors.white,
                                        fontFamily:translator.isDirectionRTL(context)?AppCubit.get(context).ArabicFonts[AppCubit.get(context).changeArabicText]: AppCubit.get(context).Texts[AppCubit.get(context).changeText],
                                  //      fontSize: AppCubit.get(context).forChangeFontSize(context),
                                        fontSize: AppCubit.get(context).fntListSizes[AppCubit.get(context).fntSize],
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
                                            if(translator.activeLanguageCode!='ar')
                                            {
                                              final data = ClipboardData(text: widget.qoutes.Qoute.toString());
                                              Clipboard.setData(data);
                                              Fluttertoast.showToast(msg:'copy'.tr(),gravity: ToastGravity.CENTER);
                                            }
                                            if(translator.activeLanguageCode=='ar')
                                            {
                                              final data = ClipboardData(text: widget.qoutes.arabicQuote.toString());
                                              Clipboard.setData(data);
                                              Fluttertoast.showToast(msg:'copy'.tr(),gravity: ToastGravity.CENTER);
                                            }
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
                                            if(translator.activeLanguageCode!='ar')
                                            {
                                              Clipboard.setData(ClipboardData());
                                              Share.share('${widget.qoutes.Qoute.toString()}');
                                            }
                                            if(translator.activeLanguageCode=='ar')
                                            {
                                              Clipboard.setData(ClipboardData());
                                              Share.share('${widget.qoutes.arabicQuote.toString()}');
                                            }

                                          },
                                          padding: EdgeInsets.only(right: 1.5.sp),
                                          icon:Image(
                                            image: AssetImage(
                                              'assets/newImages/shareNW.png',
                                            ),
                                            height: 19.sp,color: Colors.white,
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
                                            translator.isDirectionRTL(context)==false?
                                            setState(() {
                                              AppCubit.get(context).ChangeText();
                                            }):setState(() {
                                              AppCubit.get(context).ChangeArabicText();
                                            });
                                          },
                                          padding: EdgeInsets.zero,
                                          icon: Padding(
                                            padding:  EdgeInsets.only(top: 2.sp),
                                            child: Image(fit: BoxFit.cover,color: Colors.white,
                                              alignment: AlignmentDirectional.center,
                                              height: 27.sp,
                                              image: const AssetImage('assets/newImages/font-size.png',),
                                            ),
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
                                      child: Padding(
                                        padding: EdgeInsets.only(right:translator.isDirectionRTL(context)? 2.sp:0),
                                        child: IconButton(
                                          onPressed: () {  },
                                          icon: LikeButton(
                                            padding: EdgeInsets.zero,
                                            size: translator.isDirectionRTL(context)?22.sp :22.sp,
                                            circleColor:
                                            const CircleColor(start: Colors.red, end: Colors.red),
                                            bubblesColor: BubblesColor(
                                              dotPrimaryColor:AppCubit.get(context).isDark?Colors.red:Colors.red,
                                              dotSecondaryColor: AppCubit.get(context).isDark?Colors.purple:Colors.purple,
                                              dotLastColor: AppCubit.get(context).isDark?Colors.orange:Colors.orange,
                                              dotThirdColor: AppCubit.get(context).isDark?Colors.red:Colors.red,
                                            ),
                                            onTap: onLikeButtonTapped,
                                            isLiked: isLiked,
                                            likeBuilder: ( isLiked) {
                                              return Padding(
                                                padding:  EdgeInsets.only(top: .4.sp,right: .2.sp),
                                                child:
                                                translator.isDirectionRTL(context)?
                                                Icon(
                                                  AppCubit.get(context).function(widget.qoutes.arabicQuote)? Icons.favorite_outline:Icons.favorite,
                                                  color:AppCubit.get(context).function(widget.qoutes.arabicQuote)? Colors.white : Colors.red,
                                                  size: translator.isDirectionRTL(context)?22.sp:24.sp,
                                                ):
                                                Icon(
                                                  AppCubit.get(context).function(widget.qoutes.Qoute)? Icons.favorite_outline:Icons.favorite,
                                                  color:AppCubit.get(context).function(widget.qoutes.Qoute)? Colors.white : Colors.red,
                                                  size: translator.isDirectionRTL(context)?22.sp:24.sp,
                                                ),
                                              );
                                            },
                                          ),
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
                                            final data = ClipboardData(text: widget.qoutes.Qoute.toString());
                                            Clipboard.setData(data);
                                            Fluttertoast.showToast(msg: 'copy'.tr(),gravity: ToastGravity.CENTER);
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
                                            Share.share('${widget.qoutes.Qoute.toString()}');
                                          },
                                          padding: EdgeInsets.zero,
                                          icon:  Image(
                                            image: AssetImage(
                                              'assets/newImages/shareNW.png',
                                            ),
                                            height: 19.sp,color: Colors.white,
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
                                          icon: Padding(
                                            padding:  EdgeInsets.only(top: 2.sp),
                                            child: Image(fit: BoxFit.cover,color: Colors.white,
                                              alignment: AlignmentDirectional.center,
                                              height: 25.sp,
                                              image: const AssetImage('assets/newImages/font-size.png',),
                                            ),
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
                                                AppCubit.get(context).function(widget.qoutes.Qoute)? Icons.favorite_outline:Icons.favorite,
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
                Positioned(
                  top: 5.5.h,left: 5.w,
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
                    }, icon: Icon(translator.isDirectionRTL(context)?IconBroken.Arrow___Right:IconBroken.Arrow___Left,size:20.sp),
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
                    }, icon: Icon(translator.isDirectionRTL(context)?IconBroken.Arrow___Right:IconBroken.Arrow___Left,size:18.sp),
                      splashColor: Colors.transparent,color: Colors.white,
                      highlightColor: Colors.transparent,

                    ),
                    height: 10.h,
                    width: 10.w,
                  ),
                ),
              Positioned(
                top: 5.5.h,right: 5.w,
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle,backgroundBlendMode: BlendMode.softLight,color: Colors.white),
                  child: IconButton(onPressed: () async {
                    if(AppCubit.get(context).music==true)
                    {
                      final file = await AudioCache().loadAsFile('mixin.wav');
                      final bytes = await file.readAsBytes();
                      AudioCache().playBytes(bytes);
                    }
                    setState(() {
                      AppCubit.get(context).changefntSizes();
                    });
                  }, icon: Image(image: AssetImage('assets/newImages/font.png',),color: Colors.white,height: 15.sp),
                    splashColor: Colors.transparent,color: Colors.white,
                    highlightColor: Colors.transparent,

                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

