import 'package:dio/dio.dart';
import 'package:singer_app/models/entity_factory.dart';
import 'package:singer_app/models/login_entity.dart';
import 'dart:async';

import 'config.dart';

const LOGIN_REG_URL = '$SERVER_HOST/mobile/login';

class LoginRegDao{

  static Future<LoginEntity> fetch(String userName,String smsCode) async{
    try {
      Map<String,dynamic> map={"username":userName,"code":smsCode};
      Response response = await Dio().post(LOGIN_REG_URL,data: map);
      response.data={
    "msg": "操作成功",
    "code": 200,
    "token": "eyJhbGciOiJIUzUxMiJ9.eyJtb2JpbGVfbG9naW5fdXNlcl9rZXkiOiIxOTkyMDAwMDM0MSJ9.jrBKBZ-553IlB8aGCZ0uUAgSzm_GXIfJ4BUIaHWF5CeGkSMizeNMDEclwJsQO2lPloerzpH-m1UAieBlNSlAEw"
    };
      print(response.data);
      if(response.data['code'] == 200){
        return EntityFactory.generateOBJ<LoginEntity>(response.data);
      }else{
        throw Exception("Code: ${response.data['code']}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}




