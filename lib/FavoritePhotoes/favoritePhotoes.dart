
 import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/PhotoesListScreen/photoesListScreen.dart';
import 'package:statuses_only/openFavPhoto/openFavPhoto.dart';

import '../shared/styles/icon_broken.dart';

class FavoritePhotoes extends StatefulWidget {
   const FavoritePhotoes({Key? key}) : super(key: key);

  @override
  State<FavoritePhotoes> createState() => _FavoritePhotoesState();
}

class _FavoritePhotoesState extends State<FavoritePhotoes> {
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
  @override
  void initState() {
    _createBottomBannerAd();
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
         title: Text('favorite'.tr(),style: TextStyle(color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.w800,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri': 'VarelaRound',),),
       ),
       body: ConditionalBuilder(
         condition: AppCubit.get(context).FavoriteImageList.length != 0,
         builder: (BuildContext context)=> Padding(
             padding:  EdgeInsets.all(2.sp),
             child: GridView(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1 / 1,
               crossAxisSpacing: 3,
               mainAxisSpacing: 3,),children:List.generate(AppCubit.get(context).FavoriteImageList.length, (index) =>  BuildPhotoes(AppCubit.get(context).FavoriteImageList[index],context),),)
         ),
         fallback: (BuildContext context)=>BuildNoFavorite(context),
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
 BuildPhotoes(Map<String, dynamic> favoriteImageList, BuildContext context)=>InkWell(
   onTap: ()
   async {
     if(AppCubit.get(context).music==true)
     {
       final file = await AudioCache().loadAsFile('mixin.wav');
       final bytes = await file.readAsBytes();
       AudioCache().playBytes(bytes);
     }
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
       builder:(context) => OpenFavPhoto(favoriteImageList['image']),
     ), (route) => true);
   },
   child: Stack(
     alignment: AlignmentDirectional.bottomEnd,
     children:
     [
       Container(
        padding: EdgeInsetsDirectional.zero,
         decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(favoriteImageList['image'])
           ,fit: BoxFit.cover,),borderRadius: BorderRadius.circular(8.sp),),
       ),
       InkWell(
         child: Padding(
           padding:  EdgeInsets.all(5.0.sp),
           child: Image.asset(
             'assets/images/bin.png',
             height: 19.sp,
             width: 19.sp,
             color: Colors.white,
           ),
         ),
         onTap: ()
         {
           AppCubit.get(context).deleteDataForImage(id: favoriteImageList['id']);
         },
       ),
     ],
   ),
 );
 Widget BuildNoFavorite(context)=> Center(
   child: Container(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisSize: MainAxisSize.max,
       children:
       [
         Text('Hmmm!',style: TextStyle(color:AppCubit.get(context).isDark==false?Colors.black:Colors.white,fontSize: 42.sp,fontWeight: FontWeight.bold,fontFamily:'VarelaRound'),),
         //     SizedBox(height: 1.h,),
         Text('noFavorite'.tr(),style: TextStyle(color: AppCubit.get(context).isDark==false?Colors.black:Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w500,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'),),
         SizedBox(height: .5.h,),
         translator.activeLanguageCode=='ru'?
         Container(
             width: 90.w,
             child: FittedBox(child: Text('addForPhotos'.tr(),style: TextStyle(color: Colors.grey,fontSize: 13.5.sp,fontWeight: FontWeight.w400,fontFamily: translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'),))):
         Text('addForPhotos'.tr(),style: TextStyle(color: Colors.grey,fontSize: 13.5.sp,fontWeight: FontWeight.w400,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'),),
         Text('save'.tr(),style: TextStyle(color: Colors.grey,fontSize: 13.5.sp,fontWeight: FontWeight.w400,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'),),
       ],
     ),
   ),
 );
