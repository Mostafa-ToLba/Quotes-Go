
  import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/QouteScreen/QouteScreen.dart';
import 'package:statuses_only/QouteStyle/QouteStyle.dart';
import 'package:statuses_only/quoteStyleForFavoriteScreen/quoteStyleForFavScreen.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';

class FavoriteScreen extends StatefulWidget {
    const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: Platform.isAndroid ? 'ca-app-pub-6775155780565884/1588965913' : 'ca-app-pub-3940256099942544/2934735716',
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
   // AppCubit.get(context).myFavBanner..load();
    super.initState();
  }
    @override
    Widget build(BuildContext context) {
      return BlocConsumer<AppCubit,AppCubitStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 7.6.h,
              leadingWidth: 14.2.w,
              leading: IconButton(onPressed: () async {
                if(AppCubit.get(context).music==true)
                {
                  final file = await AudioCache().loadAsFile('mixin.wav');
                  final bytes = await file.readAsBytes();
                  AudioCache().playBytes(bytes);
                }
                Navigator.pop(context);
              }, icon: Icon(IconBroken.Arrow___Left,size:18.sp),),
              title:SizerUtil.deviceType==DeviceType.mobile?Text('Favorite',style: TextStyle(color: Colors.white,fontSize: 15.5.sp,fontWeight: FontWeight.w600,fontFamily: 'VarelaRound'))
                  :Padding(
                    padding:  EdgeInsets.only(left: 0),
                    child: Text('Favorite',style: TextStyle(color: Colors.white,fontSize: 15.5.sp,fontWeight: FontWeight.w600,fontFamily: 'VarelaRound')),
                  ),
            ),
            bottomNavigationBar:  _isBottomBannerAdLoaded
                ? Container(
              color: AppCubit.get(context).isDark
                  ? Colors.black
                  : Colors.white,
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
                : null,
            body: ConditionalBuilder(
              condition: AppCubit.get(context).FavoriteList.isNotEmpty,
              builder: (BuildContext context)=>ListView.separated(
                  itemBuilder: (context,index)=>BuilViewForQoute(AppCubit.get(context).FavoriteList[index],context,),
                  separatorBuilder: (context,index)=>Container(),
                  itemCount: AppCubit.get(context).FavoriteList.length),
              fallback: (BuildContext context)=>BuildNoFavorite(context)),
          );
        },
      );
    }

    @override
  void dispose() {
      _bottomBannerAd.dispose();
  //      AppCubit.get(context).myFavBanner.dispose();
    super.dispose();
  }
}


  Widget BuilViewForQoute(Map model,context)=>Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (DismissDirection)
    {
      AppCubit.get(context).deleteData(id: model['id']);
    },
    child: Padding(
      padding:  EdgeInsets.all(1.1.h),
      child: Container(
        //    width: double.infinity,
        //    height: 22.h,

        decoration: BoxDecoration(
          //  ${AppCubit.get(context).Images[AppCubit.get(context).change]}
          color: AppCubit.get(context).isDark==false?Colors.white:Colors.black,
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
              async {
                if(AppCubit.get(context).music==true)
                {
                  final file = await AudioCache().loadAsFile('mixin.wav');
                  final bytes = await file.readAsBytes();
                  AudioCache().playBytes(bytes);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuoteStyleForFav(model['qoute']),
                  ),
                );

              },
              child: Padding(
                padding:  EdgeInsets.all(4.h),
                child: Text(
                  '${model['qoute']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                 //     height: 1.2.sp,
                      height: AppCubit.get(context).GetDeviceType(),
                      fontSize: 24.6.sp,
                      fontFamily: 'Dongle',
                      color:AppCubit.get(context).isDark==false?Colors.grey[700]:Colors.white,
                      //     color: Colors.grey[700],
               //       fontSize: 14.3.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
                height: 7.h,
              width: double.infinity,
              color:AppCubit.get(context).isDark==false?Colors.grey[300]:Colors.grey[900],
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
                          final data = ClipboardData(text: '${model['qoute']}');
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
                    SizedBox(width: 4.w,),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 20.sp,
                        splashRadius: 26.sp,
                        onPressed: () async {
                          if(AppCubit.get(context).music==true)
                          {
                            final file = await AudioCache().loadAsFile('mixin.wav');
                            final bytes = await file.readAsBytes();
                            AudioCache().playBytes(bytes);
                          }
                          Share.share('${model['qoute']}');
                        },
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          MdiIcons.shareVariant,
                          color: Colors.blue,
                        )),
                    if(SizerUtil.deviceType==DeviceType.mobile)
                    SizedBox(width: .7.w,),
                    if(SizerUtil.deviceType==DeviceType.tablet)
                      SizedBox(width: 3.2.w,),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 20.sp,
                        splashRadius: 26.sp,
                        onPressed: ()
                        async {
                          if(AppCubit.get(context).music==true)
                          {
                            final file = await AudioCache().loadAsFile('mixin.wav');
                            final bytes = await file.readAsBytes();
                            AudioCache().playBytes(bytes);
                          }
                          AppCubit.get(context).deleteData(id:model['id']);
                        },
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete,
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

  Widget BuildNoFavorite(context)=> Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children:
        [
          Text('Hmmm!',style: TextStyle(color:AppCubit.get(context).isDark==false?Colors.black:Colors.white,fontSize: 42.sp,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound'),),
     //     SizedBox(height: 1.h,),
          Text('You don\'t have any favorites',style: TextStyle(color: AppCubit.get(context).isDark==false?Colors.black:Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w500,fontFamily: 'VarelaRound'),),
          SizedBox(height: .5.h,),
          Text('Please add your favorite quotes',style: TextStyle(color: Colors.grey,fontSize: 13.5.sp,fontWeight: FontWeight.w400,fontFamily: 'VarelaRound'),),
          Text('to save them here',style: TextStyle(color: Colors.grey,fontSize: 13.5.sp,fontWeight: FontWeight.w400,fontFamily: 'VarelaRound'),),
        ],
      ),
    ),
  );
