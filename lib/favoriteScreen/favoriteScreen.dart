
  import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:instagram_share/instagram_share.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
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
      adUnitId: Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716',
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
              titleSpacing: 0,
              leading: IconButton(onPressed: () async {
                if(AppCubit.get(context).music==true)
                {
                  final file = await AudioCache().loadAsFile('mixin.wav');
                  final bytes = await file.readAsBytes();
                  AudioCache().playBytes(bytes);
                }
                Navigator.pop(context);
              }, icon: Icon(translator.isDirectionRTL(context)?IconBroken.Arrow___Right:IconBroken.Arrow___Left,size:18.sp),),
              title:SizerUtil.deviceType==DeviceType.mobile?Text('favorite'.tr(),style: TextStyle(color: Colors.white,fontSize: 15.5.sp,fontWeight: FontWeight.w600,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'))
                  :Padding(
                    padding:  EdgeInsets.only(left: 0),
                    child: Text('favorite'.tr(),style: TextStyle(color: Colors.white,fontSize: 15.5.sp,fontWeight: FontWeight.w600,fontFamily: translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound')),
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
        decoration: BoxDecoration(
          //  ${AppCubit.get(context).Images[AppCubit.get(context).change]}
          color: AppCubit.get(context).isDark==false?Colors.white:Colors.black,
          border: Border.all(
            color: AppCubit.get(context).isDark==false?Colors.grey[300]!:Colors.white54,
            width: 1,
          ),
          /*
          boxShadow: [
            BoxShadow(
          //    offset: const Offset(0, .2),
              blurRadius: .5,blurStyle: BlurStyle.solid,
              color: AppCubit.get(context).isDark==false?Colors.black.withOpacity(0.3):Colors.white,
            ),
          ],

           */
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
                child:  translator.activeLanguageCode!='ar'?
                Text(
                  '${model['qoute']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //      height: 1.2.sp,
                      height:AppCubit.get(context).GetDeviceType(),
                      color: AppCubit.get(context).isDark==false?Colors.grey[700]:Colors.white,
                      fontFamily:'Dongle',
                      //    fontSize: 14.3.sp,
                      fontSize: 24.5.sp,
                      fontWeight: FontWeight.w600),
                ): Text(
                  '${model['qoute']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //      height: 1.2.sp,
                      height:1.1.sp,
                      color: AppCubit.get(context).isDark==false?Colors.grey[700]:Colors.white,
                      fontFamily:'ElMessiri',
                      //    fontSize: 14.3.sp,
                      fontSize: 16.sp,

                      fontWeight: FontWeight.w600),
                ),
                /*
                Text(
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

                 */
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
                height: 7.h,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1.1.h),bottomRight:Radius.circular(1.1.h)),color: AppCubit.get(context).isDark==false?Colors.blue:Colors.grey[900],),
              alignment: Alignment.center,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: ()
                        async {
                          if(AppCubit.get(context).music==true)
                          {
                            final file = await AudioCache().loadAsFile('mixin.wav');
                            final bytes = await file.readAsBytes();
                            AudioCache().playBytes(bytes);
                          }
                          InstagramShare.share('${model['qoute']}', 'image');
                        },
                        icon: AppCubit.get(context).isDark?Image(
                          image: AssetImage(
                            'assets/images/instagramColored.png',
                          ),
                          height: 23.sp,
                        ):Image(
                          image: AssetImage(
                            'assets/images/instagram3.png',
                          ),color: Colors.white,
                          height: 23.sp,
                        ),iconSize: 25.sp),
                    if(SizerUtil.deviceType==DeviceType.mobile)
                      SizedBox(width:3.w,),
                    if(SizerUtil.deviceType==DeviceType.tablet)
                      SizedBox(width:4.w,),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () async {
                          if(AppCubit.get(context).music==true)
                          {
                            final file = await AudioCache().loadAsFile('mixin.wav');
                            final bytes = await file.readAsBytes();
                            AudioCache().playBytes(bytes);
                          }
                          shareWhatsapp.shareText('${model['qoute']}');
                        },
                        icon: Image(
                          image: AssetImage(
                            'assets/images/whatsapp3.png',
                          ),
                          height: 23.sp,color: AppCubit.get(context).isDark?HexColor('#25D366'):Colors.white,
                        ),iconSize:25.sp),
                    if(SizerUtil.deviceType==DeviceType.mobile)
                      SizedBox(width:1.w,),
                    if(SizerUtil.deviceType==DeviceType.tablet)
                      SizedBox(width:4.w,),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 25.sp,
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
                        icon:Icon(
                          Icons.delete,
                          color: AppCubit.get(context).isDark?Colors.red:Colors.white,
                        )),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 23.sp,
                        splashRadius: 26.sp,
                        onPressed: () async{
                          if(AppCubit.get(context).music==true)
                          {
                            final file = await AudioCache().loadAsFile('mixin.wav');
                            final bytes = await file.readAsBytes();
                            AudioCache().playBytes(bytes);
                          }
                          Clipboard.setData(ClipboardData());
                          Share.share('${model['qoute']}',);
                        },
                        padding: EdgeInsets.zero,
                        icon:Image(
                          image: AssetImage(
                            'assets/newImages/shareNW.png',
                          ),
                          height: 20.sp,color: AppCubit.get(context).isDark?HexColor('#d9c82b'):Colors.white,
                        )),
                    if(SizerUtil.deviceType==DeviceType.mobile)
                    SizedBox(width: 1.w,),
                    if(SizerUtil.deviceType==DeviceType.tablet)
                      SizedBox(width: 3.2.w,),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 23.sp,
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
                        icon:  Icon(
                          MdiIcons.contentCopy,
                          color: AppCubit.get(context).isDark?Colors.blue:Colors.white,
                        )),
                    Expanded(child: Container()),
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
          Text('Hmmm!',style: TextStyle(color:AppCubit.get(context).isDark==false?Colors.black:Colors.white,fontSize: 42.sp,fontWeight: FontWeight.bold,fontFamily:'VarelaRound'),),
     //     SizedBox(height: 1.h,),
          Text('noFavorite'.tr(),style: TextStyle(color: AppCubit.get(context).isDark==false?Colors.black:Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w500,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'),),
          SizedBox(height: .5.h,),
          translator.activeLanguageCode=='ru'?
          Container(
              width: 90.w,
              child: FittedBox(child: Text('addForQuotes'.tr(),style: TextStyle(color: Colors.grey,fontSize: 13.5.sp,fontWeight: FontWeight.w400,fontFamily: translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'),))):
          Text('addForQuotes'.tr(),style: TextStyle(color: Colors.grey,fontSize: 13.5.sp,fontWeight: FontWeight.w400,fontFamily: translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'),),
          Text('save'.tr(),style: TextStyle(color: Colors.grey,fontSize: 13.5.sp,fontWeight: FontWeight.w400,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound'),),
        ],
      ),
    ),
  );
