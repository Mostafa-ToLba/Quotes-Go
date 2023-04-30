
 import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubit.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';

class MakeQouteScreen extends StatefulWidget {
   const MakeQouteScreen({Key? key}) : super(key: key);

  @override
  State<MakeQouteScreen> createState() => _MakeQouteScreenState();
}

class _MakeQouteScreenState extends State<MakeQouteScreen> {
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);
  final Map<ColorSwatch<Object>, String> colorsNameMap =
  <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };
  late Color dialogPickerColor;


  // Color for picker using the color select dialog.

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: dialogPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color)
      {
        setState(() {
          dialogPickerColor = color;
          AppCubit.get(context).inputNode.unfocus();
        });
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context,
          Animation<double> a1,
          Animation<double> a2,
          Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(
              0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
      const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
  Future<bool> BackgroundColorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: AppCubit.get(context).BackgroundPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color)
      {
        setState(() {
          AppCubit.get(context).image = null;
      //    AppCubit.get(context).makeColor=2;
          AppCubit.get(context).BackgroundPickerColor = color;
          AppCubit.get(context).inputNode.unfocus();
        });
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context,
          Animation<double> a1,
          Animation<double> a2,
          Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(
              0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
      const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  /*
  StarMenuController centerStarMenuController = StarMenuController();
  StarMenuController centerStarMenuControllerr = StarMenuController();

   */
  GlobalKey key = GlobalKey();
  /*
  Future screenShotAndSave()
  async {
    setState(()  {
       AppCubit.get(context).changeToReadOnly();
    });
    Timer(Duration(seconds: 1),()
    async {
      await AppCubit.get(context).screenshotController.capture(delay: const Duration(milliseconds: 10)).then(( image) async {
        if (image != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File('${directory.path}/image.png').create();
          await imagePath.writeAsBytes(image);
          /// save
          await GallerySaver.saveImage(imagePath.path).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Downloaded Successfully To Gallery',
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

   */

  screenShotAndShare()
  async {
    await AppCubit.get(context).screenshotController.capture(delay: const Duration(milliseconds: 10)).then(( image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imagePath.path]);
      }
    });
  }


  late BannerAd _inlineBannerAd;
  bool _isInlineBannerAdLoaded = false;
  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      size: AdSize.banner,
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
  var TextController =TextEditingController();
  var TextChineseController =TextEditingController();
  var TextHindiController =TextEditingController();
  var TextRussiaController =TextEditingController();
  var TextbnController =TextEditingController();
  Offset offset = Offset.zero;
  @override
  void initState() {
    AppCubit.get(context).makeColor = 0 ;
    AppCubit.get(context).textForMakeScreen=0;
    AppCubit.get(context).ArabictextForMakeScreen=0;
    AppCubit.get(context).fontWeight=0;
    AppCubit.get(context).fontSize=0;
    AppCubit.get(context).fontAlignment=0;
    AppCubit.get(context).colorChange=0;
    AppCubit.get(context).textAlign=0;
    AppCubit.get(context).italicVariable=0;
    AppCubit.get(context).underLineVariable=0;
    _createInlineBannerAd();
    dialogPickerColor = Colors.white;
    AppCubit.get(context).BackgroundPickerColor=Colors.transparent;
    AppCubit.get(context).showInterstialAd();
    super.initState();
  }

  @override
  void dispose() {
    AppCubit.get(context).inputNode.dispose();
    super.dispose();
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<AppCubit,AppCubitStates>(
       listener: (BuildContext context, state) {  },
       builder: (BuildContext context, Object? state) {
         return Scaffold(
           resizeToAvoidBottomInset : false,
           appBar: AppBar(
             titleSpacing: 0,
             toolbarHeight: 7.6.h,
             leading:  IconButton(
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
             title: InkWell(
                 onTap: ()
                 async{

                 },
                 child: Text('make'.tr(),style: TextStyle(color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.w800,fontFamily:translator.activeLanguageCode=='ar'?'ElMessiri':'VarelaRound',),)),

             actions:
             [
               IconButton(
                 icon: Image(
                     image: AssetImage(
                       'assets/images/makedownload.png',
                     ),
                     color: Colors.white,
                     height: 20.sp),
                 onPressed: () async {
                   if(AppCubit.get(context).music==true)
                   {
                     final file = await AudioCache().loadAsFile('mixin.wav');
                     final bytes = await file.readAsBytes();
                     AudioCache().playBytes(bytes);
                   }
                   AppCubit.get(context).loadInterstialAd();
                       AppCubit.get(context).screenShotAndSave(context).then((value) =>
                       {
                         Timer(Duration(seconds: 3),()
                         {
                           AppCubit.get(context).showInterstialAd();
                         })
                       });
                 },
               ),
               SizedBox(width:.6.w),
               InkWell(
                 onTap: ()
                 async {
                   if(AppCubit.get(context).music==true)
                   {
                     final file = await AudioCache().loadAsFile('mixin.wav');
                     final bytes = await file.readAsBytes();
                     AudioCache().playBytes(bytes);
                   }
                   screenShotAndShare();
                 },
                 child: Image(
                     image: AssetImage(
                       'assets/images/sharee.png',
                     ),
                     color: Colors.white,
                     height: 20.sp,width: 5.5.w),
               ),
               SizedBox(width: 6.w),
           ],
           ),
           body: Column(
             children:
             [
               _isInlineBannerAdLoaded? Center(
                 child: Container(
                   padding: EdgeInsets.only(
                     bottom: 0,
                   ),
                   width: _inlineBannerAd.size.width.toDouble(),
                   height: _inlineBannerAd.size.height.toDouble(),
                   child: AdWidget(ad: _inlineBannerAd),
                 ),
               ):Container(color: Colors.white,),
               Expanded(
                 child: Stack(
                   alignment: Alignment.bottomCenter,
                   children: [
                     Screenshot(
                       controller:AppCubit.get(context).screenshotController,
                       child: Container(
                         height: 75.h,
                           decoration: AppCubit.get(context).BackgroundPickerColor==Colors.transparent?BoxDecoration(
                             image: DecorationImage(fit: BoxFit.cover,
                               image:AppCubit.get(context).image == null
                                   ? AppCubit.get(context).isDark?AppCubit.get(context).PhotoessForDark[AppCubit.get(context).makeColor]:AppCubit.get(context).Photoess[AppCubit.get(context).makeColor]
                                   : FileImage(AppCubit.get(context).image!)as ImageProvider,
                             ),
                           ):BoxDecoration(color:AppCubit.get(context).BackgroundPickerColor),
                         child: Stack(
                           children: [
                             Container(),
                             if(translator.activeLanguageCode!='zh'&&translator.activeLanguageCode!='hi'&&translator.activeLanguageCode!='ru'&&translator.activeLanguageCode!='bn')
                             Container(
                               child: Positioned(
                                 left: offset.dx,
                                 top: offset.dy,
                                 child: GestureDetector(
                                   onPanUpdate: (details) {
                                     setState(() {
                                       offset = Offset(
                                           offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                                     });
                                   },
                                   child: SizedBox(
                                     height: 100.h,
                                     width: 100.w,
                                     child: Padding(
                                       padding:  EdgeInsets.only(top: AppCubit.get(context).sliderForPadding),
                                       child: TextFormField(
                                         focusNode:AppCubit.get(context).inputNode,
                                         autofocus:false,readOnly: AppCubit.get(context).readOnly,
                                         maxLines: 15,
                                         minLines: 1,
                                         style: TextStyle(decoration:AppCubit.get(context).fontUnderLine[AppCubit.get(context).underLineVariable],fontStyle:AppCubit.get(context).fontItalicList[AppCubit.get(context).italicVariable],color:dialogPickerColor,fontSize: AppCubit.get(context).sliderSize,fontWeight: AppCubit.get(context).fontWeightList[AppCubit.get(context).fontWeight], fontFamily: translator.activeLanguageCode=='ar'?AppCubit.get(context).ArabicFonts[AppCubit.get(context).ArabictextForMakeScreen] :AppCubit.get(context).Texts[AppCubit.get(context).textForMakeScreen]),
                                         cursorColor: Colors.white,
                                         controller: TextController,textAlign:AppCubit.get(context).textAlignList[AppCubit.get(context).textAlign],
                                         decoration:
                                         InputDecoration(
                                           hintStyle: TextStyle(color: Colors.white,fontSize:14.sp,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound'),
                                           focusColor: Colors.blue,
                                           fillColor: Colors.blue,
                                           contentPadding: EdgeInsets.only(left: 10.sp,right: 10.sp),
                                           hintText: 'quoteMake'.tr(),
                                           //    border:InputBorder.none
                                           border:InputBorder.none,
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                             if(translator.activeLanguageCode=='zh')
                               Container(
                                 child: Positioned(
                                   left: offset.dx,
                                   top: offset.dy,
                                   child: GestureDetector(
                                     onPanUpdate: (details) {
                                       setState(() {
                                         offset = Offset(
                                             offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                                       });
                                     },
                                     child: SizedBox(
                                       height: 100.h,
                                       width: 100.w,
                                       child: Padding(
                                         padding:  EdgeInsets.only(top: AppCubit.get(context).sliderForPadding),
                                         child: TextFormField(
                                           focusNode:AppCubit.get(context).inputNode,
                                           autofocus:false,readOnly: AppCubit.get(context).readOnly,
                                           maxLines: 15,
                                           minLines: 1,
                                           style: TextStyle(decoration:AppCubit.get(context).fontUnderLine[AppCubit.get(context).underLineVariable],fontStyle:AppCubit.get(context).fontItalicList[AppCubit.get(context).italicVariable],color:dialogPickerColor,fontSize: AppCubit.get(context).sliderSize,fontWeight: AppCubit.get(context).fontWeightList[AppCubit.get(context).fontWeight], fontFamily: translator.activeLanguageCode=='zh'?AppCubit.get(context).chineseFonts[AppCubit.get(context).chineseForMakeScreen] :AppCubit.get(context).Texts[AppCubit.get(context).textForMakeScreen]),
                                           cursorColor: Colors.white,
                                           controller: TextChineseController,textAlign:AppCubit.get(context).textAlignList[AppCubit.get(context).textAlign],
                                           decoration:
                                           InputDecoration(
                                             hintStyle: TextStyle(color: Colors.white,fontSize:14.sp,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound'),
                                             focusColor: Colors.blue,
                                             fillColor: Colors.blue,
                                             contentPadding: EdgeInsets.only(left: 10.sp,right: 10.sp),
                                             hintText: 'quoteMake'.tr(),
                                             //    border:InputBorder.none
                                             border:InputBorder.none,
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             if(translator.activeLanguageCode=='hi')
                               Container(
                                 child: Positioned(
                                   left: offset.dx,
                                   top: offset.dy,
                                   child: GestureDetector(
                                     onPanUpdate: (details) {
                                       setState(() {
                                         offset = Offset(
                                             offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                                       });
                                     },
                                     child: SizedBox(
                                       height: 100.h,
                                       width: 100.w,
                                       child: Padding(
                                         padding:  EdgeInsets.only(top: AppCubit.get(context).sliderForPadding),
                                         child: TextFormField(
                                           focusNode:AppCubit.get(context).inputNode,
                                           autofocus:false,readOnly: AppCubit.get(context).readOnly,
                                           maxLines: 15,
                                           minLines: 1,
                                           style: TextStyle(decoration:AppCubit.get(context).fontUnderLine[AppCubit.get(context).underLineVariable],fontStyle:AppCubit.get(context).fontItalicList[AppCubit.get(context).italicVariable],color:dialogPickerColor,fontSize: AppCubit.get(context).sliderSize,fontWeight: AppCubit.get(context).fontWeightList[AppCubit.get(context).fontWeight], fontFamily: AppCubit.get(context).hindiFonts[AppCubit.get(context).hindiForMakeScreen]),
                                           cursorColor: Colors.white,
                                           controller: TextHindiController,textAlign:AppCubit.get(context).textAlignList[AppCubit.get(context).textAlign],
                                           decoration:
                                           InputDecoration(
                                             hintStyle: TextStyle(color: Colors.white,fontSize:14.sp,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound'),
                                             focusColor: Colors.blue,
                                             fillColor: Colors.blue,
                                             contentPadding: EdgeInsets.only(left: 10.sp,right: 10.sp),
                                             hintText: 'quoteMake'.tr(),
                                             //    border:InputBorder.none
                                             border:InputBorder.none,
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             if(translator.activeLanguageCode=='ru')
                               Container(
                                 child: Positioned(
                                   left: offset.dx,
                                   top: offset.dy,
                                   child: GestureDetector(
                                     onPanUpdate: (details) {
                                       setState(() {
                                         offset = Offset(
                                             offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                                       });
                                     },
                                     child: SizedBox(
                                       height: 100.h,
                                       width: 100.w,
                                       child: Padding(
                                         padding:  EdgeInsets.only(top: AppCubit.get(context).sliderForPadding),
                                         child: TextFormField(
                                           focusNode:AppCubit.get(context).inputNode,
                                           autofocus:false,readOnly: AppCubit.get(context).readOnly,
                                           maxLines: 15,
                                           minLines: 1,
                                           style: TextStyle(decoration:AppCubit.get(context).fontUnderLine[AppCubit.get(context).underLineVariable],fontStyle:AppCubit.get(context).fontItalicList[AppCubit.get(context).italicVariable],color:dialogPickerColor,fontSize: AppCubit.get(context).sliderSize,fontWeight: AppCubit.get(context).fontWeightList[AppCubit.get(context).fontWeight], fontFamily: AppCubit.get(context).russiaFonts[AppCubit.get(context).russiaForMakeScreen]),
                                           cursorColor: Colors.white,
                                           controller: TextRussiaController,textAlign:AppCubit.get(context).textAlignList[AppCubit.get(context).textAlign],
                                           decoration:
                                           InputDecoration(
                                             hintStyle: TextStyle(color: Colors.white,fontSize:14.sp,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound'),
                                             focusColor: Colors.blue,
                                             fillColor: Colors.blue,
                                             contentPadding: EdgeInsets.only(left: 10.sp,right: 10.sp),
                                             hintText: 'quoteMake'.tr(),
                                             //    border:InputBorder.none
                                             border:InputBorder.none,
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             if(translator.activeLanguageCode=='bn')
                               Container(
                                 child: Positioned(
                                   left: offset.dx,
                                   top: offset.dy,
                                   child: GestureDetector(
                                     onPanUpdate: (details) {
                                       setState(() {
                                         offset = Offset(
                                             offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                                       });
                                     },
                                     child: SizedBox(
                                       height: 100.h,
                                       width: 100.w,
                                       child: Padding(
                                         padding:  EdgeInsets.only(top: AppCubit.get(context).sliderForPadding),
                                         child: TextFormField(
                                           focusNode:AppCubit.get(context).inputNode,
                                           autofocus:false,readOnly: AppCubit.get(context).readOnly,
                                           maxLines: 15,
                                           minLines: 1,
                                           style: TextStyle(decoration:AppCubit.get(context).fontUnderLine[AppCubit.get(context).underLineVariable],fontStyle:AppCubit.get(context).fontItalicList[AppCubit.get(context).italicVariable],color:dialogPickerColor,fontSize: AppCubit.get(context).sliderSize,fontWeight: AppCubit.get(context).fontWeightList[AppCubit.get(context).fontWeight], fontFamily: AppCubit.get(context).bnFonts[AppCubit.get(context).bnForMakeScreen]),
                                           cursorColor: Colors.white,
                                           controller: TextbnController,textAlign:AppCubit.get(context).textAlignList[AppCubit.get(context).textAlign],
                                           decoration:
                                           InputDecoration(
                                             hintStyle: TextStyle(color: Colors.white,fontSize:14.sp,fontFamily:translator.isDirectionRTL(context)?'ElMessiri':'VarelaRound'),
                                             focusColor: Colors.blue,
                                             fillColor: Colors.blue,
                                             contentPadding: EdgeInsets.only(left: 10.sp,right: 10.sp),
                                             hintText: 'quoteMake'.tr(),
                                             //    border:InputBorder.none
                                             border:InputBorder.none,
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                           ],
                         ),
                       ),
                     ),
                     if(AppCubit.get(context).isSliderShow)
                     Positioned(
                       bottom: 0.h,
                       right: 2.w,
                       child: RotatedBox(
                         quarterTurns: 3,
                         child: Slider(value: AppCubit.get(context).sliderSize, onChanged: (double value)
                         {
                           setState(() {
                             AppCubit.get(context).sliderSize=value;
                             print(value);
                           });

                         },
                         min: 0,max: 100,activeColor: Colors.blue,inactiveColor: Colors.white,
                         ),
                       ),
                     ),
                     if(AppCubit.get(context).isFontsListShow && translator.activeLanguageCode!='zh'&&translator.activeLanguageCode!='hi'&&translator.activeLanguageCode!='ru'&&translator.activeLanguageCode!='bn' )
                       Container(
                         height:8.h,
                         child: ListView.separated(
                             physics: BouncingScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             shrinkWrap: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                             itemBuilder: (BuildContext, index)=>FontsList(translator.activeLanguageCode=='ar'?AppCubit.get(context).ArabicFonts[index]:AppCubit.get(context).Texts[index],context,index,translator.activeLanguageCode=='ar'?AppCubit.get(context).boolListForArabicFonts[index]:AppCubit.get(context).boolList[index]),
                             separatorBuilder:(BuildContext, int)=>Container(width: 12.sp),
                             itemCount: translator.activeLanguageCode=='ar'?AppCubit.get(context).ArabicFonts.length:AppCubit.get(context).Texts.length),
                       ),
                     if(AppCubit.get(context).isFontsListShow &&translator.activeLanguageCode=='zh')
                       Container(
                         height:8.h,
                         child: ListView.separated(
                             physics: BouncingScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             shrinkWrap: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                             itemBuilder: (BuildContext, index)=>chineseFontsList(AppCubit.get(context).chineseFonts[index],context,index,AppCubit.get(context).boolListForChineseFonts[index]),
                             separatorBuilder:(BuildContext, int)=>Container(width: 12.sp),
                             itemCount: AppCubit.get(context).chineseFonts.length),
                       ),
                     if(AppCubit.get(context).isFontsListShow &&translator.activeLanguageCode=='hi')
                       Container(
                         height:8.h,
                         child: ListView.separated(
                             physics: BouncingScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             shrinkWrap: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                             itemBuilder: (BuildContext, index)=>hindiFontsList(AppCubit.get(context).hindiFonts[index],context,index,AppCubit.get(context).boolListForHindiFonts[index]),
                             separatorBuilder:(BuildContext, int)=>Container(width: 12.sp),
                             itemCount: AppCubit.get(context).hindiFonts.length),
                       ),
                     if(AppCubit.get(context).isFontsListShow &&translator.activeLanguageCode=='ru')
                       Container(
                         height:8.h,
                         child: ListView.separated(
                             physics: BouncingScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             shrinkWrap: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                             itemBuilder: (BuildContext, index)=>russiaFontsList(AppCubit.get(context).russiaFonts[index],context,index,AppCubit.get(context).boolListForRussiaFonts[index]),
                             separatorBuilder:(BuildContext, int)=>Container(width: 12.sp),
                             itemCount: AppCubit.get(context).russiaFonts.length),
                       ),
                     if(AppCubit.get(context).isFontsListShow &&translator.activeLanguageCode=='bn')
                       Container(
                         height:8.h,
                         child: ListView.separated(
                             physics: BouncingScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             shrinkWrap: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                             itemBuilder: (BuildContext, index)=>bnFontsList(AppCubit.get(context).bnFonts[index],context,index,AppCubit.get(context).boolListForbnFonts[index]),
                             separatorBuilder:(BuildContext, int)=>Container(width: 12.sp),
                             itemCount: AppCubit.get(context).bnFonts.length),
                       ),
                     if(AppCubit.get(context).isSliderShow)
                       Padding(
                         padding:  EdgeInsets.only(bottom: 3.h),
                         child: Container(
                           height:3.h,
                           child: ListView.separated(
                               physics: BouncingScrollPhysics(),
                               scrollDirection: Axis.horizontal,
                               shrinkWrap: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                               itemBuilder: (BuildContext, index)=>IconsList(AppCubit.get(context).listOfIcons[index],context,index),
                               separatorBuilder:(BuildContext, int)=>Container(width: 15.sp),
                               itemCount: AppCubit.get(context).listOfIcons.length),
                         ),
                       ),
                     if(AppCubit.get(context).isRowTapped)
                     Row(
                       children: [
                         Expanded(
                           child: Container(
                             height:7.h,
                             child: ListView.separated(
                               physics: BouncingScrollPhysics(),
                               scrollDirection: Axis.horizontal,
                               shrinkWrap: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                                 itemBuilder: (BuildContext, index)=>picturesList(AppCubit.get(context).isDark?AppCubit.get(context).PhotoessForDark[index]:AppCubit.get(context).Photoess[index],context,index),
                                 separatorBuilder:(BuildContext, int)=>Container(width: 2.sp),
                                 itemCount: AppCubit.get(context).Photoess.length),
                           ),
                         ),
                         SizedBox(width: 2.w,),
                         Container(
                           height: 7.h,
                           width: 15.w,
                           decoration: BoxDecoration(),
                           child: IconButton(
                             icon: Image(fit: BoxFit.cover,
                                 image: AssetImage(
                                   'assets/images/colorwheel.png',
                                 ),
                                 height: 50.sp), onPressed: ()
                           async {
                             if(AppCubit.get(context).music==true)
                             {
                               final file = await AudioCache().loadAsFile('mixin.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             AppCubit.get(context).inputNode.unfocus();
                             BackgroundColorPickerDialog().then((value)
                             {
                               AppCubit.get(context).inputNode.unfocus();
                             });
                           },
                             padding:EdgeInsets.zero ,
                           ),
                         ),
                         Container(
                           height: 8.h,
                           width:18.w ,
                           decoration: BoxDecoration(),
                           child: IconButton(
                             icon: Image(fit: BoxFit.cover,
                               image: AssetImage(
                                 'assets/images/gallerypicker2.png',
                               ),
                               color: Colors.white,
                               height: 50.sp), onPressed: ()
                           async {
                             if(AppCubit.get(context).music==true)
                             {
                               final file = await AudioCache().loadAsFile('mixin.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             AppCubit.get(context).BackgroundPickerColor=Colors.transparent;
                             AppCubit.get(context).getImage();
                           },
                             padding:EdgeInsets.zero ,
                           ),
                         ),
                         /*
                         IconButton(onPressed: ()
                         {
                           colorPickerDialog();
                         }, icon: Icon(IconBroken.Image,size: 30.sp,color: dialogPickerColor,))

                          */
                       ],
                     ),
                     if(AppCubit.get(context).isCentered)
                       Padding(
                         padding:  EdgeInsets.only(bottom: 3.h),
                         child: Container(
                           height:3.3.h,
                           child: ListView.separated(
                               physics: BouncingScrollPhysics(),
                               scrollDirection: Axis.horizontal,
                               shrinkWrap: true,clipBehavior: Clip.antiAliasWithSaveLayer,
                               itemBuilder: (BuildContext, index)=>centeredList(AppCubit.get(context).listOfCentered[index],context,index),
                               separatorBuilder:(BuildContext, int)=>Container(width: 25.sp),
                               itemCount: AppCubit.get(context).listOfCentered.length),
                         ),
                       ),
                     if(AppCubit.get(context).isCentered)
                       Positioned(
                         bottom: 0.h,
                         right: 2.w,
                         child: RotatedBox(
                           quarterTurns: 3,
                           child: Slider(value: AppCubit.get(context).sliderForPadding, onChanged: (double value)
                           {
                             setState(() {
                               AppCubit.get(context).sliderForPadding=value;
                               print(value);
                             });

                           },
                             min: 0.h,max: 100.h,activeColor: Colors.blue,inactiveColor: Colors.white,
                           ),
                         ),
                       ),

                     /*
                     Padding(
                       padding:  EdgeInsets.only(bottom: 3.sp),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.end,
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
                               AppCubit.get(context).changeMakeColor(0);
                             },
                               child: Container(height: 7.h,width: 15.w,
                                   decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(4.sp),
                                       image:DecorationImage(image: AppCubit.get(context).Photoess[0],fit: BoxFit.cover)))),
                           SizedBox(width: .8.w),
                           InkWell(
                               onTap: ()
                               async {
                                 if(AppCubit.get(context).music==true)
                                 {
                                   final file = await AudioCache().loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 AppCubit.get(context).changeMakeColor(1);

                               },
                               child: Container(height: 7.h,width: 15.w,decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.sp),color: Colors.red,image:DecorationImage(image: AppCubit.get(context).Photoess[1],fit: BoxFit.cover,)))),
                           SizedBox(width: .8.w),
                           InkWell(
                               onTap: ()
                               async {
                                 if(AppCubit.get(context).music==true)
                                 {
                                   final file = await AudioCache().loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 AppCubit.get(context).changeMakeColor(2);
                               },
                               child: Container(height: 7.h,width: 15.w,decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.sp),color: Colors.red,image:DecorationImage(image: AppCubit.get(context).Photoess[2],fit: BoxFit.cover)))),
                           SizedBox(width: .8.w),
                           InkWell(
                               onTap: ()
                               async {
                                 if(AppCubit.get(context).music==true)
                                 {
                                   final file = await AudioCache().loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 AppCubit.get(context).changeMakeColor(3);
                               },
                               child: Container(height: 7.h,width: 15.w,decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.sp),color: Colors.red,image:DecorationImage(image: AppCubit.get(context).Photoess[3],fit: BoxFit.cover)))),
                           Expanded(
                             child: Container(height: 6.5.h,
                               decoration: BoxDecoration(),
                               child: IconButton(icon: Image(
                                   image: AssetImage(
                                     'assets/images/addPhoto.png',
                                   ),
                                   color: Colors.white,
                                   height: 50.sp), onPressed: ()
                               async {
                                 if(AppCubit.get(context).music==true)
                                 {
                                   final file = await AudioCache().loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 AppCubit.get(context).getImage();
                               },
                               padding:EdgeInsets.zero ,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),

                      */
                   ],
                 ),
               ),
               Container(color: AppCubit.get(context).isDark?Colors.black:Colors.blue,
                   height: 7.5.h,
                   child: Row(
                     children:
                     [
                       Expanded(
                         child: IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             alignment: AlignmentDirectional.center,
                             iconSize: 20.sp,
                             splashRadius: 26.sp,
                             onPressed: () async{
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               AppCubit.get(context).adCountForMakeScreen().then((value)
                               {
                                 if(AppCubit.get(context).interstialadCountForMakeScreen==4)
                                   AppCubit.get(context).showInterstialAd();
                                 if(AppCubit.get(context).interstialadCountForMakeScreen==0)
                                   AppCubit.get(context).loadInterstialAd();
                               });
                               setState(() {
                                 AppCubit.get(context).readOnly=false;
                                 AppCubit.get(context).openKeyboard(context).then((value)
                                 {
                                   AppCubit.get(context).inputNode.requestFocus();
                                 });
                               });
                               print('open');
                             },
                             padding: EdgeInsets.zero,
                             icon: Image(fit: BoxFit.cover,color: Colors.white,
                               alignment: AlignmentDirectional.center,
                               height: 22.sp,
                               image: const AssetImage('assets/images/writeText.png'),
                             )),
                       ),
                       Expanded(
                         child: Container(
                           decoration: AppCubit.get(context).isFontsListShow==true?BoxDecoration(shape: BoxShape.circle,color:AppCubit.get(context).isDark?Colors.grey:HexColor('#0080FF')):null,
                           child: IconButton(
                               splashColor: Colors.transparent,
                               highlightColor: Colors.transparent,
                               alignment: AlignmentDirectional.center,
                               iconSize: 22.sp,
                               splashRadius: 26.sp,
                               onPressed: () async{
                                 if(AppCubit.get(context).music==true)
                                 {
                                   final file = await AudioCache().loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 AppCubit.get(context).adCountForMakeScreen().then((value)
                                 {
                                   if(AppCubit.get(context).interstialadCountForMakeScreen==4)
                                     AppCubit.get(context).showInterstialAd();
                                   if(AppCubit.get(context).interstialadCountForMakeScreen==0)
                                     AppCubit.get(context).loadInterstialAd();
                                 });
                                 setState(() {
                                   AppCubit.get(context).showFontsListFun();
                        //         AppCubit.get(context).ChangeTextForMakeScreen();
                                 });
                               },
                               padding: EdgeInsets.zero,
                               icon: Image(fit: BoxFit.cover,color: Colors.white,
                                 alignment: AlignmentDirectional.center,
                                 height: 25.sp,
                                 image: const AssetImage('assets/images/textFont.png'),
                               )),
                         ),
                       ),
                       Expanded(
                         child: Container(
                           decoration: AppCubit.get(context).isRowTapped==true?BoxDecoration(shape: BoxShape.circle,color: AppCubit.get(context).isDark?Colors.grey:HexColor('#0080FF')):null,
                           child: IconButton(
                               splashColor: Colors.transparent,
                               highlightColor: Colors.transparent,
                               alignment: AlignmentDirectional.center,
                               iconSize: 24.sp,
                               splashRadius: 26.sp,
                               onPressed: () async{
                                 if(AppCubit.get(context).music==true)
                                 {
                                   final file = await AudioCache().loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 AppCubit.get(context).adCountForMakeScreen().then((value)
                                 {
                                   if(AppCubit.get(context).interstialadCountForMakeScreen==4)
                                     AppCubit.get(context).showInterstialAd();
                                 });
                                 /*
                                 setState(() {
                                   AppCubit.get(context).ChangePhotoForMakeScreen();
                                 });

                                  */
                                 /*
                                 AppCubit.get(context).inputNode.unfocus();
                                 BackgroundColorPickerDialog().then((value)
                                 {
                                   AppCubit.get(context).inputNode.unfocus();
                                 });

                                  */
                                 setState(() {
                                   AppCubit.get(context).showRowFun();
                                 });
                               },
                               padding: EdgeInsets.zero,
                               icon: Image(fit: BoxFit.cover,color: Colors.white,
                                 alignment: AlignmentDirectional.center,
                                 height: 19.sp,
                                 image:  AssetImage('assets/images/background.png'),
                               )),
                         ),
                       ),
                       /*
                       Expanded(
                         child: IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             iconSize: 22.sp,
                             splashRadius: 26.sp,
                             onPressed: () async{
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               setState(() {
                                 AppCubit.get(context).ChangeFontWeight();
                               });
                               print(AppCubit.get(context).fontWeight);
                             },
                             padding: EdgeInsets.zero,
                             icon:Image(fit: BoxFit.cover,color: Colors.white,
                               alignment: AlignmentDirectional.center,
                               height: 16.sp,
                               image: const AssetImage('assets/images/bold.png'),
                             )),
                       ),

                        */
                       /*
                       Expanded(
                         child: StarMenu(
                           params: StarMenuParameters.panel(context, columns: 4,).copyWith(centerOffset: Offset(-40.sp, -50.sp),),
                           controller: centerStarMenuController,
                           items: [
                             Image(height: 20.sp,color: Colors.blue,
                               image: const AssetImage('assets/images/leftAlign.png'),
                             ),
                             Image(height: 20.sp,color: Colors.blue,
                               image: const AssetImage('assets/images/centeredText.png'),
                             ),
                             Image(height: 20.sp,color: Colors.blue,
                               image: const AssetImage('assets/images/rightAlign.png'),
                             ),
                             Image(fit: BoxFit.cover,color: Colors.blue,
                               alignment: AlignmentDirectional.center,
                               height: 23.sp,
                               image: const AssetImage('assets/images/upDown.png'),
                             ),
                           ],      onItemTapped: (index, _)
                         async {
                           if(AppCubit.get(context).music==true)
                           {
                             final file = await AudioCache().loadAsFile('mixin.wav');
                             final bytes = await file.readAsBytes();
                             AudioCache().playBytes(bytes);
                           }
                           if(index==0)
                             setState(() {AppCubit.get(context).css(num:1);});
                           if(index==1)
                             setState(() {AppCubit.get(context).css(num:0);});
                           if(index==2)
                             setState(() {AppCubit.get(context).css(num:2);});
                           if(index==3)
                             setState(() {AppCubit.get(context).ChangeFontAlignment();});
                         },
                           child: Image(height: 17.sp,color: Colors.white,
                             image: const AssetImage('assets/images/centeredText.png'),
                           ),
                         ),
                       ),
                       4
                        */
                       Expanded(
                         child: Container(
                           decoration: AppCubit.get(context).isCentered==true?BoxDecoration(shape: BoxShape.circle,color:AppCubit.get(context).isDark?Colors.grey: HexColor('#0080FF')):null,
                           child: IconButton(
                               splashColor: Colors.transparent,
                               highlightColor: Colors.transparent,
                               alignment: AlignmentDirectional.center,
                               iconSize: 24.sp,
                               splashRadius: 26.sp,
                               onPressed: () async{
                                 if(AppCubit.get(context).music==true)
                                 {
                                   final file = await AudioCache().loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 AppCubit.get(context).adCountForMakeScreen().then((value)
                                 {
                                   if(AppCubit.get(context).interstialadCountForMakeScreen==4)
                                     AppCubit.get(context).showInterstialAd();
                                   if(AppCubit.get(context).interstialadCountForMakeScreen==0)
                                     AppCubit.get(context).loadInterstialAd();
                                 });
                                 setState(() {
                                   AppCubit.get(context).showCenteredFontFun();
                                 });
                               },
                               padding: EdgeInsets.zero,
                               icon: Image(height: 19.sp,color: Colors.white,
                             image: const AssetImage('assets/images/centeredText.png'),),),
                         ),
                       ),
                       Expanded(
                         child: Container(
                           decoration: AppCubit.get(context).isSliderShow==true?BoxDecoration(shape: BoxShape.circle,color:AppCubit.get(context).isDark?Colors.grey: HexColor('#0080FF')):null,
                           child: IconButton(
                               splashColor: Colors.transparent,
                               highlightColor: Colors.transparent,
                               iconSize: 24.sp,
                               splashRadius: 26.sp,
                               onPressed: () async{
                                 if(AppCubit.get(context).music==true)
                                 {
                                   final file = await AudioCache().loadAsFile('mixin.wav');
                                   final bytes = await file.readAsBytes();
                                   AudioCache().playBytes(bytes);
                                 }
                                 AppCubit.get(context).adCountForMakeScreen().then((value)
                                 {
                                   if(AppCubit.get(context).interstialadCountForMakeScreen==4)
                                     AppCubit.get(context).showInterstialAd();
                                   if(AppCubit.get(context).interstialadCountForMakeScreen==0)
                                     AppCubit.get(context).loadInterstialAd();
                                 });
                                 setState(() {
                     //            AppCubit.get(context).ChangeFontSize();
                                   AppCubit.get(context).showSliderFun();
                                 });

                               },
                               padding: EdgeInsets.zero,
                               icon: Image(fit: BoxFit.cover,color: Colors.white,
                                 alignment: AlignmentDirectional.center,
                                 height: 19.sp,
                                 image: const AssetImage('assets/images/textSize.png'),
                               )),
                         ),
                       ),
                       Expanded(
                         child: IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             iconSize: 24.sp,
                             splashRadius: 26.sp,
                             onPressed: () async{
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               AppCubit.get(context).adCountForMakeScreen().then((value)
                               {
                                 if(AppCubit.get(context).interstialadCountForMakeScreen==4)
                                   AppCubit.get(context).showInterstialAd();
                                 if(AppCubit.get(context).interstialadCountForMakeScreen==0)
                                   AppCubit.get(context).loadInterstialAd();
                               });
                               AppCubit.get(context).inputNode.unfocus();
                                 colorPickerDialog().then((value)
                                 {
                                   AppCubit.get(context).inputNode.unfocus();
                                 });
                             },
                             padding: EdgeInsets.zero,
                             icon:Image(fit: BoxFit.cover,color: Colors.white,
                               alignment: AlignmentDirectional.center,
                               height: 22.sp,
                               image: const AssetImage('assets/images/paint.png'),
                             )),
                       ),
                       /*
                       sssssss
                       IconButton(
                           splashColor: Colors.transparent,
                           highlightColor: Colors.transparent,
                           iconSize: 22.sp,
                           splashRadius: 26.sp,
                           onPressed: () async{
                             if(AppCubit.get(context).music==true)
                             {
                               final file = await AudioCache().loadAsFile('mixin.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             setState(() {
                               AppCubit.get(context).changeQuoteColorForMakeScreen();
                             });
                             print(AppCubit.get(context).fontWeight);
                           },
                           padding: EdgeInsets.zero,
                           icon:Image(fit: BoxFit.cover,color: Colors.white,
                             alignment: AlignmentDirectional.center,
                             height: 20.sp,
                             image: const AssetImage('assets/images/paint.png'),
                           )),
                       IconButton(
                           splashColor: Colors.transparent,
                           highlightColor: Colors.transparent,
                           iconSize: 22.sp,
                           splashRadius: 26.sp,
                           onPressed: () async{
                             if(AppCubit.get(context).music==true)
                             {
                               final file = await AudioCache().loadAsFile('mixin.wav');
                               final bytes = await file.readAsBytes();
                               AudioCache().playBytes(bytes);
                             }
                             setState(() {
                               AppCubit.get(context).changeQuoteAlignForMakeScreen();
                             });
                             print(AppCubit.get(context).fontWeight);
                           },
                           padding: EdgeInsets.zero,
                           icon:Image(fit: BoxFit.cover,color: Colors.white,
                             alignment: AlignmentDirectional.center,
                             height: 17.sp,
                             image: const AssetImage('assets/images/centeredText.png'),
                           )),
                          inchent
                        */

                       /*
                       Expanded(
                         child: IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             iconSize: 22.sp,
                             splashRadius: 26.sp,
                             onPressed: () async{
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               setState(() {
                                 AppCubit.get(context).changefontItalic();
                               });
                               print(AppCubit.get(context).fontWeight);
                             },
                             padding: EdgeInsets.zero,
                             icon:Image(fit: BoxFit.cover,color: Colors.white,
                               alignment: AlignmentDirectional.center,
                               height: 16.sp,
                               image: const AssetImage('assets/images/italicFont.png'),
                             )),
                       ),
                       Expanded(
                         child: IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             alignment: AlignmentDirectional.center,
                             iconSize: 18.sp,
                             splashRadius: 26.sp,
                             onPressed: () async{
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               setState(() {
                               AppCubit.get(context).changetextUnderLine();
                               });
                               print('open');
                             },
                             padding: EdgeInsets.only(right: 3.w),
                             icon: Image(fit: BoxFit.cover,color: Colors.white,
                               alignment: AlignmentDirectional.center,
                               height: 16.sp,
                               image: const AssetImage('assets/images/underlineText.png'),
                             )),
                       ),
                       Expanded(
                         child: IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             alignment: AlignmentDirectional.center,
                             iconSize: 18.sp,
                             splashRadius: 26.sp,
                             onPressed: () async {
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               setState(() {
                                 AppCubit.get(context).showRowFun();
                               });
                               print('open');
                             },
                             padding: EdgeInsets.only(right: 3.w),
                             icon: Icon(IconBroken.Camera,color: Colors.white)),
                       ),
                       Expanded(
                         child: IconButton(
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             alignment: AlignmentDirectional.center,
                             iconSize: 18.sp,
                             splashRadius: 26.sp,
                             onPressed: () async {
                               if(AppCubit.get(context).music==true)
                               {
                                 final file = await AudioCache().loadAsFile('mixin.wav');
                                 final bytes = await file.readAsBytes();
                                 AudioCache().playBytes(bytes);
                               }
                               setState(() {
                                 AppCubit.get(context).showSliderFun();
                               });
                               print('open');
                             },
                             padding: EdgeInsets.only(right: 3.w),
                             icon: Icon(IconBroken.Volume_Up,color: Colors.white)),
                       ),

                        */
                     ],
                   )),
             ],
           ),
         );
       },
     );
   }
}


 picturesList(AssetImage photoes,context, int index)=>InkWell(
     onTap: ()
     async {
       if(AppCubit.get(context).music==true)
       {
         final file = await AudioCache().loadAsFile('mixin.wav');
         final bytes = await file.readAsBytes();
         AudioCache().playBytes(bytes);
       }
       AppCubit.get(context).changeMakeColor(index);
     },
     child: Container(height: 7.h,width: 15.w,
         decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(4.sp),
             image:DecorationImage(image: photoes,fit: BoxFit.cover))));

 FontsList(String text, BuildContext context, int index, bool boolList)=>InkWell(
   onTap: ()
   async {
     if(AppCubit.get(context).music==true)
    {
       final file = await AudioCache().loadAsFile('mixin.wav');
       final bytes = await file.readAsBytes();
       AudioCache().playBytes(bytes);
     }
     if(translator.activeLanguageCode!='ar')
     {
       AppCubit.get(context).boolList =List<bool>.filled(21, false, growable: true);
       AppCubit.get(context).boolList[index]=true;
       AppCubit.get(context).changeFont(index);
     }
     if(translator.activeLanguageCode=='ar')
     {
       AppCubit.get(context).boolListForArabicFonts =List<bool>.filled(20, false, growable: true);
       AppCubit.get(context).boolListForArabicFonts[index]=true;
       AppCubit.get(context).changeArabicFont(index);
       print(text);
     }
   },
     child:
     translator.activeLanguageCode=='ar'?Text('عربي', style: TextStyle(fontSize: 25.sp,color: AppCubit.get(context).boolListForArabicFonts[index]==true?Colors.blue:Colors.white,fontFamily:text))
     :Text('Aa', style: TextStyle(fontSize: 25.sp,color: AppCubit.get(context).boolList[index]==true?Colors.blue:Colors.white,fontFamily:text)));

 chineseFontsList(String text, BuildContext context, int index, bool boolList)=>InkWell(
     onTap: ()
     async {
       if(AppCubit.get(context).music==true)
       {
         final file = await AudioCache().loadAsFile('mixin.wav');
         final bytes = await file.readAsBytes();
         AudioCache().playBytes(bytes);
       }
         AppCubit.get(context).boolListForChineseFonts =List<bool>.filled(15, false, growable: true);
         AppCubit.get(context).boolListForChineseFonts[index]=true;
         AppCubit.get(context).changeChineseFont(index);

     },
     child:Text('Aa', style: TextStyle(fontSize: 25.sp,color: AppCubit.get(context).boolListForChineseFonts[index]==true?Colors.blue:Colors.white,fontFamily:text)));
 hindiFontsList(String text, BuildContext context, int index, bool boolList)=>InkWell(
     onTap: ()
     async {
       if(AppCubit.get(context).music==true)
       {
         final file = await AudioCache().loadAsFile('mixin.wav');
         final bytes = await file.readAsBytes();
         AudioCache().playBytes(bytes);
       }
       AppCubit.get(context).boolListForHindiFonts =List<bool>.filled(15, false, growable: true);
       AppCubit.get(context).boolListForHindiFonts[index]=true;
       AppCubit.get(context).changeHindiFont(index);

     },
     child:Text('Aa', style: TextStyle(fontSize: 25.sp,color: AppCubit.get(context).boolListForHindiFonts[index]==true?Colors.blue:Colors.white,fontFamily:text)));
 russiaFontsList(String text, BuildContext context, int index, bool boolList)=>InkWell(
     onTap: ()
     async {
       if(AppCubit.get(context).music==true)
       {
         final file = await AudioCache().loadAsFile('mixin.wav');
         final bytes = await file.readAsBytes();
         AudioCache().playBytes(bytes);
       }
       AppCubit.get(context).boolListForRussiaFonts =List<bool>.filled(15, false, growable: true);
       AppCubit.get(context).boolListForRussiaFonts[index]=true;
       AppCubit.get(context).changeRussiaFont(index);

     },
     child:Text('Aa', style: TextStyle(fontSize: 25.sp,color: AppCubit.get(context).boolListForRussiaFonts[index]==true?Colors.blue:Colors.white,fontFamily:text)));
 bnFontsList(String text, BuildContext context, int index, bool boolList)=>InkWell(
     onTap: ()
     async {
       if(AppCubit.get(context).music==true)
       {
         final file = await AudioCache().loadAsFile('mixin.wav');
         final bytes = await file.readAsBytes();
         AudioCache().playBytes(bytes);
       }
       AppCubit.get(context).boolListForbnFonts =List<bool>.filled(15, false, growable: true);
       AppCubit.get(context).boolListForbnFonts[index]=true;
       AppCubit.get(context).changebnFont(index);

     },
     child:Text('Aa', style: TextStyle(fontSize: 25.sp,color: AppCubit.get(context).boolListForbnFonts[index]==true?Colors.blue:Colors.white,fontFamily:text)));
 IconsList(AssetImage listOfIcon, BuildContext context, int index)=>InkWell(
     onTap: ()
     async {
       if(AppCubit.get(context).music==true)
       {
         final file = await AudioCache().loadAsFile('mixin.wav');
         final bytes = await file.readAsBytes();
         AudioCache().playBytes(bytes);
       }
       AppCubit.get(context).editFontFunction(index);
     },
     child: Container(
         height: 3.h,
         child: Image(image: listOfIcon,color: Colors.white,height: 20.sp,)));

 centeredList(AssetImage listOfCentered, BuildContext context, int index)=> InkWell(
     onTap: ()
     async {
       if(AppCubit.get(context).music==true)
       {
         final file = await AudioCache().loadAsFile('mixin.wav');
         final bytes = await file.readAsBytes();
         AudioCache().playBytes(bytes);
       }
       AppCubit.get(context).editCenteredFontFunction(index);
     },
     child: Container(
         height: 3.h,
         child: Image(image: listOfCentered,color: Colors.white,height: 20.sp,)));



