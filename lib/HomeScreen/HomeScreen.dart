import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/QouteScreen/QouteScreen.dart';
import 'package:statuses_only/Skelton/Skeleton.dart';
import 'package:statuses_only/favoriteScreen/favoriteScreen.dart';
import 'package:statuses_only/model/qouteModel/qouteModel.dart';
import 'package:statuses_only/shared/local/cashe_helper.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldkey = GlobalKey<ScaffoldState>();

  List<Widget> buildAppBarActions(context) {
    if (AppCubit.get(context).isSearching) {
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
                    builder: (context) => const FavoriteScreen(),
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
        controller: AppCubit.get(context).searchTextController,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14.sp),
        ),
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        onChanged: (searchedCharacter) {
          AppCubit.get(context).addSearchedFOrItemsToSearchedList(searchedCharacter);
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
      AppCubit.get(context).isSearching = true;
    });
  }

  void stopSearching() async {
    clearSearch();
    setState(() {
      AppCubit.get(context).isSearching = false;
    });
  }

  void clearSearch() async {
    setState(() {
      AppCubit.get(context).searchTextController.clear();
    });
  }

  final Uri _url = Uri.parse(
      'https://sites.google.com/view/quotesgo?fbclid=IwAR0bJhM91EB_v-GMhM1zueXmTvYhalob2kSMTAGpjw_zoCqtBIWWEpiKGtU');

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  final Uri _urlll = Uri.parse(
      'mailto:Shakawapro@gmail.com?subject=${Uri.encodeFull('Statuses Contact')}&body=Send us a message we are happy to hear from you :)');
  void _launchUrlll() async {
    if (!await launchUrl(_urlll)) throw 'Could not launch $_urlll';
  }

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-6775155780565884/1588965913'
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
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            leadingWidth: 14.5.w,
            toolbarHeight: 7.6.h,
            leading: AppCubit.get(context).isSearching
                ? IconButton(
                    icon: Icon(IconBroken.Arrow___Left, size: 18.sp),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 2.sp),
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
                        child: const Image(
                          image: AssetImage('assets/images/tabBar.png'),
                        )),
                  ),
            title: AppCubit.get(context).isSearching
                ? SearchField()
                : Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Image(
                      image: const AssetImage('assets/images/QuotesGo.png'),
                      height: 40.sp,
                    ),
                  ),
            actions: buildAppBarActions(context),
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
                    : [Colors.black, Colors.blueGrey],
              )),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (SizerUtil.deviceType == DeviceType.mobile)
                      SizedBox(
                        height: 10.h,
                      ),
                    if (SizerUtil.deviceType == DeviceType.tablet)
                      SizedBox(
                        height: 3.h,
                      ),
                    Center(
                      child: Container(
                        height: 22.h,
                        child: const Image(
                          image: AssetImage(
                              'assets/images/LogoWithoutBackground.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.7.h,right: 2.7.h,top: 2.h,left: 2.h),
                      child: Row(
                        children: [
                          Image(
                            fit: BoxFit.cover,
                            color: Colors.white,
                            alignment: AlignmentDirectional.center,
                            height: 22.sp,
                            image: const AssetImage('assets/images/music.png'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Tap Sound',
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          SwitcherButton(
                            offColor: AppCubit.get(context).isDark == false
                                ? HexColor('#073eab')
                                : Colors.black,
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
                      padding: EdgeInsets.only(left: 2.h, right: 2.7.h),
                      child: Row(
                        children: [
                          Icon(MdiIcons.themeLightDark,
                              color: Colors.white, size: 25.sp),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          SwitcherButton(
                            size: 37.sp,
                            offColor: AppCubit.get(context).isDark == false
                                ? HexColor('#073eab')
                                : Colors.black,
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
                      padding: EdgeInsets.only(left: 2.h),
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
                            },
                            child: Row(
                              children: [
                                Icon(
                                  MdiIcons.shareVariantOutline,
                                  size: 25.sp,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Share App',
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
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
                      padding: EdgeInsets.only(left: 2.h),
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
                                Icon(
                                  IconBroken.Call,
                                  size: 25.sp,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Contact Us',
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
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
                      padding: EdgeInsets.only(left: 2.h),
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
                            },
                            child: Row(
                              children: [
                                Icon(
                                  IconBroken.Star,
                                  size: 25.sp,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Rate Us',
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
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
                      padding: EdgeInsets.only(left: 1.3.h),
                      child: Text(
                        'Application information',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white70,
                            fontFamily: 'VarelaRound'),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.7.h),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'App Version ',
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                            Padding(
                              padding: EdgeInsets.all(.8.h),
                              child: Text(
                                '1.0.0',
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 10.sp,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
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
                                      'Privacy Policy ',
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(.6.h),
                                      child: Text(
                                        'Click to go to the privacy policy',
                                        style: TextStyle(
                                            fontFamily: 'VarelaRound',
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
          body: StreamBuilder<QuerySnapshot>(
            stream: AppCubit.get(context).GetQoutes(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.size == 0) {
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 15),
                    child: ListView.separated(
                      itemCount: 12,
                      itemBuilder: (context, index) =>Row(
                        children: [
                          const Skeleton(height: 80, width: 80),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //     const Skeleton(width: 80),
                                const SizedBox(height: 16.0 / 2),
                                const Skeleton(),
                                const SizedBox(height: 16.0 / 2),
                                const Skeleton(),
                                const SizedBox(height: 16.0 / 2),
                                Row(
                                  children: const [
                                    Expanded(
                                      child: Skeleton(),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: Skeleton(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                    ));
              } else {
                AppCubit.get(context).Qoutes = [];
                List<String> Ids = [];
                for (var doc in snapshot.data!.docs) {
                  AppCubit.get(context).Qoutes.add(
                      QouteModel(name: doc['name'], iconImage: doc['icon']));
                  Ids.add(doc.id);
                }
                return ConditionalBuilder(
                  condition: AppCubit.get(context).Qoutes.length > 0,
                  builder: (BuildContext context) => Container(
                      child: ListView.separated(
                          itemBuilder: (context, index) => AppCubit.get(context)
                                  .searchTextController
                                  .text
                                  .isEmpty
                              ? ItemBuilder(
                                  context,
                                  AppCubit.get(context).Qoutes[index],
                                  Ids[index],
                                )
                              : ItemBuilder(
                                  context,
                                  AppCubit.get(context)
                                      .searchedForCharacters[index],
                                  Ids[index],
                                ),
                          separatorBuilder: (context, index) => Container(
                                height: 0,
                              ),
                          itemCount: AppCubit.get(context)
                                  .searchTextController
                                  .text
                                  .isEmpty
                              ? AppCubit.get(context).Qoutes.length
                              : AppCubit.get(context)
                                  .searchedForCharacters
                                  .length)),
                  fallback: (BuildContext context) =>
                      const Center(child: CircularProgressIndicator()),
                );
              }
            },
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

  @override
  void dispose() {
    _bottomBannerAd.dispose();
  //  AppCubit.get(context).myBanner.dispose();
    super.dispose();
  }
}

Widget ItemBuilder(context, QouteModel qout, String id) => InkWell(
      onTap: () async {
        if (AppCubit.get(context).music == true) {
          final file = await AudioCache().loadAsFile('mixin.wav');
          final bytes = await file.readAsBytes();
          AudioCache().playBytes(bytes);
        }
        //      AppCubit.get(context).loadInterstialAd();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QouteScreen(qout.name, id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppCubit.get(context).isDark == false
                ? Colors.white
                : Colors.black,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                color: AppCubit.get(context).isDark == false
                    ? Colors.black.withOpacity(0.1)
                    : Colors.white,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(2.4.h),
            child: Row(
              children: [
                Container(
                  child: CachedNetworkImage(
                    imageUrl: '${qout.iconImage}',
                    fit: BoxFit.cover,
                    placeholder: (context, imageProvider) =>
                        CupertinoActivityIndicator(),
                  ),
                  height: 38.sp,
                  width: 38.sp,
                  decoration: BoxDecoration(
                      color: AppCubit.get(context).isDark == false
                          ? Colors.transparent
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(.4.h)),
                      /*
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            '${qout.iconImage}',
                          )
                      )

                       */
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${qout.name}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: 'VarelaRound',
                          fontWeight: FontWeight.w600,
                          color: AppCubit.get(context).isDark == false
                              ? Colors.grey[700]
                              : Colors.white),
                    ),
                    SizedBox(
                      height: .8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.sp),
                          child: Container(
                              height: 2.h,
                              width: 4.w,
                              child: Image(
                                height: 15.sp,
                                color: Colors.grey,
                                image:
                                    const AssetImage('assets/images/email.png'),
                              )),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: AppCubit.get(context).GetNumberOfQoutes(id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.size == 0) {
                              return Text(
                                '0 Messages',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                    fontFamily: 'VarelaRound'),
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return Text(
                                '${snapshot.data!.docs.length} Messages',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                    fontFamily: 'VarelaRound'),
                                textAlign: TextAlign.center,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 1.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
