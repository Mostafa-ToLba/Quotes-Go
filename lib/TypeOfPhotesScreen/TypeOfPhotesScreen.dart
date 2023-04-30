
 import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/model/typeOfPhotoes/typeOfPhotoes.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';

import '../PhotoesListScreen/photoesListScreen.dart';

class TypeOfPhotoesScreen extends StatefulWidget {
  String id;

  String name;

    TypeOfPhotoesScreen(String this.id, String this.name, {Key? key}) : super(key: key);

  @override
  State<TypeOfPhotoesScreen> createState() => _TypeOfPhotoesScreenState();
}

class _TypeOfPhotoesScreenState extends State<TypeOfPhotoesScreen> {
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
     return BlocConsumer<AppCubit,AppCubitStates>(
       listener: (BuildContext context, state) {  },
       builder: (BuildContext context, Object? state) {
         return  Scaffold(
           appBar: AppBar(
             leadingWidth: 14.5.w,
             toolbarHeight: 7.6.h,
             leading:IconButton(
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
             titleSpacing: 0,
             title: Text(widget.name,style: TextStyle(color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.w800,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',),),
             actions: [
               IconButton(icon: Image(image:AppCubit.get(context).rowOrPieces==3?AssetImage('assets/newImages/pieces.png'):AssetImage('assets/newImages/row.png'),height: 16.sp,color: Colors.white),
               onPressed: () {
                 setState(() {
                   AppCubit.get(context).changeToRowOrPieces();
                 });
               },
               ),
             ],
           ),
           body: ConditionalBuilder(
             condition: AppCubit.get(context).photoesList!=0,
             builder: (BuildContext context) => Padding(
               padding:  EdgeInsets.all(2.sp),
               child: PaginateFirestore(
                 itemBuilder: (context, documentSnapshots, index)
                 {
                   AppCubit.get(context).photoesList = [];
                   for (var doc in documentSnapshots) {
                     AppCubit.get(context).photoesList.add(TypeOfPhotoesModel(photo: doc['photo'],));
                   }
                   return BuildPhotoes(context,AppCubit.get(context).photoesList[index],index,widget.id);
                 }, // orderBy is compulsary to enable pagination
                 query: AppCubit.get(context).GetPhotoesFromTypeOfQoutesForPagination(widget.id),
                 itemBuilderType: PaginateBuilderType.gridView,
                 scrollDirection: Axis.vertical,
                 itemsPerPage:16,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: AppCubit.get(context).rowOrPieces, childAspectRatio:AppCubit.get(context).rowOrPieces==3?1/1:1 / 1.3,
                   crossAxisSpacing: 3,
                   mainAxisSpacing: 3,),
                 shrinkWrap: false,
                 bottomLoader:Text(''),
                 isLive: true,initialLoader: Center(child: const CircularProgressIndicator()),onEmpty: Center(
                 child: Text(
                   'No Photoes',
                   style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w600,fontFamily: 'VarelaRound',),

                 ),
               ),
               ),
             ),
             fallback: (BuildContext context)=>Center(child: const CircularProgressIndicator()),
           ),
           /*
           Padding(
               padding:  EdgeInsets.all(2.sp),
               child: GridView(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1 / 1,
                 crossAxisSpacing: 3,
                 mainAxisSpacing: 3,),children:List.generate(20, (index) =>  BuildPhotoes(context),),)
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
         );
       },
     );
   }
}

 BuildPhotoes(context, TypeOfPhotoesModel photoesList, int index, String idOfPhotoDoc)=>InkWell(
   onTap: ()
   async {
     if(AppCubit.get(context).music==true)
     {
       final file = await AudioCache().loadAsFile('mixin.wav');
       final bytes = await file.readAsBytes();
       AudioCache().playBytes(bytes);
     }
     if(AppCubit.get(context).interstialadCountForPhotoes==3)
     {
       AppCubit.get(context).showInterstialAd();
     }
     else if(AppCubit.get(context).interstialadCountForPhotoes==0) {
       AppCubit.get(context).loadInterstialAd();
     }
     AppCubit.get(context).adCountForPhotoes();
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
       builder:(context) => PhotoesListScreen(photoesList.photo!,index,idOfPhotoDoc),
     ), (route) => true);
   },
   child: Padding(
     padding: AppCubit.get(context).rowOrPieces==3?EdgeInsets.only(top: 0.sp,left: 0.sp,right: 0.sp):EdgeInsets.only(top: 8.sp,left: 12.sp,right: 12.sp),
     child: Container(
       height: 15.h,
       width: 30.w,
       decoration: BoxDecoration(borderRadius:AppCubit.get(context).rowOrPieces==3?BorderRadius.circular(8.sp):BorderRadius.circular(15.sp),),
       clipBehavior:Clip.antiAliasWithSaveLayer,
       child: AppCubit.get(context).rowOrPieces==3?CachedNetworkImage(
           imageUrl: photoesList.photo.toString(),fit: BoxFit.cover,
           /*
           imageBuilder:(BuildContext,ImageProvider )=>Container(decoration: BoxDecoration(image:DecorationImage(
             image: NetworkImage(photoesList.photo.toString())
             ,fit: BoxFit.cover,) ,borderRadius:BorderRadius.circular(8.sp), )) ,

            */
           placeholder:(BuildContext, String)=>Lottie.asset('assets/animation/imageLoading.json',) ):
       CachedNetworkImage(
           imageUrl: photoesList.photo.toString(),fit: BoxFit.cover,
           /*
           imageBuilder:(BuildContext,ImageProvider )=>Padding(
             padding: EdgeInsets.only(top: 8.sp,left: 12.sp,right: 12.sp),
             child: Container(clipBehavior: Clip.antiAliasWithSaveLayer,
                 decoration: BoxDecoration(
                   image:DecorationImage(
               image: NetworkImage(photoesList.photo.toString()),
               fit: BoxFit.cover,) ,borderRadius:BorderRadius.circular(15.sp),)),
           ) ,

            */
           placeholder:(BuildContext, String)=>Lottie.asset('assets/animation/imageLoading.json',) ),
     ),
   ),
 );