
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/model/photoModel/photoModel.dart';
import 'package:statuses_only/model/qouteModel/qouteModel.dart';
import 'package:statuses_only/model/typeOfPhotoes/typeOfPhotoes.dart';
import 'package:statuses_only/model/typeOfQoutes/typeOfQoutes.dart';
import 'package:statuses_only/openAppAd/openAppAd.dart';
import 'package:statuses_only/shared/local/cashe_helper.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

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

   GetQoutesFromTypeOfQoutesForPagination(id)
  {
    return FirebaseFirestore.instance.collection('quotes').doc(id).collection('getQuotes').orderBy("time",descending: true);
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

  // Search for photoes
  List<photoModel>Photoes =[];
  late List<photoModel> searchedForCharactersForPhotoes;
  bool isSearchingForPhotoes = false;
  TextEditingController searchTextControllerForPhotoes = TextEditingController();

  void addSearchedFOrItemsToSearchedListForPhotoes(String searchedCharacter) {
    searchedForCharactersForPhotoes = Photoes.where((character) => character.name!.toLowerCase().startsWith(searchedCharacter)||character.name!.contains(searchedCharacter))
        .toList();
    emit(changeLoveIconState());
  }
  //

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
  List<AssetImage> PhotoessForDark=[];
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

  AddPhotoesToListForDark()
  {
    PhotoessForDark = [
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
      const AssetImage('assets/newImages/backGroundNightMode.png',),
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
    ];

  }
   precacheImage(
      ImageProvider<Object> provider,
      BuildContext context,
      {Size? size,
        ImageErrorListener? onError}
      ){}

  List<String>Texts =['VarelaRound','PoiretOne','Pompiere','Satisfy','AlegreyaSans','KaushanScript','Lobster','Buda','Linden Hill','MyriadPro',
  'AveriaLibre','BungeeInline','ConcertOne','Knewave','MeriendaOne','NerkoOne','OleoScript','Rye','Sansita','Sriracha','Viga'];

   List<String>ArabicFonts=['ElMessiri','ArefRuqaa','BlakaHollow','Change','Gulzar','Lalezar',
   'Al Mohanad Bold','Ara Alharbi Alhanoof','VLAX','Asmaa','Cadillac Sans Arabic Medium','DG Forsha','DG Ghayaty','FF Malmoom Regula',
   'FF Taweel Bold Stamp','Kharabeesh Normal Font','nasaq','Neckar Regular','VEXA','Hacen Algeria Bd'];
  List<bool> boolListForArabicFonts = List<bool>.filled(20, false, growable: true);
  ChangeText()
  {
    print(changeText);
    if(changeText==20)
    {
      changeText=0;
    }else
    {
      changeText++;
    }
    print(changeText);
    //  emit(GetImagesState());
  }
  int changeArabicText = 0 ;
  ChangeArabicText()
  {
    print(changeArabicText);
    if(changeArabicText==19)
    {
      changeArabicText=0;
    }else
    {
      changeArabicText++;
    }
    print(changeArabicText);
    //  emit(GetImagesState());
  }

   ///chinese font
  List<String>chineseFonts =['LiuJianMaoCao','LongCang','MaShanZheng','NotoSansSC','ZCOOLQingKeHuangYou','BungeeInline','ConcertOne','Knewave','MeriendaOne','NerkoOne','OleoScript','Rye','Sansita','Sriracha','Viga'];
  int chineseForMakeScreen=0;
  List<String>hindiFonts =['AnuHandwrittenRegular','ArivndrPomt','DevnagriNiriRegular','MyhindiHindigyan','SanskritLogogramsRegular','BungeeInline','ConcertOne','Knewave','MeriendaOne','NerkoOne','OleoScript','Rye','Sansita','Sriracha','Viga'];
  int hindiForMakeScreen=0;
  List<String>russiaFonts =['ROJA','VelvetDrop','propaganda','RUSKOF','RussianLand','BungeeInline','ConcertOne','Knewave','MeriendaOne','NerkoOne','OleoScript','Rye','Sansita','Sriracha','Viga'];
  int russiaForMakeScreen=0;
  List<String>bnFonts =['AnekBangla','RinkiySushreeMJ','SutonnyMJ','SutonnySushreeMJ','TonnySushreeMJ','BungeeInline','ConcertOne','Knewave','MeriendaOne','NerkoOne','OleoScript','Rye','Sansita','Sriracha','Viga'];
  int bnForMakeScreen=0;
  ChangeTextForMakeScreen()
  {
    print(chineseForMakeScreen);
    if(chineseForMakeScreen==4)
    {
      chineseForMakeScreen=0;
    }else
    {
      chineseForMakeScreen++;
    }
    print(chineseForMakeScreen);
    //  emit(GetImagesState());
  }

  List<bool> boolListForChineseFonts = List<bool>.filled(15, false, growable: true);
  List<bool> boolListForHindiFonts = List<bool>.filled(15, false, growable: true);
  List<bool> boolListForRussiaFonts = List<bool>.filled(15, false, growable: true);
  List<bool> boolListForbnFonts = List<bool>.filled(15, false, growable: true);
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
         adUnitId: Platform.isAndroid?'ca-app-pub-9120321344983600/2120082441':'ca-app-pub-3940256099942544/4411468910',
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
             },
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
     if(interstialadCount<=2) {
       interstialadCount++;
     } else {
       interstialadCount=0;
     }
 //    print('count after change${interstialadCount}');
   }
  int interstialadCountForPhotoes =0;
  void adCountForPhotoes()
  {
    //   print('count pefore change${interstialadCount}');
    if(interstialadCountForPhotoes<=2) {
      interstialadCountForPhotoes++;
    } else {
      interstialadCountForPhotoes=0;
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
  List<TypeOfQoutesModel> Qoutesss = [];
  ///interstial ad for quote style
  int interstialadCountForQuoteStyle =0;
  void adCountForQouteStyle()
  {
    //   print('count pefore change${interstialadCount}');
    if(interstialadCountForQuoteStyle<=2) {
      interstialadCountForQuoteStyle++;
    } else {
      interstialadCountForQuoteStyle=0;
    }
    //    print('count after change${interstialadCount}');
  }

  //photoes Cubit

  Stream<QuerySnapshot> GetPhotoes()
  {
    return FirebaseFirestore.instance.collection('photoes').orderBy("time",descending: true).snapshots();
  }

  Stream<QuerySnapshot> GetNumberOfPhotoes(String id)
  {
    return FirebaseFirestore.instance.collection('photoes').doc(id).collection('getPhotoes').snapshots();
  }

  List<TypeOfPhotoesModel> photoesList = [];

  GetPhotoesFromTypeOfQoutesForPagination(id)
  {
    return FirebaseFirestore.instance.collection('photoes').doc(id).collection('getPhotoes').orderBy("time",descending: true);
  }

  Stream<QuerySnapshot> GetNumberOfPhotoesInList(String id)
  {
    return FirebaseFirestore.instance.collection('photoes').doc(id).collection('getPhotoes').snapshots();
  }

  sendToWhatsApp()
  async {
    await launchUrlString(
      'https://wa.me/201090964348',
      mode: LaunchMode.externalApplication,webOnlyWindowName: 'dsd'
    );
  }

//////////////
  Database? databaseForImages;
  List<Map<String, dynamic>> FavoriteImageList = [];
  ///database for images
  void createDatabaseForImages() {
    openDatabase(
      'favoriteImages.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database for Images created');
        database.execute(
            'CREATE TABLE favoriteImages (id INTEGER PRIMARY KEY,status TEXT,image TEXT)')
            .then((value) {
          print('table created for images');
        }).catchError((error) {
          print('Error When Creating Table for images ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromImageDatabase(database);
        print('images database opened');
      },
    ).then((value) {
      databaseForImages = value;
      emit(AppCreateDatabaseState());
    });
  }

  Map<int, String> IsFavoriteImagesList = {};
  List<String> favoImages = [];

  Future<void> getDataFromImageDatabase(database) async {
    FavoriteImageList = [];
    IsFavoriteImagesList = {};
    //  emit(AppGetDatabaseLoadingState());

    await database.rawQuery('SELECT * FROM favoriteImages').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          FavoriteImageList.add(element);
        IsFavoriteImagesList.addAll(
            {
              element['id']: element['image'],
            });
      });
      emit(AppGetDatabaseState());
    });
  }


  Future insertToDatabaseForImage({
    @required String? image,
  }) async {
    await databaseForImages!.transaction((txn) async {
      txn.rawInsert(
        'INSERT INTO favoriteImages(status,image) VALUES("new","$image")',)
          .then((value) {
        print('$value inserted successfully');
        //      emit(AppInsertDatabaseState());

        //      getDataFromDatabase(database!);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  Future deleteDataForImage({
    @required int? id,
  }) async {
    databaseForImages!.rawDelete(
        'DELETE FROM favoriteImages WHERE id = ?', [id])
        .then((value) {
      getDataFromImageDatabase(databaseForImages);
      //     emit(AppDeleteDatabaseState());
    });
  }
  ///
  Future deleteDataFromImagePage({
    @required String? image,
  }) async {
    databaseForImages!.rawDelete(
        'DELETE FROM favoriteImages WHERE image = ?', [image])
        .then((value) {
      getDataFromImageDatabasee(databaseForImages);
      //     emit(AppDeleteDatabaseState());
    });
  }

  Future deleteDataFromImagePageForLikeButton({
    @required String? image,
  }) async {
    databaseForImages!.rawDelete(
        'DELETE FROM favoriteImages WHERE image = ?', [image])
        .then((value) {
      getDataFromImageDatabaseeForLikeButton(databaseForImages);
      //     emit(AppDeleteDatabaseState());
    });
  }
  Future<void> getDataFromImageDatabaseeForLikeButton(database) async {
    FavoriteImageList = [];
    IsFavoriteImagesList = {};
    //  emit(AppGetDatabaseLoadingState());

    await database.rawQuery('SELECT * FROM favoriteImages').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          FavoriteImageList.add(element);
        IsFavoriteImagesList.addAll(
            {
              element['id']: element['image'],
            });
      });
      emit(AppGetDatabaseState());
    });
  }

  Future deleteDataFromFavPage({
    @required String? image,
  }) async {
    databaseForImages!.rawDelete(
        'DELETE FROM favoriteImages WHERE image = ?', [image])
        .then((value) {
      getDataFromImageDatabasee(databaseForImages);

    });
  }
  Future<void> getDataFromFavImageDatabasee(database) async {
    FavoriteImageList = [];
    IsFavoriteImagesList = {};
    //  emit(AppGetDatabaseLoadingState());

    await database.rawQuery('SELECT * FROM favoriteImages').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          FavoriteImageList.add(element);
        IsFavoriteImagesList.addAll(
            {
              element['id']: element['image'],
            });
      });
    });
  }

  Future<void> getDataFromImageDatabasee(database) async {
    FavoriteImageList = [];
    IsFavoriteImagesList = {};
    //  emit(AppGetDatabaseLoadingState());

    await database.rawQuery('SELECT * FROM favoriteImages').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          FavoriteImageList.add(element);
        IsFavoriteImagesList.addAll(
            {
              element['id']: element['image'],
            });
      });
      emit(AppGetDatabaseState());
    });
  }
  ///



  Future deleteDataFromImagePagee({
    @required String? image,
  }) async {
    databaseForImages!.rawDelete(
        'DELETE FROM favoriteImages WHERE image = ?', [image])
        .then((value) {
      getDataFromImageDatabase(databaseForImages);
      //     emit(AppDeleteDatabaseState());
    });
  }
  ///end of imagesDatabase
  final imagePicker = ImagePicker();

  late AppOpenAd  appOpenAd ;
  bool oppenAppLoaded = false;

  int makeColor =0;

   changeMakeColor(makecolor)
   {
     BackgroundPickerColor=Colors.transparent;
     image = null;
     makeColor =makecolor;
     emit(AppGetDatabaseState());
   }

  File? image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        print('_image: $image');
      } else {
        print('No image selected');
      }
    emit(AppGetDatabaseState());
  }

  int textForMakeScreen=0;
  /*
  ChangeTextForMakeScreen()
  {
    print(textForMakeScreen);
    if(textForMakeScreen==10)
    {
      textForMakeScreen=0;
    }else
    {
      textForMakeScreen++;
    }
    print(textForMakeScreen);
    //  emit(GetImagesState());
  }

   */



  ChangePhotoForMakeScreen()
  {
    image=null;
    if(makeColor==11)
    {
      makeColor=0;
    }else
    {
      makeColor++;
    }
  }
  List<FontWeight>fontWeightList =[FontWeight.w400,FontWeight.bold,];
  int fontWeight=0;
   ChangeFontWeight()
  {
    if(fontWeight==1)
    {
      fontWeight=0;
    }else
    {
      fontWeight++;
    }
  }

  List<double>fontSizeList =[17.sp,18.sp,19.sp,20.sp,21.sp,22.sp,23.sp,24.sp,25.sp,5.sp,10.sp,13.sp,15.sp,];
  int fontSize=0;
  double fontSizeSlider=17;
  changeSlider(value)
  {
    fontSizeSlider = value;
    emit(MakeItDarkState());
  }
  ChangeFontSize()
  {
    if(fontSize==11)
    {
      fontSize=0;
    }else
    {
      fontSize++;
    }
  }

  List<double>AlignmentList =[20.h,0.h,5.h,10.h,15.h,17.h,19.h,21.h,22.h,24.h,26.h,28.h,30.h,32.h,34.h,36.h,38.h];
  int fontAlignment=0;
  ChangeFontAlignment()
  {
    if(fontAlignment==16)
    {
      fontAlignment=0;
    }else
    {
      fontAlignment++;
    }
  }

    List<Color>ColorsList=[Colors.white,Colors.black,Colors.purple,Colors.blue,Colors.deepOrangeAccent,Colors.yellow,Colors.pink,Colors.red,Colors.green,Colors.grey,Colors.deepPurple,];
    int colorChange =0;
    changeQuoteColorForMakeScreen()
    {
      if(colorChange==10)
      {
        colorChange=0;
      }else
      {
        colorChange++;
      }
    }

  List<TextAlign>textAlignList=[TextAlign.center,TextAlign.start,TextAlign.end,];
  int textAlign =0;
  changeQuoteAlignForMakeScreen()
  {
    if(textAlign==2)
    {
      textAlign=0;
    }else
    {
      textAlign++;
    }
  }

  css({num})
  {
    textAlign =num;
  }

  int interstialadCountForPhotoesScreen =0;
  void adCountForPhotoesScreen()
  {
    if(interstialadCountForPhotoesScreen<=2) {
      interstialadCountForPhotoesScreen++;
    } else {
      interstialadCountForPhotoesScreen=0;
    }
  }

  int interstialadCountForPhotoesListScreen =0;
  void adCountForQouteForPhotoListScreen()
  {
    if(interstialadCountForPhotoesListScreen<=2) {
      interstialadCountForPhotoesListScreen++;
    } else {
      interstialadCountForPhotoesListScreen=0;
    }
  }

  FocusNode inputNode = FocusNode(canRequestFocus: true);
