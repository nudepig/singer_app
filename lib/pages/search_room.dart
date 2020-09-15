import 'package:flutter/material.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/view/customize_appbar.dart';
import 'package:singer_app/view/theme_ui.dart';
import 'package:singer_app/view/flutter_iconfont.dart';
import '../common.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';


class Search_Room extends StatefulWidget {
  @override
  _Search_Room createState() => _Search_Room();
}

class _Search_Room extends State<Search_Room> {
  TextEditingController _strName = TextEditingController();

  bool _groupValueb = true;
  File primaryFile;
  File compressedFile;

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: Colors.white,
        preferredSize: Size.fromHeight(AppSize.height(220)),

        child:Column(
          children: <Widget>[
          CommonSaveInfo(
              title: "搜索房间",
              onBack: () => Navigator.pop(context)
          ),
          Container(
            height: AppSize.height(93),
            margin: EdgeInsets.only(
                left: AppSize.width(40), right: AppSize.width(40),top: AppSize.height(30)),
            padding: EdgeInsets.only(left: AppSize.width(30)),
            //alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(5),
            ),
            child:TextField(
                cursorColor: Colors.black, //设置光标
                    decoration: InputDecoration(
                    //输入框decoration属性
                //            contentPadding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 1.0),
                    contentPadding: EdgeInsets.only(bottom: AppSize.height(30)),
                //            fillColor: Colors.white,
                    border: InputBorder.none,
                //            icon: Icon(Icons.search),
                //            icon: ImageIcon(AssetImage("image/search_meeting_icon.png",),),
                  icon: ImageIcon(
                  AssetImage(
                  "images/icon_search.png",
                  ),
                  size:AppSize.sp(50),
                  ),
                  hintText: "请输入房间名称",

                  hintStyle: new TextStyle(fontSize: AppSize.sp(35), color: Colors.grey)),
                  style: new TextStyle(fontSize: AppSize.sp(35), color: Colors.grey),
              ),
              ),

        ],
        ),
        ),

      body:
      ListView(
        children: <Widget>[
          _createInvitation(),
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

  Widget _createInvitation() {
    return Container(
      //color: Colors.white,
      height: AppSize.height(240),
      width: double.infinity,
      margin: EdgeInsets.only(
          top: AppSize.height(40),left: AppSize.width(40), right: AppSize.width(40)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(5),
      ),

      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: AppSize.width(30),top: AppSize.height(30)),
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
            width: AppSize.width(300),
            margin: EdgeInsets.only(left: AppSize.width(260),top: AppSize.height(35)),
            child:Text(
              '${AppConfig.nickName}',
              //                    textAlign : TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppSize.sp(41),
                  color: Colors.black,fontWeight: FontWeight.w500),
            ),
          ),

          Container(
            width: AppSize.width(300),
            margin: EdgeInsets.only(left: AppSize.width(260),top: AppSize.height(90)),
            child:Text(
              '接单数：999',
              //                    textAlign : TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppSize.sp(38),
                  color: Colors.grey,fontWeight: FontWeight.w500),
            ),
          ),

          Container(
            width: AppSize.width(100),
            height: AppSize.height(45),
            margin: EdgeInsets.only(left: AppSize.width(260),top: AppSize.height(145)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ThemeColor.loignColor,
              border: Border.all(width: 0, color: Colors.white),
              borderRadius: BorderRadius.circular(5),
            ),
            child:Text(
              '12位',
              //                    textAlign : TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppSize.sp(29),
                  color: Colors.white,fontWeight: FontWeight.w500),
            ),
          ),

          Container(
            width: AppSize.width(216),
            height: AppSize.height(78),
            margin: EdgeInsets.only(left: AppSize.width(750),top: AppSize.height(29)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ThemeColor.loignColor,
              border: Border.all(width: 0, color: Colors.white),
              borderRadius: BorderRadius.circular(5),
            ),
            child:Text(
              '申请加入',
              //                    textAlign : TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppSize.sp(35),
                  color: Colors.white,fontWeight: FontWeight.w500),
            ),
          ),

          Container(
            width: AppSize.width(120),
            height: AppSize.height(45),
            margin: EdgeInsets.only(left: AppSize.width(845),top: AppSize.height(153)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFA9A9A9),
              border: Border.all(width: 0, color: Colors.white),
              borderRadius: BorderRadius.circular(3),
            ),
            child:Text(
              '0.1km',
              //                    textAlign : TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppSize.sp(29),
                  color: Colors.white,fontWeight: FontWeight.w500),
            ),
          ),

          Container(
            width: AppSize.width(200),
            height: AppSize.height(50),
            margin: EdgeInsets.only(left: AppSize.width(680),top: AppSize.height(150)),
            //alignment: Alignment.centerRight,

            child:Row(
              children: <Widget>[
              Image.asset(
              "images/icon_map.png",
              width: 12,
              height: 12,
              fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.only(left: AppSize.width(6)),
                child:Text(
                  '武汉市',
                  //                    textAlign : TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: AppSize.sp(32),
                      color: Color(0xFFA9A9A9),fontWeight: FontWeight.w500),
                ),
              ),
          ],
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


      ],
    );
  }
}