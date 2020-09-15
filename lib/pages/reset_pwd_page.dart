import 'dart:async';
import 'package:flutter/material.dart';
import 'package:singer_app/dao/sendsms_dao.dart';

import 'package:singer_app/models/msg_entity.dart';
import 'package:singer_app/receiver/event_bus.dart';
import 'package:singer_app/res/colours.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/utils/dialog_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:singer_app/view/theme_ui.dart';
/// 可用时使用的字体样式。


final TextStyle _availableStyle = TextStyle(
  fontSize: AppSize.sp(37),
  color:Colours.white,

);

class ThemeCode {
  ///主题色
  static Color colorSmscode = Color(0xFF6ECF9F);
}


class ResetCodePage extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int countdown;
  /// 用户点击时的回调函数。
  final Function onTapCallback;
  /// 是否可以获取验证码，默认为`false`。
  final bool available;

  String phoneNum;
  ResetCodePage({
    this.countdown: 60,
    this.onTapCallback,
    this.available: true,
    @required this.phoneNum,
  });
  @override
  _ResetCodePageState createState() => _ResetCodePageState();
}
class _ResetCodePageState extends State<ResetCodePage> {
  /// 倒计时的计时器。
  Timer _timer;
  /// 当前倒计时的秒数。
  int _seconds;
  /// 当前墨水瓶（`InkWell`）的字体样式。
  TextStyle inkWellStyle = _availableStyle;
  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '获取验证码';
  bool isCheck=false;



  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }
  StreamSubscription _phoneSubscription;
  ///监听Bus events
  void _listen() {
    _phoneSubscription= eventBus.on<UserNumInEvent>().listen((event) {
      setState(() {
        widget.phoneNum=event.num;
      });
    });
  }
  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) {
          if (_seconds == 0) {
            _cancelTimer();
            _seconds = widget.countdown;
            inkWellStyle = _availableStyle;
            setState(() {});
            return;
          }
          _seconds--;
          _verifyStr = '$_seconds'+'S';

          if(mounted) {
            setState(() {});
            if (_seconds == 0) {
              isCheck=false;
              _verifyStr = '重新发送';
            }
          }
        });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    /// 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _listen();

    ///墨水瓶（`InkWell`）组件，响应触摸的矩形区域。
    return widget.available ? InkWell(

      child:Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: AppSize.height(10),
            left: AppSize.width(43),
            right: AppSize.width(0),
          ),
          height: AppSize.height(106),
          width: AppSize.width(331),
          decoration: BoxDecoration(
            color: ThemeCode.colorSmscode,
            border: Border.all(width: 1, color: ThemeCode.colorSmscode),
            borderRadius: BorderRadius.circular(5),
          ),
        child: Text(
          '  $_verifyStr  ',
          style: inkWellStyle,
        ),
      ),
      //color: ThemeCode.colorSmscode,
      onTap: () {
        if (isCheck) { // 通过判断check 来 改变按钮颜色
          ThemeCode.colorSmscode = ThemeColor.smscodeColor;
        } else {
          ThemeCode.colorSmscode = ThemeColor.loignColor;
        }

        if(widget.phoneNum==null||widget.phoneNum.isEmpty){
          Fluttertoast.showToast(
              fontSize:AppSize.sp(13),
              gravity: ToastGravity.CENTER,
              msg: "请输入手机号码~");
          return ;
        }
        if(!isPhone(widget.phoneNum)){
          Fluttertoast.showToast(
              fontSize:AppSize.sp(13),
              gravity: ToastGravity.CENTER,
              msg: "手机号码格式不正确~");
          return ;
        }
        if(_seconds == widget.countdown&&!isCheck){
//          widget.onTapCallback();
          isCheck=true;
        sendSms(widget.phoneNum);

        }

      }
    ): InkWell(
      child: Text(
        '  获取验证码  ',
        style: _availableStyle,
      ),
    );
  }
  bool isPhone(String mobile){
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(mobile);
    return matched;
  }
  void sendSms(String mobile) async{
    MsgEntity entity = await SendSmsDao.fetch(mobile);
    if(entity!=null) {
      _startTimer();
      inkWellStyle = _availableStyle;
      _verifyStr = '$_seconds' + 'S';
      //DialogUtil.buildToast("短信验证码为:"+entity.msgModel.data);
      setState(() {
      });
      widget.onTapCallback();
    }else{
      DialogUtil.buildToast("发送失败");
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cancelTimer();
    _phoneSubscription.cancel();
  }

}

class mobile_sms{
  void sendSms(String mobile) async {
    MsgEntity entity = await SendSmsDao.fetch(mobile);
  }
}
