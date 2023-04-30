
 import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/FavoritePhotoes/favoritePhotoes.dart';
import 'package:statuses_only/HomeScreen/HomeScreen.dart';
import 'package:statuses_only/PhotoesScreen/photoesScreen.dart';
import 'package:statuses_only/favoriteScreen/favoriteScreen.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';

class FavoriteListScreen extends StatefulWidget {
   const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
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
  late BannerAd _inlineBannerAd;
  bool _isInlineBannerAdLoaded = false;
  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: Platform.isAndroid?'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-3940256099942544/2934735716',
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
  @override
  void initState() {
    _createBottomBannerAd();
    _createInlineBannerAd();
    //  AppCubit.get(context).myBanner.load();
    super.initState();
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         titleSpacing: 0,
         leadingWidth: 14.5.w,
         toolbarHeight: 7.6.h,
         leading: IconButton(
           icon:  Icon(
             translator.isDirectionRTL(context)?IconBroken.Arrow___Right:IconBroken.Arrow___Left,
             color: Colors.white,
             size: 20.sp,
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
         title: Text('favorite'.tr(),style: TextStyle(color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.w800,fontFamily:translator.activeLanguageCode=='ar'? 'ElMessiri':'VarelaRound',),),
       ),
       body: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children:
         [
           SizedBox(height: 2.h),
           _isInlineBannerAdLoaded?Container(
             padding: EdgeInsets.only(
               bottom: 0,
             ),
             width: _inlineBannerAd.size.width.toDouble(),
             height: _inlineBannerAd.size.height.toDouble(),
             child: AdWidget(ad: _inlineBannerAd),
           ):Container(height: 12.5.h),
           SizedBox(height: 15.h,),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children:
             [
               InkWell(
                 onTap: ()
                 async {
                   if(AppCubit.get(context).music==true)
                   {
                     final file = await AudioCache().loadAsFile('mixin.wav');
                     final bytes = await file.readAsBytes();
                     AudioCache().playBytes(bytes);
                   }
                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                     builder:(context) => FavoriteScreen(),
                   ), (route) => true);
                 },
                 child: Container(
                   height: 28.h,
                   width: 38.w,
                   decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10),gradient:LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors:AppCubit.get(context).isDark==false?[HexColor('#2e7ee6'),HexColor('#2592f1')]:[Colors.black, Colors.black],
                   ),
                     border: Border.all(
                       color: AppCubit.get(context).isDark==false?Colors.black.withOpacity(0.0):Colors.white54,
                       width: 1,
                     ),
                     /*
                     boxShadow: [
                       BoxShadow(
                         offset: const Offset(0, .2),
                         blurRadius: 1,
                         color: AppCubit.get(context).isDark==false?Colors.black.withOpacity(0.3):Colors.white,
                       ),
                     ],

                      */

                   ),
                   child: Center(child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       CircleAvatar(backgroundColor: Colors.white,radius: 28.sp,
                         child: Padding(
                           padding: EdgeInsets.only(left: 1.sp,top: 4.sp),
                           child: Image(image: AssetImage('assets/images/quotation1.png',),height: 33.sp,color: Colors.blue,),
                         ),),
                       SizedBox(height: 1.h),
                       Text('quotes'.tr(),style: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold,fontFamily: translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound',),),
                     ],
                   )),
                 ),
               ),
               SizedBox(width: 5.w,),
               InkWell(
                 onTap: ()
                 async {
                   if(AppCubit.get(context).music==true)
                   {
                     final file = await AudioCache().loadAsFile('mixin.wav');
                     final bytes = await file.readAsBytes();
                     AudioCache().playBytes(bytes);
                   }
                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                     builder:(context) => FavoritePhotoes(),
                   ), (route) => true);
                 },
                 child: Container(
                   height: 28.h,
                   width: 38.w,
                   decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10),gradient:LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors:AppCubit.get(context).isDark==false?[HexColor('#2e7ee6'),HexColor('#2592f1')]:[Colors.black, Colors.black],
                   ),
                     border: Border.all(
                       color: AppCubit.get(context).isDark==false?Colors.black.withOpacity(0.0):Colors.white54,
                       width: 1,
                     ),
                    /*
                     boxShadow: [
                       BoxShadow(
                         offset: const Offset(0, .2),
                         blurRadius: 1,
                         color: AppCubit.get(context).isDark==false?Colors.black.withOpacity(0.3):Colors.white,
                       ),
                     ],

                     */
                   ),
                   child: Center(child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       CircleAvatar(backgroundColor: Colors.white,radius: 28.sp,
                         child: Image(image: AssetImage('assets/images/image.png',),height: 33.sp,color: Colors.blue,),),
                       SizedBox(height: 1.h),
                       Text('photos'.tr(),style: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound',),),
                     ],
                   )),
                 ),
               ),
             ],
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
     );
   }
}
