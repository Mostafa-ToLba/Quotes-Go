
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/FavoriteListScreen/favoriteListScreen.dart';
import 'package:statuses_only/HomeScreen/HomeScreen.dart';
import 'package:statuses_only/PhotoesScreen/photoesScreen.dart';
import 'package:statuses_only/make/makeQuoteScreen.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstScreen extends StatefulWidget {
    FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}
 var scaffoldkey = GlobalKey<ScaffoldState>();
 final Uri _url = Uri.parse('https://sites.google.com/view/quotesgo?fbclid=IwAR0bJhM91EB_v-GMhM1zueXmTvYhalob2kSMTAGpjw_zoCqtBIWWEpiKGtU');

  _launchUrl() async {
   if (!await launchUrl(_url)) throw 'Could not launch $_url';
 }



 final Uri _urlll = Uri.parse('mailto:VidlodApp@Gmail.com?subject=${Uri.encodeFull('Statuses Contact')}&body=Send us a message we are happy to hear from you :)');
 void _launchUrlll() async {
   if (!await launchUrl(_urlll)) throw 'Could not launch $_urlll';
 }

 final Uri _urlForRateUs = Uri.parse('https://play.google.com/store/apps/details?id=com.statuses_only.statuses_only');
 void _launchUrlForRateUsAndGooglePlay() async {
   if (!await launchUrl(_urlForRateUs,mode: LaunchMode.externalApplication)) throw 'Could not launch $_urlForRateUs';
 }
