import 'package:flutter/material.dart';
import 'package:singer_app/dao/login_dao.dart';
import 'package:singer_app/dao/login_reg_dao.dart';
import 'package:singer_app/dao/user_dao.dart';
import 'package:singer_app/models/login_entity.dart';
import 'package:singer_app/pages/reset_pwd_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:singer_app/receiver/event_bus.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/utils/dialog_utils.dart';
import 'package:singer_app/view/customize_appbar.dart';
import 'package:singer_app/view/flutter_iconfont.dart';
import 'package:singer_app/view/theme_ui.dart';
import 'package:singer_app/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common.dart';


class RegPageAndLoginPage extends StatefulWidget {
  @override
  _RegAndLoginState createState() => _RegAndLoginState();
}

class _RegAndLoginState extends State<RegPageAndLoginPage> {
  TextEditingController _phoneNum = TextEditingController();
  TextEditingController _codeword = TextEditingController();

  ///用户账号
  String _userPhone = "";
  bool _groupValueb = true;

  ///用户密码
  String _pwd = "";
  String _smsCode = "";
  bool isSendSms = false;

  bool _isObscure = true;
  IconData _icon = IconFonts.eye_close;

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
      appBar: MyAppBar(
        preferredSize: Size.fromHeight(AppSize.height(0)),
        //child: CommonBackTopBar(
            //title: "登录注册", onBack: () => Navigator.pop(context)),
      ),
      body:
           Container(
                //color: ThemeColor.appBg,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: AppSize.height(216),
                        width: AppSize.width(216),
                        margin: EdgeInsets.only(top: AppSize.height(316.8),bottom: AppSize.height(249.12)),
                        decoration: BoxDecoration(
                          //color: Colors.red,
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage("images/login_logo.png")),

                      ),
                      Container(
                        padding: EdgeInsets.only(
                            right: AppSize.width(80), left: AppSize.width(80)),
                        //decoration: ThemeDecoration.card,
                        child: Column(
                          children: <Widget>[


                            Padding(
                              padding: EdgeInsets.only(
                                  top: AppSize.height(0), bottom: AppSize.height(40)),
                              child: Row(

                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    //padding: EdgeInsets.only(right: AppSize.height(8)),
                                    child: TextField(
                                      keyboardType: TextInputType.phone,
                                      controller: _phoneNum,
                                      //maxLength: 4,
                                      //obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: "请输入手机号",
                                        hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                                      ),
//                                      onChanged: (inputStr) {
//                                        //print("smscode   " + inputStr);
//                                        _userPhone = inputStr;
//                                        print(_phoneNum.text);
//                                      },
                                    ),
                                  ),
                                Expanded(
                                    flex: 2,
                                      child: ResetCodePage(
                                          onTapCallback: () {}, phoneNum: _phoneNum.text,
                                      )

                                  )
                                ],
                              ),
                            ),

                            TextField(
                                keyboardType: TextInputType.number,
                                controller: _codeword,
                                //maxLength: 4,
                                //obscureText: true,
                                decoration: InputDecoration(
                                  //prefixIcon: Icon(Icons.lock_outline),
                                  hintText: "请输入验证码",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: AppSize.sp(40)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: AppSize.height(30))
                                ),

//                                onChanged: (inputStr) {
//                                  //print("smscode   " + inputStr);
//                                  _smsCode = inputStr;
//                                },
                              ),

                          InkWell(
                            onTap: () {
//                              _userPhone=_phoneNum.text;
//                              _smsCode=_codeword.text;
                              if(_phoneNum.text==null||_phoneNum.text.isEmpty){
                                Fluttertoast.showToast(
                                    fontSize:AppSize.sp(13),
                                    gravity: ToastGravity.CENTER,
                                    msg: "请输入手机号码或验证码~");
                                return ;
                              }
                              if(_codeword.text==null||_codeword.text.isEmpty){
                                Fluttertoast.showToast(
                                    fontSize:AppSize.sp(13),
                                    gravity: ToastGravity.CENTER,
                                    msg: "请输入手机号码或验证码~");
                                return ;
                              }
                              print("_userPhone"+_phoneNum.text);
                              print("_smsCode"+ _codeword.text);
                              loadLoginOrReg(_phoneNum.text, _codeword.text);
                            },
                            child:Container(
                                width: double.infinity,
                                height: AppSize.height(152.64),
                                margin: EdgeInsets.only(top: AppSize.height(231.84)),
                                padding: EdgeInsets.only(
                                    right: AppSize.width(60),
                                    left: AppSize.width(60)),


                                child: Center(

                                    child: Text(
                                      '立即登录',
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


                            /// 协议
                            Container(
                              margin: EdgeInsets.only(top: AppSize.height(230)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[
                                  Checkbox(
                                    ///给单选按钮设置一个标签（名字），方便知道选中是哪一个
                                    value: _groupValueb,
                                    activeColor: ThemeColor.loignColor,
                                    onChanged:(v) {
                                      setState(() {
                                        _groupValueb = v;
                                      });
                                    },
                                  ),
                                  Text('我已确认同意', style: TextStyle(
                                      fontSize: AppSize.sp(35),
                                      color: ThemeColor.user_agreement_first
                                  ),),
                                  InkWell(
                                    child: Text('《消费风险须知》', style: TextStyle(
                                        color: ThemeColor.user_agreement,
                                        fontSize: AppSize.sp(35)
                                    ),),
                                    onTap: () => Routes.instance.navigateTo(context, Routes.user_agreement),
                                  )
                                ],),
                            )

                            //_buildSmsOrPass(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
           )

    );
  }


  void loadLoginByPass(String userName, String password) async {
    final LoginEntity entity = await LoginDao.fetch(userName, password);
    if (entity?.userModel != null) {
      saveUserInfo(entity.userModel);

    } else {
      DialogUtil.buildToast(entity.msgModel.msg);
    }
  }

  void loadLoginOrReg(String userName, String smsCode) async {
    LoginEntity entity = await LoginRegDao.fetch(userName, smsCode);
    print(entity);
    if (entity?.userModel != null) {
      saveUserInfo(entity.userModel);

    } else {
      if(entity?.msgModel!=null) {
        DialogUtil.buildToast(entity.msgModel.msg);
      }else{
        DialogUtil.buildToast("登录失败");
      }
    }
  }

  loadUserInfo(String token) async {
    //UserEntity entity = await UserDao.fetch(token);
    if (token != null) {
//      AppConfig.gender=entity.userInfoModel.gender;
//      AppConfig.avatar=entity.userInfoModel.avatar;
//      AppConfig.mobile=entity.userInfoModel.mobile;
//      AppConfig.nickName=entity.userInfoModel.nickName;
      DialogUtil.buildToast("登录成功~");
      //Navigator.pop(context);
      Routes.instance.navigateTo(context, Routes.user_select);
      eventBus.fire(UserLoggedInEvent("success"));

    } else {
      DialogUtil.buildToast('fail');
    }
  }

  /**
   * 存储用户信息
   */
  void saveUserInfo(UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", userModel.token);
    AppConfig.isUser = false;
    AppConfig.token =userModel.token;
    loadUserInfo(userModel.token);
  }

}
