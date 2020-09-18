import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/view/theme_ui.dart';
import 'package:singer_app/view/customize_appbar.dart';
import 'package:singer_app/utils/dialog_utils.dart';
import 'package:singer_app/utils/bottom_dialog.dart';
import '../common.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:singer_app/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:singer_app/dao/file_upload_dao.dart';
import 'package:singer_app/models/file_upload_entity.dart';
import 'package:singer_app/dao/config.dart';
import 'package:singer_app/utils/date_select.dart';
import 'package:singer_app/view/flutter_iconfont.dart';
import 'package:singer_app/view/my_icons_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPage createState() =>_MemberPage();
}
class _MemberPage extends State<MemberPage> {
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
      backgroundColor:Colors.white,
      appBar: MyAppBar(
        backgroundColor: ThemeColor.loignColor,
        preferredSize: Size.fromHeight(AppSize.height(0)),
        //child: CommonTopBar(title: "我的"),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _userInfo(),
          _userAccountBalance(),
          _userAccount(),
          _userOrderInfo(),
          _userCustomerService(),
          _userSignOut(),
        ],
      ),
    );
  }

  //头像区域
  Widget _topHeader() {
    return Container(
      color: ThemeColor.loignColor,
      height: AppSize.height(620),
      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
            Container(
              alignment: Alignment.center,
              child:Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(41),
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
            ),

          Container(
            height: AppSize.height(60),
            width: double.infinity,
            margin: EdgeInsets.only(
                top: AppSize.height(460)),
            //padding: const EdgeInsets.only(top: 15),
            child:Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: AppSize.width(240)),
                    width: AppSize.width(300),
                    child:Text(
                    '${AppConfig.nickName}',
                    textAlign : TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: AppSize.sp(51),
                        color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                ),
                  Container(
                    width: AppSize.width(100),
                    height: AppSize.height(50),
                    margin: EdgeInsets.only(
                        left: AppSize.width(30),top: AppSize.height(5)),
                    padding: EdgeInsets.only(
                        top: AppSize.height(6)),
                    decoration: BoxDecoration(
                      color: ThemeColor.small_sex,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child:Text(
                      '${AppConfig.sex} ${AppConfig.age}',
                      textAlign : TextAlign.center,
                      style: TextStyle(fontSize: AppSize.sp(31),
                          color: Colors.white),
                    ),
                  ),
            ],
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

  ///保存图像
  void loadSave(FormData formData, String token) async {
    FileEntity entity = await FileUploadDao.fetch(formData, token);
    if (entity?.msgModel != null) {
      setState(() {
        AppConfig.avatar = SERVER_HOST + entity.msgModel.avatar;
      });
    }
    DialogUtil.buildToast(entity.msgModel.msg);
  }

  Widget _userInfo() {
    return Container(
      height: AppSize.height(200),
      child: Stack(
          children: <Widget>[
            Container(
              height: AppSize.height(50),
              color: ThemeColor.loignColor,
            ),
            Container(
              height: AppSize.height(100),
              //color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
                color: Colors.white,
                margin: EdgeInsets.only(
                    top: AppSize.height(50)),
                child:TextField(
                  keyboardType: TextInputType.text,
                  //controller: _codeword,
                  //maxLength: 4,
                  //obscureText: true,
                  textAlign : TextAlign.center,
                  decoration: InputDecoration(
                    prefixIcon: Icon(MyIcons.singer_info,size: AppSize.sp(49),),
                    //hintText: "                                                                       请填写昵称",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: AppSize.height(50)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ThemeColor.song_lin),
                    ),
                  ),
            ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: AppSize.height(50)),
              padding: EdgeInsets.only(
                  top: AppSize.height(50),left: AppSize.width(120)),
              child: Text(
                '个人信息',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Container(
                margin: EdgeInsets.only(
                    top: AppSize.height(50)),
//              height: AppSize.height(50),
//              width: AppSize.width(400),
                padding: EdgeInsets.only(
                    left: AppSize.width(900),top: AppSize.height(30)),
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
                            size: AppSize.sp(100),
                            color: Colors.grey,
                        ),
                      ),
                    ]
                )
            ),

            InkWell(
              onTap: () {
                Routes.instance.navigateTo(context, Routes.user_song_info);
              }
            ),

          ]
      ),
    );
  }

  Widget _userAccountBalance() {
    return Container(
//      margin: EdgeInsets.only(
//          top: AppSize.height(0)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child:TextField(
                keyboardType: TextInputType.text,
                //controller: _codeword,
                //maxLength: 4,
                //obscureText: true,
                textAlign : TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(MyIcons.singer_balance,size: AppSize.sp(48),),
                  //hintText: "                                                                       请填写昵称",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: AppSize.height(50)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.song_lin),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: AppSize.height(50),left: AppSize.width(120)),
              child: Text(
                '余额',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Container(
//              height: AppSize.height(50),
//              width: AppSize.width(400),
                padding: EdgeInsets.only(
                    left: AppSize.width(900),top: AppSize.height(30)),
                child:Row(
                    children: <Widget>[
                      Expanded(
                        flex:3,
                        child:Text(
                          '${AppConfig.coins}',
                          textAlign : TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: AppSize.sp(40),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child:Icon(
                          IconFonts.arrow_right,
                          size: AppSize.sp(100),
                          color: Colors.grey,
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

  Widget _userAccount() {
    return Container(
//      margin: EdgeInsets.only(
//          top: AppSize.height(0)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child:TextField(
                keyboardType: TextInputType.text,
                //controller: _codeword,
                //maxLength: 4,
                //obscureText: true,
                textAlign : TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(MyIcons.singer_account,size: AppSize.sp(51),),
                  //hintText: "                                                                       请填写昵称",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: AppSize.height(50)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.song_lin),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: AppSize.height(50),left: AppSize.width(120)),
              child: Text(
                '账单信息',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Container(
//              height: AppSize.height(50),
//              width: AppSize.width(400),
                padding: EdgeInsets.only(
                    left: AppSize.width(900),top: AppSize.height(30)),
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
                          size: AppSize.sp(100),
                          color: Colors.grey,
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

  Widget _userOrderInfo() {
    return Container(
//      margin: EdgeInsets.only(
//          top: AppSize.height(0)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child:TextField(
                keyboardType: TextInputType.text,
                //controller: _codeword,
                //maxLength: 4,
                //obscureText: true,
                textAlign : TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(MyIcons.singer_order,size: AppSize.sp(46),),
                  //hintText: "                                                                       请填写昵称",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: AppSize.height(50)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ThemeColor.song_lin),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: AppSize.height(50),left: AppSize.width(120)),
              child: Text(
                '订单信息',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Container(
//              height: AppSize.height(50),
//              width: AppSize.width(400),
                padding: EdgeInsets.only(
                    left: AppSize.width(900),top: AppSize.height(30)),
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
                          size: AppSize.sp(100),
                          color: Colors.grey,
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

  Widget _userCustomerService() {
    return Container(
//      margin: EdgeInsets.only(
//          top: AppSize.height(0)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border:Border(bottom:BorderSide(width: 1,color: Color(0xFFF1F1F1)) )
            ),
          ),

            Container(
              margin: EdgeInsets.only(
                  top: AppSize.height(52),left: AppSize.width(42)),
              color: Colors.white,
              child:Icon(
                MyIcons.singer_qq,
                size: AppSize.sp(45),
            ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: AppSize.height(50),left: AppSize.width(120)),
              child: Text(
                '客服QQ',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Container(
                    width: AppSize.width(300),
                    margin: EdgeInsets.only(
                                top: AppSize.height(55),left: AppSize.width(740)),
//                padding: EdgeInsets.only(
//                    left: AppSize.width(850),top: AppSize.height(55)),
                child:Text(
                          '${AppConfig.qq}',
                          textAlign : TextAlign.right,
                          style: TextStyle(fontSize: AppSize.sp(40),
                            color: Colors.grey,
                          ),
                        ),

            ),


          ]
      ),
    );
  }

  Widget _userSignOut() {
    return Container(
//      margin: EdgeInsets.only(
//          top: AppSize.height(0)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child:TextField(
                keyboardType: TextInputType.text,
                //controller: _codeword,
                //maxLength: 4,
                //obscureText: true,
                textAlign : TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.power_settings_new,size: AppSize.sp(55),),
                  //hintText: "                                                                       请填写昵称",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: AppSize.height(50)),
//                  enabledBorder: UnderlineInputBorder(
//                    borderSide: BorderSide(color: ThemeColor.song_lin),
//                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: AppSize.height(50),left: AppSize.width(120)),
              child: Text(
                '退出登录',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Container(
//              height: AppSize.height(50),
//              width: AppSize.width(400),
                padding: EdgeInsets.only(
                    left: AppSize.width(900),top: AppSize.height(30)),
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
                          size: AppSize.sp(100),
                          color: Colors.grey,
                        ),
                      ),
                    ]
                )
            ),

            InkWell(
              onTap: () {
                _showExitDialog(context);
              },
            ),

          ]
      ),
    );
  }

  Widget _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('温馨提示'),
          content: Text('确定要退出登录吗？'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'),
              onPressed: () async {
                Navigator.of(context).pop();
                AppConfig.token='';
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("token", "");
                Routes.instance.navigateTo(context,Routes.ROOT);
              },
            ),
          ],
        );
      },
    );
  }




}