// to open keyboard call this function;
 Future openKeyboard(context) async {
  // FocusManager.instance.primaryFocus!.unfocus();
  //  FocusManager.instance.primaryFocus!.requestFocus(inputNode);

     if(inputNode.hasFocus)
       inputNode.unfocus();
  // inputNode.requestFocus();
  }
  List<FontStyle>fontItalicList=[FontStyle.normal,FontStyle.italic ];
  int italicVariable=0;
  changefontItalic()
  {
    if(italicVariable==1)
    {
      italicVariable=0;
    }else
    {
      italicVariable++;
    }
  }

  List<TextDecoration>fontUnderLine=[TextDecoration.none,TextDecoration.underline];
  int underLineVariable=0;
  changetextUnderLine()
  {
    if(underLineVariable==1)
    {
      underLineVariable=0;
    }else
    {
      underLineVariable++;
    }
  }
   Color BackgroundPickerColor= Colors.transparent;



    bool isRowTapped= false;
    showRowFun()
    {
      isFontsListShow=false;
      isSliderShow = false;
      isCentered=false;
      isRowTapped = !isRowTapped;
    }

    double sliderSize=22;
  bool isSliderShow= false;
  showSliderFun()
  {
    isFontsListShow=false;
    isRowTapped =false;
    isCentered=false;
    isSliderShow = !isSliderShow;
  }

  bool isFontsListShow = false;
  showFontsListFun()
  {
    isRowTapped =false;
    isSliderShow= false;
    isCentered=false;
    isFontsListShow = !isFontsListShow;
  }

  changeFont(index)
  {
    textForMakeScreen = index;
    emit(MakeItDarkState());
  }
  changeChineseFont(index)
  {
    chineseForMakeScreen = index;
    emit(MakeItDarkState());
  }

  changeHindiFont(index)
  {
    hindiForMakeScreen = index;
    emit(MakeItDarkState());
  }
  changeRussiaFont(index)
  {
    russiaForMakeScreen = index;
    emit(MakeItDarkState());
  }
  changebnFont(index)
  {
    bnForMakeScreen = index;
    emit(MakeItDarkState());
  }
  int ArabictextForMakeScreen=0;
  changeArabicFont(index)
  {
    ArabictextForMakeScreen = index;
    emit(MakeItDarkState());
  }

  bool isIconsListShow = false;

  List<AssetImage>listOfIcons=[AssetImage('assets/images/bold.png'),AssetImage('assets/images/italicFont.png'),AssetImage('assets/images/underlineText.png'),];

  editFontFunction(index)
  {
    if(index==0)
      ChangeFontWeight();
    if(index==1)
      changefontItalic();
    if(index==2)
      changetextUnderLine();
    emit(MakeItDarkState());
  }



   List<bool> boolList = List<bool>.filled(21, false, growable: true);

  bool isCentered = false;
  List<AssetImage>listOfCentered=[AssetImage('assets/images/leftAlign.png'),AssetImage('assets/images/centeredText.png'),AssetImage('assets/images/rightAlign.png'),];


  editCenteredFontFunction(index)
  {
    if(index==0)
      css(num:1);
    if(index==1)
      css(num:0);
    if(index==2)
      css(num:2);
    emit(MakeItDarkState());
  }

  showCenteredFontFun()
  {
    isRowTapped =false;
    isSliderShow= false;
    isFontsListShow=false;
    isCentered=!isCentered;
  }

  double sliderForPadding=31.h;


  int interstialadCountForMakeScreen =0;
  Future adCountForMakeScreen()
  async {
    if(interstialadCountForMakeScreen<=3) {
      interstialadCountForMakeScreen++;
    } else {
      interstialadCountForMakeScreen=0;
    }
  }

  bool readOnly =false;

  Future changeToReadOnly()
  async
  {
    readOnly = true;
    emit(MakeItDarkState());
  }
  ScreenshotController screenshotController = ScreenshotController();
  Future screenShotAndSave(context)
  async {
    AppCubit.get(context).changeToReadOnly();
    Timer(Duration(seconds: 1),()
    async {
      await screenshotController.capture(delay: const Duration(milliseconds: 10)).then(( image) async {
        if (image != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File('${directory.path}/image.png').create();
          await imagePath.writeAsBytes(image);
          /// save
          await GallerySaver.saveImage(imagePath.path).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'download'.tr(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.blue,
              ),
            );
          });
          //    await Share.shareFiles([imagePath.path]);
        }
      });
    });
  }

  Future ShowDialogForLanguage(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("الغاء",
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Padding(
        padding: EdgeInsets.only(right: 2.h, left: 2.h),
        child: Text("تحديث",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
      ),
      onPressed: () async {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.sp),) ,clipBehavior: Clip.antiAliasWithSaveLayer,titlePadding: EdgeInsetsDirectional.zero,contentPadding: EdgeInsetsDirectional.zero,
        title: Container(

            height: 6.h,color: isDark?Colors.blueGrey[900]:Colors.blue,child: Center(child: Text('Language',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 18.sp,fontFamily: 'VarelaRound')),)),
      content: Padding(
          padding: EdgeInsets.only(right: 0.h, left: 0.h),
          child: Column(children:
          [
            InkWell(
                onTap: ()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'ar',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,width:100.w,color: isDark?Colors.black:Colors.white,
                        child: translator.activeLanguageCode=='ar'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color: isDark?Colors.white:Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('عربي',
                                style: TextStyle(color:isDark?Colors.white:Colors.blue,
                                    fontSize: 18.sp,fontFamily:'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ):Padding(
                          padding:  EdgeInsets.only(top: 5.sp),
                          child: Text('عربي',
                              style: TextStyle(color: isDark?Colors.white:Colors.blue,
                                  fontSize: 18.sp,fontFamily:'VarelaRound',fontWeight: FontWeight.w600),textAlign: TextAlign.center),
                        ),))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'en',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child: translator.activeLanguageCode=='en'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color: isDark?Colors.white:Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('English',
                                style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ):Text('English',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'zh',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child:translator.activeLanguageCode=='zh'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color: Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('中國人',
                                style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ): Text('中國人',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'hi',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child:translator.activeLanguageCode=='hi'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color: Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('भारतीय',
                                style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ): Text('भारतीय',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'pt',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child: translator.activeLanguageCode=='pt'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color:isDark?Colors.white:Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('Português',
                                style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ):Text('Português',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'fr',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child: translator.activeLanguageCode=='fr'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color: isDark?Colors.white:Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('Francês',
                                style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ):Text('Francês',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'es',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child:translator.activeLanguageCode=='es'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color: isDark?Colors.white:Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('Español',
                                style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ): Text('Español',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'bn',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child:Center(child:translator.activeLanguageCode=='bn'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color: isDark?Colors.white:Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('बांग्लादेश',
                                style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ): Text('बांग्लादेश',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'ru',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child: translator.activeLanguageCode=='ru'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color: isDark?Colors.white:Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('Русский',
                                style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ):Text('Русский',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
            InkWell(
                onTap:()
                {
                  translator.setNewLanguage(
                    context,
                    newLanguage:'de',
                    remember: true,
                    restart: true,
                  );
                },
                child: Material(color: Colors.transparent,
                    child: Container(height: 7.h,color: isDark?Colors.black:Colors.white,
                        child: Center(child: translator.activeLanguageCode=='de'?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done,color:isDark?Colors.white:Colors.blue,size: 25.sp,),
                            SizedBox(width: 10.w),
                            Text('Deutsch',
                                style: TextStyle(color:isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),
                            SizedBox(width: 20.w),
                          ],
                        ):Text('Deutsch',
                            style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 16.sp,
                                fontFamily: 'VarelaRound',fontWeight: FontWeight.w600)),)))),
            Container(height: .4.sp,color: isDark?Colors.blue:Colors.blue,),
          ],
            mainAxisSize: MainAxisSize.min,
          )
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

    bool translated = false;
  String ss= '';
  List<TypeOfQoutesModel> TranslatedQoutes = [];
    trans()
         {
           translated = !translated;
           emit(changeLoveIconState());
              }

              ///font size is quoteStyle
             int fntSize =  0;
    List<double>fntListSizes=[17.sp,18.sp,19.sp,20.sp,22.sp,24.sp,26.sp,28.sp,30.sp,32.sp,5.sp,7.sp,9.sp,12.sp,14.sp,15.sp,16.sp];
    changefntSizes()
    {
      if(fntSize<16)
      fntSize++;
      else
        fntSize=0;
    }

    int rowOrPieces = 3;

    changeToRowOrPieces()
    {
      if(rowOrPieces==3)
        rowOrPieces=1;
      else if(rowOrPieces==1)
        rowOrPieces=3;
    }

  Stream<QuerySnapshot> GetSlider()
  {
    return FirebaseFirestore.instance.collection('englishSlider').snapshots();
  }

  List<String> Slider = [];
  List<int> sliderNum = [];
}

