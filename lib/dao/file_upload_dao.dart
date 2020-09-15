import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:singer_app/models/entity_factory.dart';
import 'package:singer_app/models/file_upload_entity.dart';
import 'dart:async';
import 'config.dart';
const FILE_UPLOAD_URL = '$SERVER_HOST/mobile/user/avatar';

class FileUploadDao{

  static Future<FileEntity> fetch(FormData formData,String token) async{
    try {
      Options options = Options(headers: {"Authorization":token});
      //Map<String,dynamic> map={"fileType":"KTP_IMG"};
      Response response = await Dio().post(FILE_UPLOAD_URL,
          data:formData,
          options: options,onSendProgress: (int sent, int total) {
        print("$sent $total"); //send是上传的大小 total是总文件大小
      },);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<FileEntity>(response.data);
      }else{
        throw Exception("StatusCode: ${response.data.code}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}




