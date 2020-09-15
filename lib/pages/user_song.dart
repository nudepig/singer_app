import 'package:flutter/material.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/utils/date_select.dart';
import 'package:singer_app/view/customize_appbar.dart';
import 'package:singer_app/view/app_topbar.dart';
import 'package:singer_app/view/theme_ui.dart';
import 'package:singer_app/view/flutter_iconfont.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:singer_app/utils/dialog_utils.dart';
import 'package:singer_app/utils/bottom_dialog.dart';
import 'package:singer_app/dao/user_info.dart';
import '../common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singer_app/models/login_entity.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:singer_app/dao/file_upload_dao.dart';
import 'package:singer_app/models/file_upload_entity.dart';
import 'package:singer_app/dao/config.dart';


class UserSong extends StatefulWidget {
  @override
  _UserSong createState() => _UserSong();
}

class _UserSong extends State<UserSong> {
  TextEditingController _strName = TextEditingController();

  String _strData = "";
  String _strGender = "";
  int _strGenderIndex = 0;
  bool _groupValueb = true;
  File primaryFile;
  File compressedFile;

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: ThemeColor.loignColor,
        preferredSize: Size.fromHeight(AppSize.height(130)),
        child: CommonBackTopBar(
            title: "填写信息", onBack: () => Navigator.pop(context)),
      ),
      body:
      ListView(
        children: <Widget>[
          _topHeader(),
          _songName(),
          _songBirthday(),
          _songGender(),
          _songSave(),
        ],
      ),
    );
  }

  Widget _topHeader() {
    return Container(
      height: AppSize.height(500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Stack(
              children: <Widget>[
                Container(
                  width: 102,
                  height: 102,
                  decoration: BoxDecoration(
                    //color: Colors.red,
                    border: Border.all(width: 2, color: ThemeColor.loignColor),
                    borderRadius: BorderRadius.circular(51),
                  ),

                  child:InkWell(
                    onTap: () {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            var list = List();
                            list.add('拍照');
                            list.add('相册');
                            return CommonBottomSheet(
                              //uses the custom alert dialog
                              list: list,
                              onItemClickListener: (index) {
                                if (index == 0) {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera);
                                } else if (index == 2) {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery);
                                }
                              },
                            );
                          });
                    },

                    child: ClipOval(
                      child: _buildIsHasHead(),
                    ),
                  ),
                ),

                Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(
                      top: AppSize.height(185), left: AppSize.height(185)),
                  decoration: BoxDecoration(
                    color: ThemeColor.loignColor,
                    border: Border.all(width: 2, color: ThemeColor.loignColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "images/camera.png",
                      width: 18,
                      height: 18,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

              ]
          ),

          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              '更换图像',
              style: TextStyle(fontSize: AppSize.sp(40),
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),

        ],
      ),
    );
  }

  ///头像是否为空
  Widget _buildIsHasHead() {
    if (AppConfig.avatar==null||AppConfig.avatar.isEmpty) {
      return Image.asset(
        "images/icon.jpg",
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        "${AppConfig.avatar}",
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _songName() {
    return Container(
      padding: EdgeInsets.only(
          right: AppSize.width(80), left: AppSize.width(80)),
      height: AppSize.height(150),
      child: Stack(
        children: <Widget>[
            TextField(
              keyboardType: TextInputType.name,
              controller: _strName,
              //maxLength: 4,
              //obscureText: true,
              textAlign : TextAlign.right,

              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.lock_outline),
                  hintText:  ' ' + '请填写昵称',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: AppSize.height(30)),
                  enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ThemeColor.song_lin),
                    ),
                ),
            ),
          Container(
            padding: EdgeInsets.only(
                top: AppSize.width(40)),
            child: Text(
              '昵称',
              style: TextStyle(fontSize: AppSize.sp(40),
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
                ),
          ),
      ]
      ),
    );
  }



  Widget _songBirthday() {
    return Container(
      padding: EdgeInsets.only(
          right: AppSize.width(80), left: AppSize.width(80)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[

            TextField(
              keyboardType: TextInputType.text,
              //controller: _codeword,
              //maxLength: 4,
              //obscureText: true,
              textAlign : TextAlign.center,
              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.lock_outline),
                //hintText: "                                                                       请填写昵称",
                hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: AppSize.height(30)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ThemeColor.song_lin),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: AppSize.width(40)),
              child: Text(
                '出生日期',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),

          Container(
//              height: AppSize.height(50),
//              width: AppSize.width(400),
              padding: EdgeInsets.only(
                  left: AppSize.width(650),top: AppSize.height(20)),

            child:Row(
              children: <Widget>[
              Expanded(
                  flex:4,
                  child:Text(
                    _strData,
                    style: TextStyle(fontSize: AppSize.sp(40),
                        color: Colors.black,
                       // fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              Expanded(
                  flex:1,
                  child:Icon(
                      IconFonts.arrow_right,
                      size: AppSize.sp(80)
                  ),
              ),
              ]
            )
          ),

            InkWell(
              onTap: () {
              //Future.delayed(Duration.zero, () => setState(() {

                JhPickerTool.showDatePicker(
                    context,
                    clickCallback: (var str,var time){
                      print(str);
                      print(time);
                      _strData = str;
                      setState(() {});
                    }
                );

              //}));
              },
            ),

          ]
      ),
    );
  }

  Widget _songGender() {
    return Container(
      padding: EdgeInsets.only(
          right: AppSize.width(80), left: AppSize.width(80)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              //controller: _codeword,
              //maxLength: 4,
              //obscureText: true,
              textAlign : TextAlign.center,
              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.lock_outline),
                //hintText: "                                                                       请填写昵称",
                hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: AppSize.height(30)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ThemeColor.song_lin),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: AppSize.width(40)),
              child: Text(
                '性别',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Container(
//              height: AppSize.height(50),
//              width: AppSize.width(400),
                padding: EdgeInsets.only(
                    left: AppSize.width(780),top: AppSize.height(20)),

                child:Row(
                    children: <Widget>[
                      Expanded(
                        flex:3,
                        child:Text(
                          _strGender,
                          style: TextStyle(fontSize: AppSize.sp(40),
                              color: Colors.black,
                              ),
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child:Icon(
                            IconFonts.arrow_right,
                            size: AppSize.sp(80)
                        ),
                      ),
                    ]
                )
            ),

            InkWell(
              onTap: () {
                var aa =  ["女","男"];
                JhPickerTool.showStringPicker(
                    context,
                    data: aa,
                    clickCallBack: (int index,var str){
                      print(str);
                      print(index);
                      _strGender = str;
                      _strGenderIndex = index;
                      setState(() {});
                    }
                );
              },
            ),

          ]
      ),
    );
  }


  Widget _songSave() {
    return Container(
        margin: EdgeInsets.only(top: AppSize.height(500)),
        padding: EdgeInsets.only(
            right: AppSize.width(80), left: AppSize.width(80)),
        height: AppSize.height(120),
        child: InkWell(
          onTap: () {
//                              _userPhone=_phoneNum.text;
//                              _smsCode=_codeword.text;
            if(_strName.text==null||_strName.text.isEmpty){
              Fluttertoast.showToast(
                  fontSize:AppSize.sp(13),
                  gravity: ToastGravity.CENTER,
                  msg: "请输入昵称~");
              return ;
            }
            if(_strData==null||_strData.isEmpty){
              Fluttertoast.showToast(
                  fontSize:AppSize.sp(13),
                  gravity: ToastGravity.CENTER,
                  msg: "请输入出生日期~");
              return ;
            }
            if(_strGender==null||_strGender.isEmpty){
              Fluttertoast.showToast(
                  fontSize:AppSize.sp(13),
                  gravity: ToastGravity.CENTER,
                  msg: "请输入性别~");
              return ;
            }
            print("_strName"+ _strName.text);
            print("_strData"+ _strData);
            print(_strGenderIndex);
            userInfo(_strName.text, _strData, _strGenderIndex);
          },
          child:Container(
//            width: double.infinity,
//            height: AppSize.height(152.64),

            padding: EdgeInsets.only(
                right: AppSize.width(60),
                left: AppSize.width(60)),

            child: Center(

                child: Text(
                  '完成',
                  style: TextStyle(
                      fontSize: AppSize.sp(52),
                      color: Colors.white),
                )),
            decoration: BoxDecoration(
              color: ThemeColor.loignColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
    );
  }

  void userInfo(String strName, String strData, int genderIndex) async {
    LoginEntity entity = await UserInfogDao.fetch(strName, strData, genderIndex);
    print(entity);
    if (entity?.userModel != null) {
      //saveUserInfo(entity.userModel);
      print('3333');

    } else {
      if(entity?.msgModel!=null) {
        DialogUtil.buildToast(entity.msgModel.msg);
      }else{
        DialogUtil.buildToast("保存失败");
      }
    }
  }


  ///上传头像
  _pickImage(ImageSource type) async {

    File imageFile = await ImagePicker.pickImage(source: type);
    setState(() {
      primaryFile = imageFile;
    });
    if (imageFile == null) return;
    final tempDir = await getTemporaryDirectory();

    CompressObject compressObject = CompressObject(
      imageFile: imageFile, //image
      path: tempDir.path, //compress to path
      quality: 85, //first compress quality, default 80
      step: 6, //compress quality step, The bigger the fast, Smaller is more accurate, default 6
    );
    Luban.compressImage(compressObject).then((_path) async {
      var name = _path.substring(_path.lastIndexOf("/") + 1, _path.length);
      print('name:'+name);
      FormData formData = FormData.fromMap({
        "avatarfile": await MultipartFile.fromFile(_path,filename: name),
      });
      loadSave(formData,AppConfig.token);

  });
  }

  void loadSave(FormData formData, String token) async {
    FileEntity entity = await FileUploadDao.fetch(formData, token);
    if (entity?.msgModel != null) {
      setState(() {
        AppConfig.avatar = SERVER_HOST + entity.msgModel.avatar;
        print('999999999');
        print(AppConfig.avatar);
      });
    }
    Navigator.pop(context);
    DialogUtil.buildToast(entity.msgModel.msg);
  }




}
