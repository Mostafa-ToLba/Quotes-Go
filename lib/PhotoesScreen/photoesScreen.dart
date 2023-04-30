
 import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/FavoritePhotoes/favoritePhotoes.dart';
import 'package:statuses_only/HomeScreen/HomeScreen.dart';
import 'package:statuses_only/TypeOfPhotesScreen/TypeOfPhotesScreen.dart';
import 'package:statuses_only/favoriteScreen/favoriteScreen.dart';
import 'package:statuses_only/model/photoModel/photoModel.dart';
import 'package:statuses_only/openFavPhoto/openFavPhoto.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';

class PhotoScreen extends StatefulWidget {
   const PhotoScreen({Key? key}) : super(key: key);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
   List<Widget> buildAppBarActions(context) {
     if (AppCubit.get(context).isSearchingForPhotoes) {
       if (SizerUtil.deviceType == DeviceType.mobile)
         return [
           IconButton(
               splashColor: Colors.transparent,
               highlightColor: Colors.transparent,
               hoverColor: Colors.transparent,
               focusColor: Colors.transparent,
               disabledColor: Colors.transparent,
               onPressed: () async {
                 if (AppCubit.get(context).music == true) {
                   final file = await AudioCache().loadAsFile('mixin.wav');
                   final bytes = await file.readAsBytes();
                   AudioCache().playBytes(bytes);
                 }
                 clearSearch();
                 Navigator.pop(context);
               },
               padding: EdgeInsets.zero,
               icon: Icon(Icons.clear, color: Colors.white, size: 18.5.sp)),
         ];
       else
         return [
           Padding(
             padding: EdgeInsets.only(right: 4.w),
             child: IconButton(
                 splashColor: Colors.transparent,
                 highlightColor: Colors.transparent,
                 hoverColor: Colors.transparent,
                 focusColor: Colors.transparent,
                 disabledColor: Colors.transparent,
                 onPressed: () async {
                   if (AppCubit.get(context).music == true) {
                     final file = await AudioCache().loadAsFile('mixin.wav');
                     final bytes = await file.readAsBytes();
                     AudioCache().playBytes(bytes);
                   }
                   clearSearch();
                   Navigator.pop(context);
                 },
                 padding: EdgeInsets.zero,
                 icon: Icon(Icons.clear, color: Colors.white, size: 18.5.sp)),
           ),
         ];
     } else {
       if (SizerUtil.deviceType == DeviceType.mobile)
         return [
           IconButton(
               splashColor: Colors.transparent,
               highlightColor: Colors.transparent,
               hoverColor: Colors.transparent,
               focusColor: Colors.transparent,
               disabledColor: Colors.transparent,
               onPressed: () async {
                 if (AppCubit.get(context).music == true) {
                   final file = await AudioCache().loadAsFile('mixin.wav');
                   final bytes = await file.readAsBytes();
                   AudioCache().playBytes(bytes);
                 }
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) =>  FavoritePhotoes(),
                   ),
                 );
               },
               icon: Icon(
                 Icons.favorite,
                 size: 20.sp,
               ),
               padding: EdgeInsets.zero),
           IconButton(
             onPressed: startSearch,
             icon: Icon(
               Icons.search,
               size: 22.sp,
               color: Colors.white,
             ),
             padding: EdgeInsets.zero,
           ),
         ];
       else
         return [
           Padding(
             padding: EdgeInsets.only(right: 6.w),
             child: IconButton(
                 splashColor: Colors.transparent,
                 highlightColor: Colors.transparent,
                 hoverColor: Colors.transparent,
                 focusColor: Colors.transparent,
                 disabledColor: Colors.transparent,
                 onPressed: () async {
                   if (AppCubit.get(context).music == true) {
                     final file = await AudioCache().loadAsFile('mixin.wav');
                     final bytes = await file.readAsBytes();
                     AudioCache().playBytes(bytes);
                   }
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => const FavoriteScreen(),
                     ),
                   );
                 },
                 icon: Icon(
                   Icons.favorite,
                   size: 20.sp,
                 ),
                 padding: EdgeInsets.zero),
           ),
           Padding(
             padding: EdgeInsets.only(right: 4.w),
             child: IconButton(
               onPressed: startSearch,
               icon: Icon(
                 Icons.search,
                 size: 22.sp,
                 color: Colors.white,
               ),
               padding: EdgeInsets.zero,
             ),
           ),
         ];
     }
   }

   Widget SearchField() {
     return Container(
       width: 50.w,
       child: TextField(
         cursorHeight: 15.sp,
         controller: AppCubit.get(context).searchTextControllerForPhotoes,
         cursorColor: Colors.white,
         decoration: InputDecoration(
           hintText: 'Search...',
           border: InputBorder.none,
           hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14.sp),
         ),
         style: TextStyle(color: Colors.white, fontSize: 14.sp),
         onChanged: (searchedCharacter) {
           AppCubit.get(context).addSearchedFOrItemsToSearchedListForPhotoes(searchedCharacter);
         },
       ),
     );
   }

   void startSearch() async {
     if (AppCubit.get(context).music == true) {
       final file = await AudioCache().loadAsFile('mixin.wav');
       final bytes = await file.readAsBytes();
       AudioCache().playBytes(bytes);
     }
     ModalRoute.of(context)!
         .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
     setState(() {
       AppCubit.get(context).isSearchingForPhotoes = true;
     });
   }

   void stopSearching() async {
     clearSearch();
     setState(() {
       AppCubit.get(context).isSearchingForPhotoes = false;
     });
   }

   void clearSearch() async {
     setState(() {
       AppCubit.get(context).searchTextControllerForPhotoes.clear();
     });
   }
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
         return Scaffold(
           appBar: AppBar(
             leading: AppCubit.get(context).isSearchingForPhotoes
                 ? IconButton(
               icon: Icon(IconBroken.Arrow___Left, size: 18.sp),
               onPressed: () {
                 Navigator.pop(context);
               },
             )
                 : IconButton(
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
             toolbarHeight: 7.6.h,
             title:AppCubit.get(context).isSearchingForPhotoes
                 ? SearchField()
                 : Text('photos'.tr(),style: TextStyle(color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.w800,fontFamily:translator.activeLanguageCode=='ar'? 'ElMessiri':'VarelaRound',),),
             actions: buildAppBarActions(context),
           ),
           body: ConditionalBuilder(
             condition: AppCubit.get(context).Photoes!=0,
             builder: (BuildContext context) {
               return StreamBuilder<QuerySnapshot>(
                 stream: AppCubit.get(context).GetPhotoes(),
                 builder: (context, snapshot) {
                   if (!snapshot.hasData || snapshot.data!.size == 0) {
                     return const Center(child: CircularProgressIndicator());
                   } else {
                     AppCubit.get(context).Photoes = [];
                     List<String> Ids = [];
                     for (var doc in snapshot.data!.docs) {
                       AppCubit.get(context).Photoes.add(
                           photoModel(name: doc['name'],photo:doc['photo'],time: doc['time'],FranceName: doc['Fr'],arabicName: doc['Ar'],
                             EspaniaName: doc['Es'],deutchName: doc['De'],bngla: doc['Bn'],portogul: doc['Pt'],Chinese: doc['Zh'],
                             hindi: doc['Hi'],russia: doc['Ru'],
                           )
                       );
                       Ids.add(doc.id);

                     }
                     return Padding(
                         padding:  EdgeInsets.only(top:0.sp,bottom: 0.sp,right: 8.sp,left: 8.sp),
                         child: GridView(
                           gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1 / 1.4,
                           crossAxisSpacing: 10,
                           mainAxisSpacing: 0,),children:List.generate(AppCubit.get(context).searchTextControllerForPhotoes.text.isEmpty
                             ? AppCubit.get(context).Photoes.length : AppCubit.get(context).searchedForCharactersForPhotoes.length, (index)
                         {
                           if(translator.activeLanguageCode=='en'||translator.activeLanguageCode=='de'||translator.activeLanguageCode=='fr'
                           ||translator.activeLanguageCode=='es'||translator.activeLanguageCode=='bn'||translator.activeLanguageCode=='pt'
                               ||translator.activeLanguageCode=='zh'||translator.activeLanguageCode=='es'||translator.activeLanguageCode=='hi'
                               ||translator.activeLanguageCode=='ru')
                             {
                               return AppCubit.get(context).searchTextControllerForPhotoes.text.isEmpty ? PhotoItem(context,
                                 AppCubit.get(context).Photoes[index],
                                 Ids[index],
                               ) : PhotoItem(
                                 context,
                                 AppCubit.get(context).searchedForCharactersForPhotoes[index],
                                 Ids[index],
                               );
                             }
                           if(translator.activeLanguageCode=='ar')
                             {
                               return AppCubit.get(context).searchTextControllerForPhotoes.text.isEmpty ? ArabicItem(context,
                                 AppCubit.get(context).Photoes[index],
                                 Ids[index],
                               ) : ArabicItem(
                                 context,
                                 AppCubit.get(context).searchedForCharactersForPhotoes[index],
                                 Ids[index],
                               );
                             }
                           else return Text('data');
                         }  ),)
                     );
                   }
                 },
               );
             },
             fallback: (BuildContext context)=>const Center(child: CircularProgressIndicator()),
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
       },
     );
   }
}

 PhotoItem(context, photoModel photo, String id)=> InkWell(
   onTap: ()
   async {
     if(AppCubit.get(context).music==true)
     {
       final file = await AudioCache().loadAsFile('mixin.wav');
       final bytes = await file.readAsBytes();
       AudioCache().playBytes(bytes);
     }
     if (AppCubit.get(context).interstialadCountForPhotoesScreen == 3) {
       AppCubit.get(context).showInterstialAd();
     } else if (AppCubit.get(context).interstialadCountForPhotoesScreen == 0) {
       AppCubit.get(context).loadInterstialAd();
     }
     AppCubit.get(context).adCountForPhotoesScreen();
     Navigator.push(context, MaterialPageRoute(builder: (context)
     {
       if(translator.activeLanguageCode=='en')
         return TypeOfPhotoesScreen(id,photo.name!);
       if(translator.activeLanguageCode=='ar')
         return TypeOfPhotoesScreen(id,photo.arabicName!);
       if(translator.activeLanguageCode=='bn')
         return TypeOfPhotoesScreen(id,photo.bngla!);
       if(translator.activeLanguageCode=='de')
         return TypeOfPhotoesScreen(id,photo.deutchName!);
       if(translator.activeLanguageCode=='es')
         return TypeOfPhotoesScreen(id,photo.EspaniaName!);
       if(translator.activeLanguageCode=='fr')
         return TypeOfPhotoesScreen(id,photo.FranceName!);
       if(translator.activeLanguageCode=='hi')
         return TypeOfPhotoesScreen(id,photo.hindi!);
       if(translator.activeLanguageCode=='pt')
         return TypeOfPhotoesScreen(id,photo.portogul!);
       if(translator.activeLanguageCode=='ru')
         return TypeOfPhotoesScreen(id,photo.russia!);
       else return TypeOfPhotoesScreen(id,photo.Chinese!);
     }
       ),
     );
   },
   child: Padding(
     padding:  EdgeInsets.only(bottom: 5.sp,right: 2.sp,left: 2.sp,top: 5.sp),
     child: Container(
       height: 30.h,
       width: 40.w,
       decoration: BoxDecoration(color: AppCubit.get(context).isDark==false?Colors.blue:Colors.black,borderRadius: BorderRadius.circular(10),
         border: Border.all(
           color: AppCubit.get(context).isDark==false?Colors.white:Colors.white54,
           width:AppCubit.get(context).isDark? 1:0,
         ),
       ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Container(
             height: 21.h,width: double.infinity,clipBehavior:Clip.antiAliasWithSaveLayer,
             child: CachedNetworkImage(
                 imageUrl: photo.photo.toString(),
                 fit: BoxFit.cover,

                 /*
               imageBuilder:(BuildContext,ImageProvider )=>Container(decoration: BoxDecoration(
                   image:DecorationImage(image: NetworkImage(photo.photo.toString(),),fit: BoxFit.cover,)
                   ,borderRadius:BorderRadius.only(topRight:Radius.circular(7.sp),topLeft: Radius.circular(7.sp)) )) ,

                  */
                 placeholder:(BuildContext, String)=>Lottie.asset('assets/animation/imageLoading.json',) ),
             decoration: BoxDecoration(
                 borderRadius:BorderRadius.only(topRight:Radius.circular(7.sp),topLeft: Radius.circular(7.sp))
             ),
           ),
           if(translator.activeLanguageCode!='zh' && translator.activeLanguageCode!='ru')
             SizedBox(height: 1.5.h),
           if(translator.activeLanguageCode=='zh' || translator.activeLanguageCode=='ru')
             SizedBox(height: 1.h),
           if(translator.activeLanguageCode=='en')
           Center(child: Text(photo.name.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           if(translator.activeLanguageCode=='de')
             Center(child: Text(photo.deutchName.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           if(translator.activeLanguageCode=='es')
             Center(child: Text(photo.EspaniaName.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           if(translator.activeLanguageCode=='bn')
             Center(child: Text(photo.bngla.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           if(translator.activeLanguageCode=='fr')
             Center(child: Text(photo.FranceName.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           if(translator.activeLanguageCode=='hi')
             Center(child: Text(photo.hindi.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           if(translator.activeLanguageCode=='pt')
             Center(child: Text(photo.portogul.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           if(translator.activeLanguageCode=='ru')
             Center(child: Text(photo.russia.toString(),style: TextStyle(color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           if(translator.activeLanguageCode=='zh')
             Center(child: Text(photo.Chinese.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',),)),
           SizedBox(height: .7.h),
           StreamBuilder<QuerySnapshot>(
             stream: AppCubit.get(context).GetNumberOfPhotoesInList(id),
             builder: (context, snapshot) {
               if (!snapshot.hasData || snapshot.data!.size == 0) {
                 return Text(
                   '0 Photoes',
                   style: TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',),

                 );
               } else {
                 if(translator.activeLanguageCode=='en')
                   return  Text(
                   '${snapshot.data!.docs.length} Photoes',
                   style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                 );
                 if(translator.activeLanguageCode=='de')
                   return  Text(
                       '${snapshot.data!.docs.length} Fotos',
                       style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                   );
                 if(translator.activeLanguageCode=='fr')
                   return  Text(
                       '${snapshot.data!.docs.length} Photos',
                       style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                   );
                 if(translator.activeLanguageCode=='bn')
                   return  Text(
                       '${snapshot.data!.docs.length} ফটো',
                       style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                   );
                 if(translator.activeLanguageCode=='es')
                   return  Text(
                       '${snapshot.data!.docs.length} fotos',
                       style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                   );
                 if(translator.activeLanguageCode=='hi')
                   return  Text(
                       '${snapshot.data!.docs.length} तस्वीरें',
                       style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                   );
                 if(translator.activeLanguageCode=='pt')
                   return  Text(
                       '${snapshot.data!.docs.length} fotos',
                       style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                   );
                 if(translator.activeLanguageCode=='ru')
                   return  Text(
                       '${snapshot.data!.docs.length} фото',
                       style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                   );
                 if(translator.activeLanguageCode=='zh')
                   return  Text(
                       '${snapshot.data!.docs.length} 相片',
                       style:TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound',)
                   );
                 else
                    return Text('data');
               }
             },
           ),
      //     Text('6700 Photoes',style: TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w600,fontFamily: 'VarelaRound',),),
         ],
       ),
     ),
   ),
 );

 ArabicItem(context, photoModel photo, String id)=>InkWell(
   onTap: ()
   async {
     if(AppCubit.get(context).music==true)
     {
       final file = await AudioCache().loadAsFile('mixin.wav');
       final bytes = await file.readAsBytes();
       AudioCache().playBytes(bytes);
     }
     if (AppCubit.get(context).interstialadCountForPhotoesScreen == 3) {
       AppCubit.get(context).showInterstialAd();
     } else if (AppCubit.get(context).interstialadCountForPhotoesScreen == 0) {
       AppCubit.get(context).loadInterstialAd();
     }
     AppCubit.get(context).adCountForPhotoesScreen();
     Navigator.push(context, MaterialPageRoute(builder: (context)
     {
         return TypeOfPhotoesScreen(id,photo.arabicName!);
     }
     ),
     );
   },
   child: Padding(
     padding:  EdgeInsets.only(bottom: 5.sp,right: 2.sp,left: 2.sp,top: 5.sp),
     child: Container(
       height: 30.h,
       width: 40.w,
       decoration: BoxDecoration(color: AppCubit.get(context).isDark==false?Colors.blue:Colors.black,borderRadius: BorderRadius.circular(10),
         border: Border.all(
           color: AppCubit.get(context).isDark==false?Colors.white:Colors.white54,
           width:AppCubit.get(context).isDark? 1:0,
         ),
       ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Container(
             height: 21.h,width: double.infinity,clipBehavior:Clip.antiAliasWithSaveLayer,
             child: CachedNetworkImage(
                 imageUrl: photo.photo.toString(),
                 fit: BoxFit.cover,
                 placeholder:(BuildContext, String)=>Lottie.asset('assets/animation/imageLoading.json',) ),
             decoration: BoxDecoration(
                 borderRadius:BorderRadius.only(topRight:Radius.circular(7.sp),topLeft: Radius.circular(7.sp))
             ),
           ),
             SizedBox(height: .8.h,),
             Text(photo.arabicName.toString(),style: TextStyle(color: Colors.white,fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'ElMessiri',),),
           StreamBuilder<QuerySnapshot>(
             stream: AppCubit.get(context).GetNumberOfPhotoesInList(id),
             builder: (context, snapshot) {
               if (!snapshot.hasData || snapshot.data!.size == 0) {
                 return Text(
                   '0 صورة',
                   style: TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500,fontFamily: 'ElMessiri',),

                 );
               } else {
                 return Text(
                     '${snapshot.data!.docs.length} صورة',
                     style:TextStyle(color: Colors.white,fontSize: 13.sp,fontWeight: FontWeight.w500,fontFamily: 'ElMessiri',)
                 );
               }
             },
           ),
           //     Text('6700 Photoes',style: TextStyle(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w600,fontFamily: 'VarelaRound',),),
         ],
       ),
     ),
   ),
 );