class _FirstScreenState extends State<FirstScreen> {
   late BannerAd _bottomBannerAd;
   bool _isBottomBannerAdLoaded = false;
   void _createBottomBannerAd() {
     _bottomBannerAd = BannerAd(
       adUnitId: Platform.isAndroid
           ? 'ca-app-pub-3940256099942544/6300978111'
           : 'ca-app-pub-3940256099942544/6300978111',
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
/*
   RateMyApp rateMyApp = RateMyApp(
     preferencesPrefix: 'rateMyApp_',
     minDays: 7,
     minLaunches: 7,
     remindDays: 6,
     remindLaunches: 8,
     googlePlayIdentifier: 'com.statuses_only.statuses_only',
   );

 */

   @override
   void initState() {
     AppCubit.get(context).oppenAppLoaded==true?AppCubit.get(context).appOpenAd.show():null;
     _createBottomBannerAd();
     _createInlineBannerAd();
     /*
     rateMyApp.init().then((value)
     {
       Timer(Duration(minutes: 30),()
       {
         rateMyApp.showStarRateDialog(
           context,
           title: 'Rate Quotes Go app', // The dialog title.
           message: 'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
           // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
           actionsBuilder: (context, stars) { // Triggered when the user updates the star rating.
             return [ // Return a list of actions (that will be shown at the bottom of the dialog).
               Center(
                 child: Container(
                     height: 20.h,
                     width: 50.w,
                     child: Lottie.asset('assets/animation/star.json',height: 12.h,width: 13.w),),
               ),
               SizedBox(height: 1.h),
               Center(child: Text('Hope your 5 star rating',style:TextStyle(fontSize: 13.sp,color: Colors.blue),)),
               SizedBox(height: 3.h,),
               Center(
                 child: Material(color: Colors.blue,
                   shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.sp) ),
                   clipBehavior: Clip.antiAlias,
                   child: MaterialButton(
                     minWidth: 60.w,clipBehavior: Clip.antiAliasWithSaveLayer,
                     height: 5.5.h,
                     color: Colors.blue,
                     child:Text('Rate Us Now',style: TextStyle(fontSize: 15.sp,color: Colors.white,),),
                     onPressed:stars==0? null: () async {
                       print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
                       // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                       // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                         _launchUrlForRateUsAndGooglePlay();
                       await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                       Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                     },
                   ),
                 ),
               ),
               SizedBox(height: 3.h,),
             ];
           },
           ignoreNativeDialog: Platform.isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
           dialogStyle:  DialogStyle(
             // Custom dialog styles.
             dialogShape:  RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(10.sp))),
             titleAlign: TextAlign.center,
             messageAlign: TextAlign.center,messageStyle:TextStyle(color: Colors.black) ,titleStyle: TextStyle(color: Colors.black,fontSize: 13.sp),
             messagePadding: EdgeInsets.only(bottom: 17.sp,),
           ),
           starRatingOptions: const StarRatingOptions(), // Custom star bar rating options.
           onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
         );

       });

     });

      */
     super.initState();
   }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<AppCubit,AppCubitStates>(
       listener: (BuildContext context, state) {  },
       builder: (BuildContext context, Object? state)=>Scaffold(
         key: scaffoldkey,
         appBar: AppBar(
           leadingWidth:translator.isDirectionRTL(context)?  12.w:null,
           leading: Padding(
             padding: EdgeInsets.only(left:translator.isDirectionRTL(context)? 0.w:5.w, top: 2.sp,right:translator.isDirectionRTL(context)? 3.w:0),
             child: InkWell(
                 onTap: () async {
                   if (AppCubit.get(context).music == true) {
                     final file =
                     await AudioCache().loadAsFile('mixin.wav');
                     final bytes = await file.readAsBytes();
                     AudioCache().playBytes(bytes);
                   }
                   scaffoldkey.currentState!.openDrawer();
                 },
                 child:  Image(
                   image: AssetImage('assets/images/tabBar.png'),
                 )),
           ),
           title: Padding(
             padding: EdgeInsets.only(left:translator.isDirectionRTL(context)? 5.w :10.w,right:translator.isDirectionRTL(context)? 12.w:0,top: .3.h),
             child: Image(
               image: const AssetImage('assets/newImages/quomxName.png',),
               //const AssetImage('assets/images/QuotesGo.png',),
               height: 30.sp,
             ),
           ),
           actions:
           [
             InkWell(
               highlightColor: Colors.transparent,
               splashColor: Colors.transparent,
               child: Image.asset(
                 AppCubit.get(context).isDark?'assets/images/nightt.png':'assets/images/brightness.png',
                 height: 12.sp,
                 width: 6.8.w,
                 color: Colors.white,
               ),
               onTap: () async {
                 if (AppCubit.get(context).music == true) {
                   final file = await AudioCache().loadAsFile('mixin.wav');
                   final bytes = await file.readAsBytes();
                   AudioCache().playBytes(bytes);
                 }
                 AppCubit.get(context).MakeItDark();
                 if (AppCubit.get(context).isDark)
                   SystemChrome.setSystemUIOverlayStyle(
                       SystemUiOverlayStyle(
                         systemNavigationBarColor: Colors.black,
                         systemNavigationBarDividerColor: Colors.black,
                         systemNavigationBarIconBrightness: Brightness.light,
                       ));
                 else
                   SystemChrome.setSystemUIOverlayStyle(
                       SystemUiOverlayStyle(
                         systemNavigationBarColor: Colors.white,
                         systemNavigationBarDividerColor: Colors.white,
                         systemNavigationBarIconBrightness: Brightness.dark,
                       ));
               },
             ),
             SizedBox(width: 1.w,),
             /*
             InkWell(
               highlightColor: Colors.transparent,
               splashColor: Colors.transparent,
               child: Image.asset(
                 AppCubit.get(context).music?'assets/images/music.png':'assets/images/musicOff2.png',
                 width: 6.w,
                 color: Colors.white,
               ),
               onTap: () async{
                 if (AppCubit.get(context).music == false) {
                   final file = await AudioCache().loadAsFile('mixin.wav');
                   final bytes = await file.readAsBytes();
                   AudioCache().playBytes(bytes);
                 }
                 AppCubit.get(context).MakeItSound();
                 /*
                 if (AppCubit.get(context).isDark)
                   SystemChrome.setSystemUIOverlayStyle(
                       SystemUiOverlayStyle(
                         systemNavigationBarColor: Colors.black,
                         systemNavigationBarDividerColor: Colors.black,
                         systemNavigationBarIconBrightness: Brightness.light,
                       ));
                 else
                   SystemChrome.setSystemUIOverlayStyle(
                       SystemUiOverlayStyle(
                         systemNavigationBarColor: Colors.white,
                         systemNavigationBarDividerColor: Colors.white,
                         systemNavigationBarIconBrightness: Brightness.dark,
                       ));

                  */
               },
             ),

              */
             IconButton(onPressed: ()
             {
               AppCubit.get(context).ShowDialogForLanguage(context);

             }, icon: Image(image: AssetImage('assets/images/google.png',),width: 6.w,height: 25.sp,color: Colors.white),iconSize: 1.sp),
             SizedBox(width: 1.w,),
           ],
         ),
         drawer: Drawer(
           width: 78.w,
           child: Container(
             height: 100.h,
             //     color: Colors.white,
             decoration: BoxDecoration(
                 gradient: LinearGradient(
                   begin: Alignment.topRight,
                   end: Alignment.bottomLeft,
                   colors: AppCubit.get(context).isDark == false
                       ? [HexColor('#29b6f6'), HexColor('#01058f')]
                       : [Colors.black, Colors.black],
                 )),
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   if (SizerUtil.deviceType == DeviceType.mobile)
                     SizedBox(
               //        height: 10.h,
                       height: 7.h,
                     ),
                   if (SizerUtil.deviceType == DeviceType.tablet)
                     SizedBox(
                       height: 3.h,
                     ),
                   Center(
                     child: Container(
                       height: 25.h,
                       //height :22.h
                       child:  Image(
                         image:
                         //AssetImage('assets/images/LogoWithoutBackground.png'),
                         AssetImage('assets/newImages/quomxSplash.png',),

                       ),
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(bottom: 2.7.h,right: 2.7.h,top: 3.h,left: 2.5.h),
                     child: Row(
                       children: [
                         Image(
                           fit: BoxFit.cover,
                           color: Colors.white,
                           alignment: AlignmentDirectional.center,
                           height: 21.sp,
                           image: const AssetImage('assets/newImages/volumeNew.png'),
                         ),
                          SizedBox(
                           width: translator.isDirectionRTL(context)?9.sp:4.sp,
                         ),
                         Container(
                           width: 40.w,
                           child: Text(
                             'tap sound'.tr(),
                             style: TextStyle(
                                 fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                 fontSize: 16.sp,
                                 color: Colors.white,
                                 fontWeight: FontWeight.w800),
                           ),
                         ),
                         const Spacer(),
                         SwitcherButton(
                           offColor: AppCubit.get(context).isDark == false
                               ? HexColor('#073eab')
                               : Colors.grey,
                           size: 37.sp,
                           value: AppCubit.get(context).music,
                           onChange: (value) async {
                             if (AppCubit.get(context).music == false) {
                               final file =
                               await AudioCache().loadAsFile('mixin.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             AppCubit.get(context).MakeItSound();
                           },
                         ),
                       ],
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 2.h, right: 2.7.h,),
                     child: Row(
                       children: [
                         Image(
                           fit: BoxFit.cover,
                           color: Colors.white,
                           alignment: AlignmentDirectional.center,
                           height: 24.sp,
                           image: const AssetImage('assets/newImages/dayAndNight.png',),
                         ),
                          SizedBox(
                           width: 8.sp,
                         ),
                         Container(
                           width: 40.w,
                           child: Text(
                             'dark mode'.tr(),
                             style: TextStyle(
                                 fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                 fontSize: 16.sp,
                                 color: Colors.white,
                                 fontWeight: FontWeight.w800),
                           ),
                         ),
                         const Spacer(),
                         Padding(
                           padding: translator.isDirectionRTL(context)?EdgeInsets.only(left: 3.sp):EdgeInsets.only(left: 0.sp),
                           child: SwitcherButton(
                             size: 37.sp,
                             offColor: AppCubit.get(context).isDark == false
                                 ? HexColor('#073eab')
                                 : Colors.grey,
                             value: AppCubit.get(context).isDark,
                             onChange: (value) async {
                               if (AppCubit.get(context).music == true) {
                                 final file =
                                 await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               AppCubit.get(context).MakeItDark();
                               if (AppCubit.get(context).isDark)
                                 SystemChrome.setSystemUIOverlayStyle(
                                     SystemUiOverlayStyle(
                                       systemNavigationBarColor: Colors.black,
                                       systemNavigationBarDividerColor:
                                       Colors.black,
                                       systemNavigationBarIconBrightness:
                                       Brightness.light,
                                     ));
                               else
                                 SystemChrome.setSystemUIOverlayStyle(
                                     SystemUiOverlayStyle(
                                       systemNavigationBarColor: Colors.white,
                                       systemNavigationBarDividerColor:
                                       Colors.white,
                                       systemNavigationBarIconBrightness:
                                       Brightness.dark,
                                     ));
                             },
                           ),
                         ),
                       ],
                     ),
                   ),
                   /*
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () async{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavoriteScreen(),
                                  ),
                                );
                                if(AppCubit.get(context).music==true)
                                {
                                  final file = await AudioCache().loadAsFile('mixin.wav');
                                  final bytes = await file.readAsBytes();
                                  AudioCache().playBytes(bytes);
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    IconBroken.Heart,
                                    size: 25.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Liked Quotes',
                                    style: TextStyle(
                                        fontFamily: 'Forum',
                                        fontSize: 17.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )),
                        ),
                      ),

                       */
                   SizedBox(
                     height: 2.2.h,
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 2.h,right:translator.isDirectionRTL(context)==true? 2.7.h:0.h),
                     child: Material(
                       color: Colors.transparent,
                       child: InkWell(
                           onTap: () async {
                             if (AppCubit.get(context).music == true) {
                               final file =
                               await AudioCache().loadAsFile('mixin.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             Share.share('https://play.google.com/store/apps/details?id=com.statuses_only.statuses_only');
                           },
                           child: Row(
                             children: [
                               Image(
                                 fit: BoxFit.cover,
                                 color: Colors.white,
                                 alignment: AlignmentDirectional.center,
                                 height: 25.sp,
                                 image: const AssetImage('assets/newImages/shareNew.png',),
                               ),
                                SizedBox(
                                 width: 7.sp,
                               ),
                               Container(
                                 width:translator.isDirectionRTL(context)==false? 60.w:40.w,
                                 child: Text(
                                   'share app'.tr(),
                                   style: TextStyle(
                                       fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                       fontSize: 16.sp,
                                       color: Colors.white,
                                       fontWeight: FontWeight.w800),
                                 ),
                               )
                             ],
                           )),
                     ),
                   ),
                   SizedBox(
                     height: 2.2.h,
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 2.3.h,right:translator.isDirectionRTL(context)==true? 2.7.h:0.h),
                     child: Material(
                       color: Colors.transparent,
                       child: InkWell(
                           onTap: () async {
                             if (AppCubit.get(context).music == true) {
                               final file =
                               await AudioCache().loadAsFile('mixin.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             _launchUrlll();
                           },
                           child: Row(
                             children: [
                               Image(
                                 fit: BoxFit.cover,
                                 color: Colors.white,
                                 alignment: AlignmentDirectional.center,
                                 height: 20.sp,
                                 image: const AssetImage('assets/newImages/phoneNew.png',),
                               ),
                                SizedBox(
                                 width:translator.isDirectionRTL(context)?13.sp :10.sp,
                               ),
                               Text(
                                 'contact us'.tr(),
                                 style: TextStyle(
                                     fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                     fontSize: 16.sp,
                                     color: Colors.white,
                                     fontWeight: FontWeight.w800),
                               )
                             ],
                           )),
                     ),
                   ),
                   SizedBox(
                     height: 2.2.h,
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 2.3.h,right: translator.isDirectionRTL(context)==true? 2.7.h:0.h),
                     child: Material(
                       color: Colors.transparent,
                       child: InkWell(
                           onTap: () async {
                             if (AppCubit.get(context).music == true) {
                               final file =
                               await AudioCache().loadAsFile('mixin.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             _launchUrlForRateUsAndGooglePlay();
                           },
                           child: Row(
                             children: [
                               Image(
                                 fit: BoxFit.cover,
                                 color: Colors.white,
                                 alignment: AlignmentDirectional.center,
                                 height: 21.sp,
                                 image: const AssetImage('assets/newImages/starNew.png',),
                               ),
                                SizedBox(
                                 width: translator.isDirectionRTL(context)?10.sp:9.sp,
                               ),
                               Container(
                                 width: translator.isDirectionRTL(context)==false?60.w:40.w,
                                 child: Text(
                                   'rate us'.tr(),
                                   style: TextStyle(
                                       fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                       fontSize: 16.sp,
                                       color: Colors.white,
                                       fontWeight: FontWeight.w800),
                                 ),
                               )
                             ],
                           )),
                     ),
                   ),
                   SizedBox(
                     height: 5.h,
                   ),
                   Container(
                     height: .1.h,
                     color: Colors.white38,
                   ),
                   SizedBox(
                     height: 2.5.h,
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 1.3.h,right: 1.h),
                     child: Text(
                       'application information'.tr(),
                       style: TextStyle(
                           fontSize: 12.sp,
                           color: Colors.white70,
                           fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',),
                     ),
                   ),
                   SizedBox(
                     height: 2.h,
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 2.7.h,right: 2.h),
                     child: Material(
                       color: Colors.transparent,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             'app version'.tr(),
                             style: TextStyle(
                                 fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                 fontSize: 15.sp,
                                 color: Colors.white,
                                 fontWeight: FontWeight.w800),
                           ),
                           Padding(
                             padding: EdgeInsets.all(.8.h),
                             child: Text(
                               '1.0.7',
                               style: TextStyle(
                                   fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                   fontSize: 10.sp,
                                   color: Colors.white70,
                                   fontWeight: FontWeight.w600),
                             ),
                           ),
                           SizedBox(
                             height: 1.6.h,
                           ),
                           InkWell(
                               onTap: () async {
                                 if (AppCubit.get(context).music == true) {
                                   final file = await AudioCache()
                                       .loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 _launchUrl();
                               },
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     'privacy policy'.tr(),
                                     style: TextStyle(
                                         fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                         fontSize: 15.sp,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w800),
                                   ),
                                   Padding(
                                     padding: EdgeInsets.all(.6.h),
                                     child: Text(
                                       'click'.tr(),
                                       style: TextStyle(
                                           fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',
                                           fontSize: 9.sp,
                                           color: Colors.white60,
                                           fontWeight: FontWeight.w600),
                                     ),
                                   )
                                 ],
                               )),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
         body:  Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children:
           [
             SizedBox(height: 2.h,),
             /*
             InkWell(
               onTap: ()
               {
                 _currentIndex==1? Fluttertoast.showToast(msg: 'slider number 1'):null;
               },
               child: Container(
                 width: 80.w,
                 child: StreamBuilder<QuerySnapshot>(
                   stream: AppCubit.get(context).GetSlider(),
                   builder: (context, snapshot) {
                     AppCubit.get(context).Slider = [];
                     AppCubit.get(context).sliderNum=[];
                     List<String> sliderNum = [];
                     for (var doc in snapshot.data!.docs) {
                       AppCubit.get(context).Slider.add(doc['pic']);
                       AppCubit.get(context).sliderNum.add(doc['num']);
                     }
                     return CarouselSlider(
                       carouselController: buttonCarouselController,
                       options: CarouselOptions(height: 16.h,autoPlay: true,disableCenter: true,
                         viewportFraction: 0.8,onPageChanged: (index,reseon)
                         {
                           _currentIndex = index;
                           setState(() {

                           });
                         },
                         initialPage: 0,
                         enableInfiniteScroll: true,
                         reverse: false,
                         autoPlayInterval: Duration(seconds: 3),
                         autoPlayAnimationDuration: Duration(milliseconds: 800),
                         autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                         enlargeCenterPage: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                         enlargeFactor: 0.0,
                         scrollDirection: Axis.horizontal,enlargeStrategy: CenterPageEnlargeStrategy.scale,
                       ),
                       items: AppCubit.get(context).Slider.map((i) {
                         return Builder(
                           builder: (BuildContext context) {
                             return Container(
                                 width: 100.w,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(7.sp),
                                     image: DecorationImage(image: NetworkImage(i),fit: BoxFit.cover),
                                 ),
                             );
                           },
                         );
                       }).toList(),
                     );
                   }
                 ),
               ),
             ),

              */

             _isInlineBannerAdLoaded?Center(
               child: Container(
           padding: EdgeInsets.only(
           bottom: 0,
         ),
         width: _inlineBannerAd.size.width.toDouble(),
         height: _inlineBannerAd.size.height.toDouble(),
         child: AdWidget(ad: _inlineBannerAd),
         ),
             ):Container(height: 12.5.h),


             SizedBox(height: 2.h,),
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
                       builder:(context) => HomeScreen(),
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
                             padding:  EdgeInsets.only(left: 1.sp,top: 4.sp),
                             child: Image(image: AssetImage('assets/images/quotation1.png',),height: 35.sp,color: AppCubit.get(context).isDark?Colors.black:Colors.blue,),
                           ),),
                         SizedBox(height: 1.h),
                         Center(child: Text('quotes'.tr(),style: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold,fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',),textAlign: TextAlign.center)),
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
                       builder:(context) => PhotoScreen(),
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
                           child: Image(image: AssetImage('assets/images/image.png',),height: 33.sp,color: AppCubit.get(context).isDark?Colors.black:Colors.blue,),),
                         SizedBox(height: 1.h),
                         Center(child: Text('photos'.tr(),style: TextStyle(color: Colors.white,fontSize:18.sp,fontWeight: FontWeight.bold,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',),textAlign: TextAlign.center)),
                       ],
                     )),
                   ),
                 ),
               ],
             ),
             SizedBox(height: 3.h,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children:
               [
                 InkWell(
                   child: Container(
                     height: 28.h,
                     width: 38.w,
                     decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10),gradient:LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors:AppCubit.get(context).isDark==false?[HexColor('#2592f1'),HexColor('#2e7ee6')]:[Colors.black, Colors.black],
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
                             padding:  EdgeInsets.only(left: 4.sp,top: 4.sp),
                             child: Image(image: AssetImage('assets/images/make1.png',),height: 35.sp,color: AppCubit.get(context).isDark?Colors.black:Colors.blue,),
                           ),),
                         SizedBox(height: 1.h),
                         Center(child: Text('make'.tr(),style: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',),textAlign: TextAlign.center)),
                       ],
                     )),
                   ),
                   onTap: ()
                   async {
                     if(AppCubit.get(context).music==true)
                     {
                       final file = await AudioCache().loadAsFile('mixin.wav');
                       final bytes = await file.readAsBytes();
                       AudioCache().playBytes(bytes);
                     }
                     AppCubit.get(context).loadInterstialAd();
                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                       builder:(context) => MakeQouteScreen(),
                     ), (route) => true);
                   },
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
                       builder:(context) => FavoriteListScreen(),
                     ), (route) => true);
                   },
                   child: Container(
                     height: 28.h,
                     width: 38.w,
                     decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10),gradient:LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors:AppCubit.get(context).isDark==false?[HexColor('#2592f1'),HexColor('#2e7ee6')]:[Colors.black, Colors.black],
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
                             padding:  EdgeInsets.only(top: 3.sp),
                             child: Icon(
                               Icons.favorite,
                               size: 35.sp,color: AppCubit.get(context).isDark?Colors.black:Colors.blue,
                             ),
                           ),),
                         SizedBox(height: 1.h),
                         Center(child: Text('favorite'.tr(),style: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold,fontFamily: translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound',),textAlign: TextAlign.center)),
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
       ),
     );
   }
}
