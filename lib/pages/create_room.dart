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
import 'package:singer_app/routes/routes.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:singer_app/dao/file_upload_dao.dart';
import 'package:singer_app/models/file_upload_entity.dart';
import 'package:singer_app/dao/config.dart';


class CreateRoom extends StatefulWidget {
  @override
  _CreateRoom createState() => _CreateRoom();
}

class _CreateRoom extends State<CreateRoom> {
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
        backgroundColor: Colors.white,
        preferredSize: Size.fromHeight(AppSize.height(100)),

        child: CommonSaveInfo(
            title: "创建房间",
            onBack: () => Navigator.pop(context)

        ),
      ),
      body:
      ListView(
        children: <Widget>[
          _topHeader(),
          _createRoom(),
          _createInvitation(),
        ],
      ),
    );
  }

  //房间区域
  Widget _topHeader() {
    return Container(
      //color: Colors.white,
      height: AppSize.height(610),
      width: double.infinity,
      margin: EdgeInsets.only(
          top: AppSize.height(40),left: AppSize.width(40), right: AppSize.width(40)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(5),
      ),

      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
        Container(
          height: AppSize.height(280),
          width: double.infinity,
          margin: EdgeInsets.only(left: AppSize.width(20), right: AppSize.width(20)),
          decoration: BoxDecoration(
              border:Border(bottom:BorderSide(width: 1,color: Color(0xFFF1F1F1)) )
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
                  width: AppSize.width(360),
                  margin: EdgeInsets.only(left: AppSize.width(20)),
                  child:Text(
                    '房间图片',
                    //                    textAlign : TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: AppSize.sp(45),
                        color: Color(0xFF333333),fontWeight: FontWeight.w500),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: AppSize.width(190)),
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
                  //width: AppSize.width(50),
                  margin: EdgeInsets.only(left: AppSize.width(30)),
                  child:Icon(
                    IconFonts.arrow_right,
                    size: AppSize.sp(100),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ),
            Container(
              height: AppSize.height(150),
              margin: EdgeInsets.only(
                  top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(10)),
              child:Stack(
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.only(
                        top: AppSize.height(40),left: AppSize.width(15)),
                    child: Text(
                      '房间名称',
                      style: TextStyle(fontSize: AppSize.sp(45),
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
                        hintText:  ' ' + '请填写房间名称',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(45)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: AppSize.height(60)),
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
                        border: InputBorder.none,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          top: AppSize.height(35),left: AppSize.width(15)),
                      child: Text(
                        '房间地点',
                        style: TextStyle(fontSize: AppSize.sp(45),
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

  ///头像是否为空
  Widget _buildIsHasHead() {
    if (AppConfig.avatar==null||AppConfig.avatar.isEmpty) {
      return Image.asset(
        "images/icon.jpg",
        width: 72,
        height: 72,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        "${AppConfig.avatar}",
        width: 72,
        height: 72,
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


  Widget _createRoom() {
    return Container(
      margin: EdgeInsets.only(
          top: AppSize.height(30),left: AppSize.width(70)),
      child: Row(
          children: <Widget>[
            Text(
              '邀请人员',
              style: TextStyle(fontSize: AppSize.sp(45),
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500),
            ),
            InkWell(
              onTap: () {
                Routes.instance.navigateTo(context, Routes.invite_singer);
              },

              child:Container(
                width: AppSize.width(173),
                height: AppSize.height(78),
                padding: EdgeInsets.only(
                    top: AppSize.height(8)),
                margin: EdgeInsets.only(
                    left: AppSize.width(600),top: AppSize.height(10)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: ThemeColor.loignColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '邀请',
                  textAlign : TextAlign.center,
                  style: TextStyle(fontSize: AppSize.sp(45),
                      color: ThemeColor.loignColor),
                ),
              ),
            ),

          ]
      ),
    );
  }

  Widget _createInvitation() {
    return Container(
      //color: Colors.white,
      height: AppSize.height(180),
      width: double.infinity,
      margin: EdgeInsets.only(
          top: AppSize.height(40),left: AppSize.width(40), right: AppSize.width(40)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(5),
      ),

        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: AppSize.width(30)),
              //            alignment: Alignment.center,
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(26),
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
                style: TextStyle(fontSize: AppSize.sp(41),
                    color: Colors.black,fontWeight: FontWeight.w500),
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
            style: TextStyle(color: Colors.black,fontSize: AppSize.sp(52)))),
        InkWell(
          onTap: onBack,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: AppSize.width(20)),
                child: Icon(IconFonts.arrow_left,color: Colors.black,size: AppSize.sp(80)),
              )
            ],),
        ),

        Container(
            margin: EdgeInsets.only(
                left: AppSize.width(850)),
            child: FlatButton(
              child: Text(
                '创建',
                style: TextStyle(fontSize: AppSize.sp(41),
                    color: Colors.black,fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Routes.instance.navigateTo(context, Routes.home_page);
              },
            )
        )
      ],
    );
  }
}