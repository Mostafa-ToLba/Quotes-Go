

class TypeOfPhotoesModel{

  String? photo;

  TypeOfPhotoesModel({this.photo});

  TypeOfPhotoesModel.fromJson(Map<String,dynamic>json)
  {
    photo=json['photo'];
  }

  Map<String,dynamic>toMap()
  {
    return {
      'photo':photo,
    };
  }

}