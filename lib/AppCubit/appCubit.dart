
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/model/qouteModel/qouteModel.dart';
import 'package:statuses_only/model/typeOfQoutes/typeOfQoutes.dart';
import 'package:statuses_only/shared/local/cashe_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCubit extends Cubit<AppCubitStates> {
  static BuildContext? context;

  AppCubit(AppCubitStates InitialAppCubitState) : super(InitialAppCubitState);

  static AppCubit get(context) => BlocProvider.of(context);


  Stream<QuerySnapshot> GetQoutes()
  {
    return FirebaseFirestore.instance.collection('quotes').orderBy("time",descending: true).snapshots();
  }

  Stream<QuerySnapshot> GetNumberOfQoutes(String id)
  {
    return FirebaseFirestore.instance.collection('quotes').doc(id).collection('getQuotes').snapshots();
  }


  Stream<QuerySnapshot> GetQoutesFromTypeOfQoutes(id)
  {
    return FirebaseFirestore.instance.collection('quotes').doc(id).collection('getQuotes').orderBy("time",descending: true).snapshots();
  }
  int? Message;
   GetMasseges(id)
   {
     FirebaseFirestore.instance.collection('quotes').doc(id).collection('getQuotes').get().then((value)
     {
       Message=value.docs.length;
      // emit(GetMessageState());
     });
   }

  List<String>Images=[];
  List<int>IndexOfImage=[];
   int change=0;
   int changeText=0;
  Database? database;
  List<Map<String,dynamic>> FavoriteList = [];

  Future getImages()
  async {
   await FirebaseFirestore.instance.collection('images').get().then((value)
     {
      value.docs.forEach((element)
      {
        Images.add(element['image']);
      });
      emit(GetImagesState());
    }).then((value)
    {
      emit(GetImagesState());
    });
  }

   ChangePhoto()
  {
    if(change==11)
    {
      change=0;
    }else
      {
        change++;
      }
  }

  ChangeePhoto(index)
  {
    index++;
    return index;
  }


  void createDatabase() {
    openDatabase(
      'favorite.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        database.execute('CREATE TABLE favorite (id INTEGER PRIMARY KEY, qoute TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }



   Future insertToDatabase({
    @required String? qoute,
  }) async {
    await database!.transaction((txn)async {txn.rawInsert('INSERT INTO favorite(qoute,status) VALUES("$qoute","new")',)
          .then((value) {
        print('$value inserted successfully');
  //      emit(AppInsertDatabaseState());

  //      getDataFromDatabase(database!);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }


  Future insertToDatabaseForQuoteStyle({
    @required String? qoute,
  }) async {
    await database!.transaction((txn)async {txn.rawInsert('INSERT INTO favorite(qoute,status) VALUES("$qoute","new")',)
        .then((value) {
      print('$value inserted successfully');
      //      emit(AppInsertDatabaseState());
            getDataFromDatabase(database!);
    }).catchError((error) {
      print('Error When Inserting New Record ${error.toString()}');
    });
    });
  }




  Map<int,String> IsFavoriteList={};
  List<String> favo=[];
  Future<void> getDataFromDatabase( database)
  async {
    FavoriteList = [];
    IsFavoriteList={};
  //  emit(AppGetDatabaseLoadingState());

   await database.rawQuery('SELECT * FROM favorite').then(( value) {
     value.forEach((element)
     {
       if(element['status'] == 'new')
       FavoriteList.add(element);
       IsFavoriteList.addAll(
           {
             element['id']:element['qoute'],
           });
     });
      emit(AppGetDatabaseState());
    });
  }


  Future<void> getDataFromDatabaseForLikeButton( database)
  async {
    FavoriteList = [];
    IsFavoriteList={};
    //  emit(AppGetDatabaseLoadingState());

    await database.rawQuery('SELECT * FROM favorite').then(( value) {
      value.forEach((element)
      {
        if(element['status'] == 'new')
          FavoriteList.add(element);
        IsFavoriteList.addAll(
            {
              element['id']:element['qoute'],
            });
      });
    //  emit(AppGetDatabaseState());
    });
  }





  void deleteData({
    @required int? id,
  })
  {
    database!.rawDelete('DELETE FROM favorite WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
 //     emit(AppDeleteDatabaseState());
    });
  }
  Future deleteeData({
    @required String? qoute,
  }) async
  {
  await  database!.rawDelete('DELETE FROM favorite WHERE qoute = ?', [qoute]);
  /*
        .then((value)
    {
      getDataFromDatabase(database);
  //    emit(AppDeleteDatabaseState());
    });

   */
  }

  Future deleteeDataForQuoteStylePage({
    @required String? qoute,
  }) async
  {
    await  database!.rawDelete('DELETE FROM favorite WHERE qoute = ?', [qoute])
        .then((value)
    {
      getDataFromDatabase(database);
  //    emit(AppDeleteDatabaseState());
    });

  }



  bool love =false;
   changeLoveIcon()
   {
     love = true;
     emit(changeLoveIconState());
   }
  changeLoveeIcon()
  {
    love = false;
    emit(changeLoveIconState());
  }

  List<QouteModel>Qoutes =[];
  late List<QouteModel> searchedForCharacters;
  bool isSearching = false;
  TextEditingController searchTextController = TextEditingController();

  void addSearchedFOrItemsToSearchedList(String searchedCharacter) {
      searchedForCharacters = Qoutes.where((character) => character.name!.toLowerCase().startsWith(searchedCharacter)||character.name!.contains(searchedCharacter))
          .toList();
      emit(changeLoveIconState());
  }

  bool fav=false;
  changeicon(qoute)
  {
    if(IsFavoriteList.containsValue(qoute))
    {
      fav =false;
      emit(trueState());
    }
    else
    {
      fav =true;
      emit(falseState());
    }
    print('+++>>>>> ${fav}');
  }

  late List<bool> LIST = [];

   bool function(qoute)
   {
     if(IsFavoriteList.containsValue(qoute))
     {
       return false;
     }
     else
       {
         return true;
       }
   }

  List<AssetImage> Photoess=[];
   AddPhotoesToList()
   {
      Photoess = [
/*
        const AssetImage('assets/images/photo9.jpg',),
        const AssetImage('assets/images/photo2.jpg'),
        const AssetImage('assets/images/photo3.jpg'),
        const AssetImage('assets/images/photo4.jpg'),
        const AssetImage('assets/images/photo5.jpg'),
        const AssetImage('assets/images/photo7.jpg'),
        const AssetImage('assets/images/photo10.jpg'),
        const AssetImage('assets/images/photo11.jpg'),
        const AssetImage('assets/images/orange.jpg'),

 */

        const AssetImage('assets/images/1.jpg',),
        const AssetImage('assets/images/2.jpg'),
        const AssetImage('assets/images/3.jpg'),
       const AssetImage('assets/images/4.jpg'),
       const AssetImage('assets/images/5.jpg'),
       const AssetImage('assets/images/6.jpg'),
      const  AssetImage('assets/images/7.jpg'),
       const AssetImage('assets/images/8.jpg'),
       const AssetImage('assets/images/9.jpg'),
        const AssetImage('assets/images/10.jpg'),
        const AssetImage('assets/images/11.jpg'),
        const AssetImage('assets/images/13.jpg'),
     ];

   }

   precacheImage(
      ImageProvider<Object> provider,
      BuildContext context,
      {Size? size,
        ImageErrorListener? onError}
      ){}

  List<String>Texts =['VarelaRound','PoiretOne','Pompiere','Satisfy','AlegreyaSans','KaushanScript','Lobster','Lobster Two','Buda','Linden Hill','MyriadPro',];
  ChangeText()
  {
    print(changeText);
    if(changeText==10)
    {
      changeText=0;
    }else
    {
      changeText++;
    }
    print(changeText);
    //  emit(GetImagesState());
  }

/*
   static bool testMode = true ;
   static String get AppId
   {
     if(Platform.isAndroid)
       return '';
     else if(Platform.isIOS)
     return '';
     else
     throw UnsupportedError('Unsupported Platform');
   }

  static String get BannerAddUnitId
  {
    if(testMode==true)
      return AdmobBanner.testAdUnitId;
    else if(Platform.isAndroid)
      return '';
    else if(Platform.isIOS)
      return '';
    else
      throw UnsupportedError('Unsupported Platform');
  }


 */

  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid?'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );

  final BannerAd myFavBanner = BannerAd(
    adUnitId: Platform.isAndroid?'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );




  final BannerAd MyBanner = BannerAd(
    adUnitId: Platform.isAndroid?'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );

  Widget getAd() {
    BannerAd MyyBanner = BannerAd(
      adUnitId: Platform.isAndroid?'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-3940256099942544/2934735716',
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad)
        {
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
        onAdWillDismissScreen: (ad) {
          ad.dispose();
        },
      ),
    );
    // MyyBanner.load();
    return SizedBox(
      height: MyyBanner.size.height.toDouble(),
      width: MyyBanner.size.width.toDouble(),
      child:AdWidget(ad: MyyBanner..load(),key: UniqueKey()),
    );
  }


  final BannerAd banFavorite = BannerAd(
    adUnitId: Platform.isAndroid?'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );


  final BannerAd QouteStyleAd = BannerAd(
    adUnitId: Platform.isAndroid?'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );

  bool music=true;

  bool isDark= false;
   MakeItDark({bool? fromShared}) {
    if (fromShared == false) {
      isDark = fromShared!;
      emit(MakeItDarkState());
    } else {
      isDark = !isDark;
      CasheHelper.putBoolean(key:'isDark', value: isDark )!.then((value)
      {
        emit(MakeItDarkState());
      });
    }
  }

  /*
  if(isMusicOn==false)
  AppCubit.get(context).music=false;
  else if(isMusicOn==true)
  AppCubit.get(context).music=true;

   */

  MakeItSound({bool? fromShared}) {
    if (fromShared == true) {
      music = fromShared!;
      emit(MakeItDarkState());
    } else {
      music = !music;
      CasheHelper.putBoolean(key:'isMusicOn', value: music )!.then((value)
      {
        emit(MakeItDarkState());
      });
    }
  }


  Widget gettAd() {
    BannerAdListener bannerAdListener =
    BannerAdListener(onAdWillDismissScreen: (ad) {
      ad.dispose();
    }, onAdClosed: (ad) {
      debugPrint("Ad Got Closeed");
    });
    BannerAd bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isAndroid
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-3940256099942544/2934735716",
      listener: bannerAdListener,
      request: const AdRequest(),
    );

    bannerAd.load();

    return SizedBox(
      height: 100,
      child: AdWidget(ad: bannerAd),
    );
  }
  //interstatial ad

  InterstitialAd ? interstitialAd;
   bool  isReady =false ;
   Future<void> loadInterstialAd ()
   async {
    await InterstitialAd.load(
         adUnitId: Platform.isAndroid?'ca-app-pub-6775155780565884/8612705114':'ca-app-pub-3940256099942544/5135589807',
         request: const AdRequest(),
         adLoadCallback: InterstitialAdLoadCallback(
             onAdLoaded: (ad)
             {
               isReady = true;
               interstitialAd = ad;
             },
             onAdFailedToLoad: (error)
             {
               print('interstial ad is failed to load');
             }
         ),
     );
   }
   Future<void> showInterstialAd()
   async {
     if(isReady) {
      await  interstitialAd!.show();
     }
   }
   int interstialadCount =0;
   void adCount()
   {
  //   print('count pefore change${interstialadCount}');
     if(interstialadCount<=4) {
       interstialadCount++;
     } else {
       interstialadCount=0;
     }
 //    print('count after change${interstialadCount}');
   }

    GetDeviceType()
   {
     if(SizerUtil.deviceType==DeviceType.mobile)
       return .7.sp;
     else if(SizerUtil.deviceType==DeviceType.tablet)
       return .3.sp;
   }

  forChangeFontSize(context)
  {
    //  AppCubit.get(context).changeText==0?16.sp:19.sp;
    if(SizerUtil.deviceType==DeviceType.mobile)
    {
      if(AppCubit.get(context).changeText==0)
        return 17.sp;
      else
        return 18.sp;
    }
    else if(SizerUtil.deviceType==DeviceType.tablet)
    {
      if(AppCubit.get(context).changeText==0)
        return 13.sp;
      else
        return 15.sp;
    }
  }
  GetDeviceTypeOfStyleScreen()
  {
    if(SizerUtil.deviceType==DeviceType.mobile)
      return 1.1.sp;
    else if(SizerUtil.deviceType==DeviceType.tablet)
      return .4.sp;
  }
  Future as()
  async {
    isShare =true;
  }
  bool isShare =false;
  GlobalKey previewContainer = new  GlobalKey();
   Future Share(context)
   async {

     if(music==true)
     {
       final file = await AudioCache().loadAsFile('mixin.wav');
       final bytes = await file.readAsBytes();
       AudioCache().playBytes(bytes);
     }
       await  ShareFilesAndScreenshotWidgets().shareScreenshot(
         previewContainer,
         1000,
         "Title",
         "Name.png",
         "image/png",
       );

   }

  List<TypeOfQoutesModel> Qoutess = [];

  ///interstial ad for quote style
  int interstialadCountForQuoteStyle =0;
  void adCountForQouteStyle()
  {
    //   print('count pefore change${interstialadCount}');
    if(interstialadCountForQuoteStyle<=5) {
      interstialadCountForQuoteStyle++;
    } else {
      interstialadCountForQuoteStyle=0;
    }
    //    print('count after change${interstialadCount}');
  }
}


BannerAd myBanner = BannerAd(
  adUnitId: Platform.isAndroid?'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-3940256099942544/2934735716',
  size: AdSize.banner,
  request: AdRequest(),
  listener: BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();     print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  ),
);

