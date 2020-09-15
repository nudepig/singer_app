import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:singer_app/models/entity_factory.dart';
import 'package:singer_app/models/login_entity.dart';
import 'package:singer_app/view/my_icons.dart.dart';
import 'dart:async';
import 'dart:io';
import '../common.dart';
import 'config.dart';

const LOGIN_REG_URL = '$SERVER_HOST/user';

class UserInfogDao{

  static Future<LoginEntity> fetch(String strName,String strData, int genderIndex) async{
    try {
      Map<String,dynamic> map={"nickName":strName,"dateOfBirth":strData, 'sex': genderIndex, 'userType':'1'};
      Map<String,dynamic> token={"Authorization": AppConfig.token};
      Options options = Options(headers: {"Authorization": AppConfig.token});

      print(token);
      Response response = await Dio().put(LOGIN_REG_URL,data: map, options: options);
      response.data={'msg': '修改成功', 'code': 200};
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




