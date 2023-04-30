
 import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/files.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:like_button/like_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:sizer/sizer.dart';
import 'package:statuses_only/AppCubit/appCubitStates.dart';
import 'package:statuses_only/shared/styles/icon_broken.dart';
 import 'package:http/http.dart' as http;
import '../AppCubit/appCubit.dart';

class OpenFavPhoto extends StatefulWidget {
  var photo;
    OpenFavPhoto(this.photo, {Key? key}) : super(key: key);

  @override
  State<OpenFavPhoto> createState() => _OpenFavPhotoState();
}

class _OpenFavPhotoState extends State<OpenFavPhoto> {

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
    super.initState();
  }
  bool isLiked =false;
  Future<bool> onLikeButtonTapped(bool isLiked,) async{

    if(AppCubit.get(context).music==true)
    {
      final file = await AudioCache().loadAsFile('mixin.wav');
      final bytes = await file.readAsBytes();
      AudioCache().playBytes(bytes);
    }
    /*
    if(AppCubit.get(context).IsFavoriteImagesList.containsValue(widget.photoesList.photo))
    {
      AppCubit.get(context).deleteDataFromImagePageForLikeButton(image: widget.photoesList.photo).then((value)
      {
        setState(() {
          AppCubit.get(context).getDataFromImageDatabaseeForLikeButton(AppCubit.get(context).database);
        });
      });

    }
    else
    {
      AppCubit.get(context).insertToDatabaseForImage(image: widget.photoesList.photo).then((value){
        setState(() {
          AppCubit.get(context).getDataFromImageDatabaseeForLikeButton(AppCubit.get(context).database);
        });});
    }

     */
    if(AppCubit.get(context).IsFavoriteImagesList.containsValue(widget.photo))
    {

      AppCubit.get(context).deleteDataFromImagePage(image:widget.photo);

    }
    else
    {
      AppCubit.get(context).insertToDatabaseForImage(image:widget.photo).then((value){
        AppCubit.get(context).getDataFromImageDatabasee(AppCubit.get(context).databaseForImages);
      });
    }
    return !isLiked;
  }
   @override
   Widget build(BuildContext context) {
     return AnnotatedRegion<SystemUiOverlayStyle>(
       value: const SystemUiOverlayStyle(
         statusBarColor: Colors.transparent,
         statusBarIconBrightness: Brightness.light,
       ),
       child: BlocConsumer<AppCubit, AppCubitStates>(
         listener: (BuildContext context, state) {},
         builder: (BuildContext context, Object? state) {
           return Scaffold(
             body: Stack(
               children: [
                 Container(
                   decoration: BoxDecoration(
                     image: DecorationImage(
                         image: NetworkImage(widget.photo.toString()),
                         fit: BoxFit.cover),
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.only(bottom: 2.h),
                   child: Align(
                     alignment: AlignmentDirectional.bottomCenter,
                     child: Container(
                       height: 10.h,
                       width: double.infinity,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Expanded(child: Container()),
                           Container(
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   backgroundBlendMode: BlendMode.softLight,
                                   color: Colors.black),
                               child: IconButton(
                                   onPressed: ()
                                   async{
                                     if(AppCubit.get(context).music==true)
                                     {
                                       final file = await AudioCache().loadAsFile('mixin.wav');
                                       final bytes = await file.readAsBytes();
                                       AudioCache().playBytes(bytes);
                                     }
                                   },
                                   icon: Image(
                                     image: AssetImage(
                                       'assets/images/instagram3.png',
                                     ),
                                     height: 21.sp,color: Colors.white,
                                   ))),
                           SizedBox(
                             width: 5.w,
                           ),
                           Container(
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   backgroundBlendMode: BlendMode.softLight,
                                   color: Colors.black),
                               child: IconButton(
                                   onPressed: () async {
                                     if(AppCubit.get(context).music==true)
                                     {
                                       final file = await AudioCache().loadAsFile('mixin.wav');
                                       final bytes = await file.readAsBytes();
                                       AudioCache().playBytes(bytes);
                                     }
                                     final urlImage = widget.photo;
                                     final url = Uri.parse(urlImage!);
                                     final response = await http.get(url);
                                     final bytes = response.bodyBytes;
                                     final temp = await getTemporaryDirectory();
                                     final path = '${temp.path}/image.jpg';
                                     File(path).writeAsBytesSync(bytes);
                                     XFile file = new XFile(path);
                                     shareWhatsapp.shareFile(file);
                                   },
                                   icon: Image(color: Colors.white,
                                     image: AssetImage(
                                       'assets/images/whatsapp3.png',
                                     ),
                                     height: 21.sp,
                                   ))),
                           SizedBox(
                             width: 5.w,
                           ),
                           /*
                           Container(
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   backgroundBlendMode: BlendMode.softLight,
                                   color: Colors.black),
                               child: IconButton(
                                 onPressed: ()
                                 async {
                                   if(AppCubit.get(context).music==true)
                                   {
                                     final file = await AudioCache().loadAsFile('mixin.wav');
                                     final bytes = await file.readAsBytes();
                                     AudioCache().playBytes(bytes);
                                   }
                                   if(AppCubit.get(context).IsFavoriteImagesList.containsValue(widget.photo))
                                   {

                                     AppCubit.get(context).deleteDataFromImagePage(image:widget.photo);

                                   }
                                   else
                                   {
                                     AppCubit.get(context).insertToDatabaseForImage(image: widget.photo).then((value){
                                       AppCubit.get(context).getDataFromImageDatabasee(AppCubit.get(context).databaseForImages);
                                     });
                                   }
                                 },
                                 icon:Icon(
           AppCubit.get(context).IsFavoriteImagesList.containsValue(widget.photo)?Icons.favorite:Icons.favorite_outline,
                                   color:AppCubit.get(context).IsFavoriteImagesList.containsValue(widget.photo)?Colors.red:Colors.white,size: 22.sp,),
                               )),
                            */
                           Container(
                             decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 backgroundBlendMode: BlendMode.softLight,
                                 color: Colors.black),alignment: Alignment.center,
                             child: Padding(
                               padding:EdgeInsets.only(right: translator.isDirectionRTL(context)? 2.sp:0),
                               child: LikeButton(
                                 padding: EdgeInsets.all(6.sp),
                                 size: 23.sp,
                                 circleColor: const CircleColor(start: Colors.red, end: Colors.red),
                                 bubblesColor: BubblesColor(
                                   dotPrimaryColor:AppCubit.get(context).isDark?Colors.red:Colors.red,
                                   dotSecondaryColor: AppCubit.get(context).isDark?Colors.purple:Colors.purple,
                                   dotLastColor: AppCubit.get(context).isDark?Colors.orange:Colors.orange,
                                   dotThirdColor: AppCubit.get(context).isDark?Colors.red:Colors.red,
                                 ),
                                 onTap: onLikeButtonTapped,
                                 isLiked: isLiked,
                                 likeBuilder: ( isLiked) {
                                   return Padding(
                                     padding:  EdgeInsets.only(top: .7.sp,left: .8.sp),
                                     child: Icon(
                                       AppCubit.get(context).IsFavoriteImagesList.containsValue(widget.photo)?Icons.favorite:Icons.favorite_outline,size:translator.isDirectionRTL(context)?22.sp:24.sp,
                                       color: AppCubit.get(context).IsFavoriteImagesList.containsValue(widget.photo)? Colors.red : Colors.white,
                                     ),
                                   );
                                 },
                               ),
                             ),
                           ),
                           SizedBox(
                             width: 5.w,
                           ),
                           Container(
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   backgroundBlendMode: BlendMode.softLight,
                                   color: Colors.black),
                               child: IconButton(
                                 onPressed: () async {
                                   if(AppCubit.get(context).music==true)
                                   {
                                     final file = await AudioCache().loadAsFile('mixin.wav');
                                     final bytes = await file.readAsBytes();
                                     AudioCache().playBytes(bytes);
                                   }
                                   final urlImage = widget.photo;
                                   final url = Uri.parse(urlImage!);
                                   final response = await http.get(url);
                                   final bytes = response.bodyBytes;
                                   final temp = await getTemporaryDirectory();
                                   final path = '${temp.path}/image.jpg';
                                   File(path).writeAsBytesSync(bytes);
                                   await Share.shareFiles([path]);
                                 },
                                 padding: EdgeInsets.only(right: 1.sp),
                                 icon: Image(
                                     image: AssetImage(
                                       'assets/newImages/shareNW.png',
                                     ),
                                     color: Colors.white,
                                     height: 20.sp),
                               )),
                           SizedBox(
                             width: 5.w,
                           ),
                           Container(
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   backgroundBlendMode: BlendMode.softLight,
                                   color: Colors.black),
                               child: IconButton(
                                 onPressed: () async {
                                   if(AppCubit.get(context).music==true)
                                   {
                                     final file = await AudioCache().loadAsFile('mixin.wav');
                                     final bytes = await file.readAsBytes();
                                     AudioCache().playBytes(bytes);
                                   }
                                   final temp = await getTemporaryDirectory();
                                   final path = '${temp.path}.jpg';
                                   await Dio()
                                       .download(widget.photo.toString(), path)
                                       .then((value) {
                                     GallerySaver.saveImage(path).then((value) {
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
                                   });
                                 },
                                 padding: EdgeInsets.only(top: 0.sp),
                                 icon: Image(
                                     image: AssetImage(
                                       'assets/images/makedownload.png',
                                     ),
                                     color: Colors.white,
                                     height: 22.sp),
                               )),
                           Expanded(child: Container()),
                         ],
                       ),
                     ),
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.only(top: 35.sp, left: 10.sp),
                   child: Align(
                     alignment: AlignmentDirectional.topStart,
                     child: Container(
                       height: 6.h,
                       width: 20.w,
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           backgroundBlendMode: BlendMode.softLight,
                           color: Colors.black),
                       child: IconButton(
                         icon: Icon(
                           translator.isDirectionRTL(context)?IconBroken.Arrow___Right:IconBroken.Arrow___Left,
                           color: Colors.white,
                           size: 22.sp,
                         ),
                         onPressed: () async {
                           if (AppCubit.get(context).music == true) {
                             final file =
                             await AudioCache().loadAsFile('mixin.wav');
                             final bytes = await file.readAsBytes();
                             AudioCache().playBytes(bytes);
                           }
                           Navigator.pop(context);
                         },
                       ),
                     ),
                   ),
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
           );
         },
       ),
     );
   }
}
