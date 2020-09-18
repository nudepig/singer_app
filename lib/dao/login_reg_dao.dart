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
    "token": "eyJhbGciOiJIUzUxMiJ9.eyJtb2JpbGVfbG9naW5fdXNlcl9rZXkiOiIxODM3MTQ1MDk3MCJ9.bLffzU6L8cy_Dq56olTU3Ss1qHdhjgUAkNkbYUJnu9R_Ef67UhH9nz5OzDmZz8qnU1GOmK8M00yRUgjyd5GO2w"
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




