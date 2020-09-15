import 'package:flutter/material.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/utils/date_select.dart';
import 'package:singer_app/view/customize_appbar.dart';
import 'package:singer_app/view/app_topbar.dart';
import 'package:singer_app/view/theme_ui.dart';
import 'package:singer_app/view/flutter_iconfont.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserSinger extends StatefulWidget {
  @override
  _UserSinger createState() => _UserSinger();
}

class _UserSinger extends State<UserSinger> {
  TextEditingController _strName = TextEditingController();
  TextEditingController _strRealName = TextEditingController();
  TextEditingController _strID = TextEditingController();
  TextEditingController _strBand = TextEditingController();

  String _strData = "";
  String _strGender = "";
  bool _groupValueb = true;

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
          _songNotice(),
          _songRealName(),
          _songID(),
          _songBand(),


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
                  child: ClipOval(
                    child: Image.asset(
                      "images/icon.jpg",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
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
                hintText: ' ' + '请填写昵称',
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
                border: InputBorder.none,
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
                      setState(() {});
                    }
                );
              },
            ),

          ]
      ),
    );
  }

  Widget _songNotice() {
    return Container(
      margin: EdgeInsets.only(top: AppSize.height(10)),
      padding: EdgeInsets.only(
          right: AppSize.width(80), left: AppSize.width(80)),
      height: AppSize.height(80),
      child: Text(
              '为了顺利提现请您提供正确的身份信息',
              style: TextStyle(
              color: Colors.grey,
            ),
            ),


    );
  }

  Widget _songRealName() {
    return Container(
      padding: EdgeInsets.only(
          right: AppSize.width(80), left: AppSize.width(80)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.name,
              controller: _strRealName,
              //maxLength: 4,
              //obscureText: true,
              textAlign : TextAlign.right,
              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.lock_outline),
                hintText: ' ' + '请输入真实姓名',
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
                '真实姓名',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ]
      ),
    );
  }

  Widget _songID() {
    return Container(
      padding: EdgeInsets.only(
          right: AppSize.width(80), left: AppSize.width(80)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.name,
              controller: _strID,
              //maxLength: 4,
              //obscureText: true,
              textAlign : TextAlign.right,
              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.lock_outline),
                hintText: ' ' + '请输入身份证号',
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
                '身份证号',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ]
      ),
    );
  }

  Widget _songBand() {
    return Container(
      padding: EdgeInsets.only(
          right: AppSize.width(80), left: AppSize.width(80)),
      height: AppSize.height(150),
      child: Stack(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.name,
              controller: _strBand,
              //maxLength: 4,
              //obscureText: true,
              textAlign : TextAlign.right,

              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.lock_outline),
                hintText: ' ' + '请输入银行卡号',
                hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: AppSize.height(30)),
                border: InputBorder.none,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: AppSize.width(40)),
              child: Text(
                '银行卡号',
                style: TextStyle(fontSize: AppSize.sp(40),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ]
      ),
    );
  }


  Widget _songSave() {
    return Container(
      margin: EdgeInsets.only(top: AppSize.height(20)),
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
          print("_strGender"+ _strGender);
//            loadLoginOrReg(_phoneNum.text, _codeword.text);
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
















}