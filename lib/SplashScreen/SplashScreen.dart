import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/FirstScreen/firstScreen.dart';
import 'package:statuses_only/HomeScreen/HomeScreen.dart';
import 'package:statuses_only/openAppAd/openAppAd.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future loadAppOpenAd()
  async{
    await AppOpenAd.load(
      adUnitId: Platform.isAndroid ? 'ca-app-pub-3940256099942544/3419835294' : 'ca-app-pub-3940256099942544/5662855259',
      orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            AppCubit.get(context).appOpenAd = ad;
            AppCubit.get(context).oppenAppLoaded=true;
          });
          // appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    loadAppOpenAd().then((value)
    {
      Timer(Duration(seconds: 4),()
      {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder:(context) => FirstScreen(),
        ), (route) => false);

      });

    });


  }

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppCubitStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:  Brightness.light,
          ),
          child: Scaffold(
            body: Container(
              child:  ClipRRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              HexColor('#4527a0'),
                              HexColor('#29b6f6'),],)),
                      //       color: Colors.green,
                      height: double.infinity,
                      width:double.infinity ,
                    ),
                    Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100.h,width: double.infinity,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 13.h),
                       //       Image(image: const AssetImage('assets/images/LogoWithoutBackground.png',),height: 60.h,width: 60.w,),
                              Image(image: const AssetImage('assets/newImages/quomxSplash.png',),height: 60.h,width: 60.w,),
                              Lottie.asset('assets/animation/file.json',height: 15.h,width: 45.w),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

      /*
      nextScreen: HomeScreen(),
      animationDuration:(Duration(seconds: 5)),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType:PageTransitionType.bottomToTop,
      splashIconSize: 100.h,
      backgroundColor: Colors.blue,

       */

    /*
      AnimatedSplashScreen(
        splash: AnnotatedRegion<SystemUiOverlayStyle>(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100.h,width: double.infinity,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 13.h),
                    Image(image: const AssetImage('assets/images/LogoWithoutBackground.png',),height: 60.h,width: 60.w,),
                    Lottie.asset('assets/animation/file.json',height: 15.h,width: 45.w),
                  ],
                ),
              ),
            ],
          ),
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:  Brightness.light,
          ),
        ),
        nextScreen: HomeScreen(),
    backgroundColor: Colors.blueAccent,
      centered: true,
      splashIconSize: 100.h,
      //customTween: DecorationTween(begin: BoxDecoration(color: Colors.black),end: BoxDecoration(color: Colors.blueAccent)),
      animationDuration:const Duration(seconds: 3),
      splashTransition: SplashTransition.sizeTransition,
  //    pageTransitionType:PageTransitionType.bottomToTop,
    );

     */

    /*
    return AnimatedSplashScreen(
      splash: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:  Brightness.light,
        ),
        child: Scaffold(
          body: Container(
            child: ClipRRect(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            HexColor('#4527a0'),
                            HexColor('#29b6f6'),],)),
                    //       color: Colors.green,
                    height: double.infinity,
                    width:double.infinity ,
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100.h,width: double.infinity,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 13.h),
                            Image(image: AssetImage('assets/images/logoo.png',),height: 57.h,width: 57.w,),
                            Lottie.asset('assets/animation/file.json',height: 15.h,width: 45.w),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      nextScreen: HomeScreen(),
      animationDuration:(Duration(seconds: 5)),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType:PageTransitionType.bottomToTop,
      splashIconSize: 100.h,
      backgroundColor: Colors.blue,
    );


     */
  }
}

