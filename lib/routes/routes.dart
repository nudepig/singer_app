import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:singer_app/pages/index_page.dart';
import 'package:singer_app/pages/reg_and_login.dart';
import 'package:singer_app/pages/user_agreement.dart';
import 'package:singer_app/pages/user_select.dart';
import 'package:singer_app/pages/user_singer.dart';
import 'package:singer_app/pages/user_song.dart';
import 'package:singer_app/pages/user_song_info.dart';
import 'package:singer_app/pages/create_room.dart';
import 'package:singer_app/pages/search_room.dart';
import 'package:singer_app/pages/invite_singer.dart';
import 'package:singer_app/pages/home_shop_page.dart';



class Routes {
  static final Router router = new Router();
  static const ROOT = '/';
  // details
  static const ORDER_DETAILS = '/order_details';
  static const PRODUCT_DETAILS = '/product_details';

  static const login_page = '/login_page';
  static const user_agreement = '/user_agreement';
  static const user_select = '/user_select';
  static const user_singer = '/user_singer';
  static const user_song = '/user_song';
  static const user_song_info = '/user_song_info';
  static const create_room = '/create_room';
  static const search_room = '/search_room';
  static const invite_singer = '/invite_singer';
  static const home_page = '/home_page';


  void _config() {
    router.define(
        ROOT, handler: Handler(handlerFunc: (context, params) => IndexPage()));
    router.define(
        login_page, handler: Handler(handlerFunc: (context, params) => RegPageAndLoginPage()));
    router.define(
        user_agreement, handler: Handler(handlerFunc: (context, params) => UserAgreement()));
    router.define(
        user_select, handler: Handler(handlerFunc: (context, params) => UserSelect()));
    router.define(
        user_singer, handler: Handler(handlerFunc: (context, params) => UserSinger()));
    router.define(
        user_song, handler: Handler(handlerFunc: (context, params) => UserSong()));
    router.define(
        user_song_info, handler: Handler(handlerFunc: (context, params) => UserSongInfo()));
    router.define(
        create_room, handler: Handler(handlerFunc: (context, params) => CreateRoom()));
    router.define(
        search_room, handler: Handler(handlerFunc: (context, params) => Search_Room()));
    router.define(
        invite_singer, handler: Handler(handlerFunc: (context, params) => Invite_Singer()));
    router.define(
        home_page, handler: Handler(handlerFunc: (context, params) => HomePage()));




  }

  /**
   * 传递多参数
   */
  Future navigateToParams(BuildContext context, String path, {Map<String, dynamic> params}) {
    String query =  "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
//    print('我是navigateTo传递的参数：$query');
    path = path + query;
    return router.navigateTo(context, path, transition: TransitionType.inFromRight);
  }


  Future navigateTo(BuildContext context, String path){

    return router.navigateTo(context,path,transition: TransitionType.inFromRight);
  }
  Future navigateToReplace(BuildContext context, String path,{Map<String, dynamic> params}){
    String query =  "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
//    print('我是navigateTo传递的参数：$query');
    path = path + query;
    return router.navigateTo(context,path,replace: true,transition: TransitionType.inFromRight);
  }

  Future navigateFromBottom(BuildContext context, String path,[String param='']){
    var p = param.isNotEmpty?'$path/$param':path;
    return router.navigateTo(context,p,transition: TransitionType.inFromBottom);
  }

  factory Routes() =>_getInstance();
  static Routes get instance => _getInstance();
  static Routes _instance;

  Routes._internal() {
    _config();
  }
  static Routes _getInstance() {
    if (_instance == null) {
      _instance = new Routes._internal();
    }
    return _instance;
  }
}
