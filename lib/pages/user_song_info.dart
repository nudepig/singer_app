import 'package:flutter/material.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/utils/date_select.dart';
import 'package:singer_app/view/customize_appbar.dart';
import 'package:singer_app/view/theme_ui.dart';
import 'package:singer_app/view/flutter_iconfont.dart';
import 'package:singer_app/utils/dialog_utils.dart';
import 'package:singer_app/utils/bottom_dialog.dart';
import '../common.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:singer_app/dao/file_upload_dao.dart';
import 'package:singer_app/models/file_upload_entity.dart';
import 'package:singer_app/dao/config.dart';

class UserSongInfo extends StatefulWidget {
  @override
  _UserSongInfo createState() => _UserSongInfo();
}

class _UserSongInfo extends State<UserSongInfo> {
  TextEditingController _strName = TextEditingController();

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
        preferredSize: Size.fromHeight(AppSize.height(100)),
        child: CommonSaveInfo(
            title: "个人信息",
            onBack: () => Navigator.pop(context)

        ),
      ),
      body:
      ListView(
        children: <Widget>[
          _topHeader(),
          _updateBaseInfo(),
          _updateBaseNotice(),
          _updateBaseCity(),
          _updateBaseUpload(),
          _updateBaseImage(),
        ],
      ),
    );
  }

  //头像区域
  Widget _topHeader() {
    return Container(
      //color: Colors.white,
      height: AppSize.height(240),
      width: double.infinity,
      margin: EdgeInsets.only(
                top: AppSize.height(40),left: AppSize.width(40), right: AppSize.width(40)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12,
            //offset: Offset(5.0, 5.0),
            blurRadius: 1, spreadRadius: 1)],
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
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: AppSize.width(30)),
  //            alignment: Alignment.center,
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: ClipOval(
                  child: _buildIsHasHead(),
                ),
            ),

              Container(
                    width: AppSize.width(500),
                    margin: EdgeInsets.only(left: AppSize.width(20)),
                    child:Text(
                      '${AppConfig.nickName}',
  //                    textAlign : TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: AppSize.sp(55),
                            color: Colors.black,fontWeight: FontWeight.w500),
                    ),
                  ),
            Container(
              //width: AppSize.width(50),
              margin: EdgeInsets.only(left: AppSize.width(140)),
              child:Icon(
                IconFonts.arrow_right,
                size: AppSize.sp(100),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///头像是否为空
  Widget _buildIsHasHead() {
    if (AppConfig.avatar==null||AppConfig.avatar.isEmpty) {
      return Image.asset(
        "images/icon.jpg",
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        "${AppConfig.avatar}",
        width: 70,
        height: 70,
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

  void loadSave(FormData formData, String token) async {
    FileEntity entity = await FileUploadDao.fetch(formData, token);
    if (entity?.msgModel != null) {
      setState(() {
        AppConfig.avatar = SERVER_HOST + entity.msgModel.avatar;
      });
    }
    DialogUtil.buildToast(entity.msgModel.msg);
  }

  Widget _updateBaseInfo() {
    return Container(
      //color: Colors.white,
      height: AppSize.height(390),
      width: double.infinity,
      margin: EdgeInsets.only(
          top: AppSize.height(50),left: AppSize.width(40), right: AppSize.width(40)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12,
            //offset: Offset(5.0, 5.0),
            blurRadius: 1, spreadRadius: 1)],
      ),

        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Container(
            height: AppSize.height(100),
            margin: EdgeInsets.only(
                top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
            child:Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: AppSize.height(45),left: AppSize.width(20)),
                  child: Text(
                    '*',
                    style: TextStyle(fontSize: AppSize.sp(40),
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
                ),

              Container(
                margin: EdgeInsets.only(
                    top: AppSize.height(35),left: AppSize.width(45)),
                child: Text(
                  '昵称',
                  style: TextStyle(fontSize: AppSize.sp(40),
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                    top: AppSize.height(50),left: AppSize.width(20),right: AppSize.width(20)),
                child:TextField(
                  keyboardType: TextInputType.name,
                  controller: _strName,
                  //maxLength: 4,
                  //obscureText: true,
                  textAlign : TextAlign.right,
                  decoration: InputDecoration(
                    //prefixIcon: Icon(Icons.),
                    hintText:  ' ' + '请填写昵称',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: AppSize.height(30)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ThemeColor.song_lin),
                    ),
                  ),
                ),
                ),
              ],
              ),
              ),
            Container(
              height: AppSize.height(100),
              margin: EdgeInsets.only(
                  top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
              child:Stack(
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
                      margin: EdgeInsets.only(
                          top: AppSize.height(45),left: AppSize.width(20)),
                      child: Text(
                        '*',
                        style: TextStyle(fontSize: AppSize.sp(40),
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          top: AppSize.height(35),left: AppSize.width(45)),
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
                            left: AppSize.width(680),top: AppSize.height(20)),

                        child:Row(
                            children: <Widget>[
                              Expanded(
                                flex:4,
                                child:Text(
                                  '${AppConfig.dateOfBirth}',
                                  style: TextStyle(fontSize: AppSize.sp(40),
                                    color: Colors.grey,
                                    // fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              Expanded(
                                flex:1,
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
                        JhPickerTool.showDatePicker(
                            context,
                            clickCallback: (var str,var time){
                              print(str);
                              print(time);
                              AppConfig.dateOfBirth = str;
                              setState(() {});
                            }
                        );
                      },
                    ),
                  ]
              ),
            ),

          Container(
            height: AppSize.height(100),
            margin: EdgeInsets.only(
            top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
            child:Stack(
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
                      border: InputBorder.none,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: AppSize.height(45),left: AppSize.width(20)),
                    child: Text(
                      '*',
                      style: TextStyle(fontSize: AppSize.sp(40),
                          color: Colors.red,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        top: AppSize.height(35),left: AppSize.width(45)),
                    child: Text(
                      '性别',
                      style: TextStyle(fontSize: AppSize.sp(40),
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Container(
                      padding: EdgeInsets.only(
                          left: AppSize.width(840),top: AppSize.height(20)),

                      child:Row(
                          children: <Widget>[
                            Expanded(
                              flex:1,
                              child:Text(
                                '${AppConfig.sex}',
                                style: TextStyle(fontSize: AppSize.sp(40),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              flex:1,
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
                            AppConfig.sex = str;
                            _strGenderIndex = index;
                            setState(() {});
                          }
                      );
                    },
                  ),

                ]
            ),
            ),
        ],
            ),
        );
      }

  Widget _updateBaseNotice() {
    return Container(
      margin: EdgeInsets.only(
          top: AppSize.height(30),left: AppSize.width(100)),
      child: Text(
        '性别每半年只能更改一次，请谨慎更改',
        style: TextStyle(fontSize: AppSize.sp(34),
            color: Colors.grey,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _updateBaseCity() {
    return Container(
      //color: Colors.white,
      height: AppSize.height(500),
      width: double.infinity,
      margin: EdgeInsets.only(
          top: AppSize.height(30),left: AppSize.width(40), right: AppSize.width(40)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12,
            //offset: Offset(5.0, 5.0),
            blurRadius: 1, spreadRadius: 1)],
      ),

      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: AppSize.height(100),
            margin: EdgeInsets.only(
                top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
            child:Stack(
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
                    margin: EdgeInsets.only(
                        top: AppSize.height(35),left: AppSize.width(45)),
                    child: Text(
                      '身高',
                      style: TextStyle(fontSize: AppSize.sp(40),
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Container(
//              height: AppSize.height(50),
//              width: AppSize.width(400),
                      padding: EdgeInsets.only(
                          left: AppSize.width(680),top: AppSize.height(20)),

                      child:Row(
                          children: <Widget>[
                            Expanded(
                              flex:4,
                              child:Text(
                                '${AppConfig.dateOfBirth}',
                                style: TextStyle(fontSize: AppSize.sp(40),
                                  color: Colors.grey,
                                  // fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            Expanded(
                              flex:1,
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
                      JhPickerTool.showDatePicker(
                          context,
                          clickCallback: (var str,var time){
                            print(str);
                            print(time);
                            AppConfig.dateOfBirth = str;
                            setState(() {});
                          }
                      );
                    },
                  ),
                ]
            ),
          ),
          Container(
            height: AppSize.height(100),
            margin: EdgeInsets.only(
                top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
            child:Stack(
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
                    margin: EdgeInsets.only(
                        top: AppSize.height(35),left: AppSize.width(45)),
                    child: Text(
                      '体重',
                      style: TextStyle(fontSize: AppSize.sp(40),
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Container(
//              height: AppSize.height(50),
//              width: AppSize.width(400),
                      padding: EdgeInsets.only(
                          left: AppSize.width(680),top: AppSize.height(20)),

                      child:Row(
                          children: <Widget>[
                            Expanded(
                              flex:4,
                              child:Text(
                                '${AppConfig.dateOfBirth}',
                                style: TextStyle(fontSize: AppSize.sp(40),
                                  color: Colors.grey,
                                  // fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            Expanded(
                              flex:1,
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
                      JhPickerTool.showDatePicker(
                          context,
                          clickCallback: (var str,var time){
                            print(str);
                            print(time);
                            AppConfig.dateOfBirth = str;
                            setState(() {});
                          }
                      );
                    },
                  ),
                ]
            ),
          ),

          Container(
            height: AppSize.height(100),
            margin: EdgeInsets.only(
                top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
            child:Stack(
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
                    margin: EdgeInsets.only(
                        top: AppSize.height(35),left: AppSize.width(45)),
                    child: Text(
                      '城市',
                      style: TextStyle(fontSize: AppSize.sp(40),
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Container(
                      padding: EdgeInsets.only(
                          left: AppSize.width(840),top: AppSize.height(20)),

                      child:Row(
                          children: <Widget>[
                            Expanded(
                              flex:1,
                              child:Text(
                                '${AppConfig.sex}',
                                style: TextStyle(fontSize: AppSize.sp(40),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              flex:1,
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
                            AppConfig.sex = str;
                            _strGenderIndex = index;
                            setState(() {});
                          }
                      );
                    },
                  ),

                ]
            ),
          ),

          Container(
            height: AppSize.height(100),
            margin: EdgeInsets.only(
                top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
            child:Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: AppSize.height(35),left: AppSize.width(45)),
                  child: Text(
                    '标签',
                    style: TextStyle(fontSize: AppSize.sp(40),
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                      top: AppSize.height(50),left: AppSize.width(20),right: AppSize.width(20)),
                  child:TextField(
                    keyboardType: TextInputType.name,
                    controller: _strName,
                    //maxLength: 4,
                    //obscureText: true,
                    textAlign : TextAlign.right,
                    decoration: InputDecoration(
                      //prefixIcon: Icon(Icons.),
                      hintText:  ' ' + '请填写标签',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppSize.height(30)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),










        ],
      ),
    );
  }

  Widget _updateBaseUpload() {
    return Container(
      margin: EdgeInsets.only(
          top: AppSize.height(5),left: AppSize.width(100)),
      child: Row(
        children: <Widget>[
        Text(
        '照片',
        style: TextStyle(fontSize: AppSize.sp(37),
            color: Colors.grey,
            fontWeight: FontWeight.w500),
        ),
        InkWell(
          onTap: () {
          
          },

          child:Container(
            width: AppSize.width(120),
            height: AppSize.height(60),
            padding: EdgeInsets.only(
                top: AppSize.height(6)),
            margin: EdgeInsets.only(
                left: AppSize.width(740),top: AppSize.height(10)),
            decoration: BoxDecoration(
              color: ThemeColor.loignColor,
              border: Border.all(width: 1, color: ThemeColor.loignColor),
              borderRadius: BorderRadius.circular(20),
            ),
              child: Text(
                  '上传',
                  textAlign : TextAlign.center,
                  style: TextStyle(fontSize: AppSize.sp(31),
                    color: Colors.white),
              ),
            ),
            ),

        ]
        ),
    );
  }

  Widget _updateBaseImage() {
    return Container(
      height: AppSize.height(308),
      color: Colors.white,
      margin: EdgeInsets.only(
          top: AppSize.height(20)),
      child: ListView(
        //设置水平方向排列
        scrollDirection: Axis.horizontal,
        //添加子元素
        children: <Widget>[
          Container(
            width: AppSize.width(300),
            padding: EdgeInsets.only(
                left: AppSize.width(50),top: AppSize.height(30),bottom: AppSize.height(30)),
            color: Colors.white,
            child:InkWell(
                onTap: () {
                  print('44444444444444444444');
                },
              child:Container(
                height: AppSize.height(240),
                width: AppSize.width(200),
                decoration: BoxDecoration(
                  //color: Colors.white,
                image: DecorationImage(
                  //image: NetworkImage('http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
                  image: ExactAssetImage('images/test.jpg'),
                  fit: BoxFit.cover,
                ),
                ),

                child:Container(
                  color: Colors.grey,
                  width: AppSize.width(25),
                  height: AppSize.height(45),
                  margin: EdgeInsets.only(
                      left: AppSize.width(175),right: AppSize.width(15),top: AppSize.height(15),bottom: AppSize.height(175)),
                  padding: EdgeInsets.only(
                      left: AppSize.width(5),right: AppSize.width(5),top: AppSize.height(5),bottom: AppSize.height(5)),

//                  child:FlatButton(
                    child:InkWell(
                      onTap: () {
                        print('333333333333333');
                      },

                      child:Image.asset(
                        'images/icon_delete.png',
                        width: AppSize.width(25),
                        height: AppSize.height(45),
                        fit: BoxFit.cover,
                      ),
                  ),
                ),
            ),
            ),
          ),
          Container(
            width: AppSize.width(300),
            padding: EdgeInsets.only(
                left: AppSize.width(50),top: AppSize.height(30),bottom: AppSize.height(30)),
            color: Colors.white,
            child:InkWell(
              onTap: () {
                print('44444444444444444444');
              },
              child:Container(
                height: AppSize.height(240),
                width: AppSize.width(200),
                decoration: BoxDecoration(
                  //color: Colors.white,
                  image: DecorationImage(
                    //image: NetworkImage('http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
                    image: ExactAssetImage('images/test.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),

                child:Container(
                  color: Colors.grey,
                  width: AppSize.width(25),
                  height: AppSize.height(45),
                  margin: EdgeInsets.only(
                      left: AppSize.width(175),right: AppSize.width(15),top: AppSize.height(15),bottom: AppSize.height(175)),
                  padding: EdgeInsets.only(
                      left: AppSize.width(5),right: AppSize.width(5),top: AppSize.height(5),bottom: AppSize.height(5)),

//                  child:FlatButton(
                  child:InkWell(
                    onTap: () {
                      print('333333333333333');
                    },

                    child:Image.asset(
                      'images/icon_delete.png',
                      width: AppSize.width(25),
                      height: AppSize.height(45),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: AppSize.width(300),
            padding: EdgeInsets.only(
                left: AppSize.width(50),top: AppSize.height(30),bottom: AppSize.height(30)),
            color: Colors.white,
            child:InkWell(
              onTap: () {
                print('44444444444444444444');
              },
              child:Container(
                height: AppSize.height(240),
                width: AppSize.width(200),
                decoration: BoxDecoration(
                  //color: Colors.white,
                  image: DecorationImage(
                    //image: NetworkImage('http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
                    image: ExactAssetImage('images/test.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),

                child:Container(
                  color: Colors.grey,
                  width: AppSize.width(25),
                  height: AppSize.height(45),
                  margin: EdgeInsets.only(
                      left: AppSize.width(175),right: AppSize.width(15),top: AppSize.height(15),bottom: AppSize.height(175)),
                  padding: EdgeInsets.only(
                      left: AppSize.width(5),right: AppSize.width(5),top: AppSize.height(5),bottom: AppSize.height(5)),

//                  child:FlatButton(
                  child:InkWell(
                    onTap: () {
                      print('333333333333333');
                    },

                    child:Image.asset(
                      'images/icon_delete.png',
                      width: AppSize.width(25),
                      height: AppSize.height(45),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: AppSize.width(300),
            padding: EdgeInsets.only(
                left: AppSize.width(50),top: AppSize.height(30),bottom: AppSize.height(30)),
            color: Colors.white,
            child:InkWell(
              onTap: () {
                print('44444444444444444444');
              },
              child:Container(
                height: AppSize.height(240),
                width: AppSize.width(200),
                decoration: BoxDecoration(
                  //color: Colors.white,
                  image: DecorationImage(
                    //image: NetworkImage('http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
                    image: ExactAssetImage('images/test.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),

                child:Container(
                  color: Colors.grey,
                  width: AppSize.width(25),
                  height: AppSize.height(45),
                  margin: EdgeInsets.only(
                      left: AppSize.width(175),right: AppSize.width(15),top: AppSize.height(15),bottom: AppSize.height(175)),
                  padding: EdgeInsets.only(
                      left: AppSize.width(5),right: AppSize.width(5),top: AppSize.height(5),bottom: AppSize.height(5)),

//                  child:FlatButton(
                  child:InkWell(
                    onTap: () {
                      print('333333333333333');
                    },

                    child:Image.asset(
                      'images/icon_delete.png',
                      width: AppSize.width(25),
                      height: AppSize.height(45),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

class CommonSaveInfo extends StatelessWidget {
  final String title;
  final Function onBack;

  CommonSaveInfo({
    @required this.title,
    this.onBack
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(child: Text(title,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Colors.white,fontSize: AppSize.sp(52)))),
        InkWell(
          onTap: onBack,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: AppSize.width(20)),
                child: Icon(IconFonts.arrow_left,color: Colors.white,size: AppSize.sp(80)),
              )
            ],),
        ),

        Container(
            margin: EdgeInsets.only(
                left: AppSize.width(850)),
          child: FlatButton(
            child: Text(
                '保存',
              style: TextStyle(fontSize: AppSize.sp(41),
                  color: Colors.white,fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              print('6666666666666save');
            },
          )
        )
      ],
    );
  }
}