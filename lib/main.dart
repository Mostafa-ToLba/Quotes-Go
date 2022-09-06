
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/SplashScreen/SplashScreen.dart';
import 'package:statuses_only/shared/local/cashe_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitUp]);
  await CasheHelper.init();
  bool dark;
  bool isMusicOn;
   CasheHelper.getData(key:'isDark')==null?dark =false:dark=CasheHelper.getData(key:'isDark');
  CasheHelper.getData(key:'isMusicOn')==true||CasheHelper.getData(key:'isMusicOn')==null?isMusicOn=true:isMusicOn=false;
  dark ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: Colors.black,
    systemNavigationBarIconBrightness:Brightness.light,
  )):SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarIconBrightness:Brightness.dark,
  ));

  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("938e78c1-49a5-4f8f-9ed8-8ff9c751f08a");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  runApp( MyApp(dark: dark,isMusicOn:isMusicOn));
}

class MyApp extends StatelessWidget {
  bool dark;
  bool isMusicOn;
   MyApp({required this.dark,Key? key,required this.isMusicOn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(InitialAppCubitState())..MakeItDark(fromShared: dark)..MakeItSound(fromShared: isMusicOn)
        ..createDatabase()
        ..AddPhotoesToList(),
      child:  Sizer(
        builder: (BuildContext context, Orientation orientation,
             deviceType) {
          return BlocConsumer<AppCubit,AppCubitStates>(
            listener: (BuildContext context, state) {
            },
            builder: (BuildContext context, Object? state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Quotes Go',
                theme: ThemeData(
                  backgroundColor: Colors.white,
                  appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.blue,
                      statusBarIconBrightness: Brightness.light,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0.0,
                  ),
                  primarySwatch: Colors.blue,
                  tabBarTheme: TabBarTheme(),
                ),
                darkTheme: ThemeData(
                  progressIndicatorTheme:const ProgressIndicatorThemeData(
                    color: Colors.blue,
                  ),
                  textTheme:const TextTheme(
                    bodyText1:const  TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    subtitle1: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  primarySwatch: Colors.blue,
                  scaffoldBackgroundColor: Colors.black,
                  appBarTheme: AppBarTheme(
                    actionsIconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: HexColor('0D0D0D'),
                      statusBarIconBrightness: Brightness.light,
                    ),
                    backgroundColor: HexColor('0D0D0D'),
                    elevation: 0.0,
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Colors.blue,
                    backgroundColor: HexColor('0D0D0D'),
                    unselectedItemColor: Colors.grey,
                  ),
                  drawerTheme:const DrawerThemeData(
                    backgroundColor: Colors.black,
                  ),
                  backgroundColor: Colors.black,
                  unselectedWidgetColor: Colors.grey,
                  iconTheme:const IconThemeData(color: Colors.black,),
                ),
                themeMode:AppCubit.get(context).isDark==false? ThemeMode.light : ThemeMode.dark,
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
