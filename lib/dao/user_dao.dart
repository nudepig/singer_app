import 'package:dio/dio.dart';
import 'package:singer_app/common.dart';
import 'package:singer_app/models/entity_factory.dart';
import 'package:singer_app/models/login_entity.dart';
import 'package:singer_app/models/user_entity.dart';
import 'dart:async';

import 'config.dart';
const USER_URL = '$SERVER_HOST/mobile/user';

class UserDao{

  static Future<UserEntity> fetch(String token) async{
    try {
      Options options = Options(headers: {"Authorization":token});
      Response response = await Dio().get(USER_URL,options: options);
      print(response.data);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<UserEntity>(response.data);
      }else if(response.statusCode==401){
        AppConfig.token  = '';
      }else{
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      return null;
    }
  }

}