import 'package:flutter/material.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/view/customize_appbar.dart';
import 'package:singer_app/view/app_topbar.dart';
import 'package:singer_app/view/theme_ui.dart';
import 'package:singer_app/routes/routes.dart';



class UserSelect extends StatefulWidget {
  @override
  _UserSelect createState() => _UserSelect();
}

class _UserSelect extends State<UserSelect> {
  String _userPhone = "";
  bool _groupValueb = true;

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
        appBar: MyAppBar(
          backgroundColor:ThemeColor.user_select_bg,
          preferredSize: Size.fromHeight(AppSize.height(130)),
          child: CommonBackTopBar(
          title: "选择身份", onBack: () => Navigator.pop(context)),
        ),
        body:
        Container(
            color: ThemeColor.user_select_bg,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                      children: <Widget>[
                    Container(
                      height: AppSize.height(544),
                      width: AppSize.width(427),
                      margin: EdgeInsets.only(top: AppSize.height(109),left: AppSize.height(570),right: AppSize.height(1)),

                      child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage("images/sing_up.png")

                        ),
                        ),

                    Container(

                      height: AppSize.height(500),
                      width: AppSize.width(1000),
                      margin: EdgeInsets.only(top: AppSize.height(523),left: AppSize.height(0),right: AppSize.height(1)),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: AppSize.height(80)),
                                child:Container(
                                  height: AppSize.height(500),
                                  width: AppSize.width(388),
                                  child: Column(
                                      children: <Widget>[
                                    InkWell(
                                        onTap: () => Routes.instance.navigateTo(context, Routes.user_song),
                                      child:Stack(
                                        children: <Widget>[
                                        Container(
                                          height: AppSize.height(388),
                                          width: AppSize.width(388),
                                          decoration: BoxDecoration(
                                            //color: Colors.red,
                                            border: Border.all(width: 1, color: ThemeColor.user_select_bg),
                                            borderRadius: BorderRadius.circular(5),),
                                          child: Image(
                                              height: AppSize.height(388),
                                              width: AppSize.width(388),
                                              fit: BoxFit.fill,
                                              image: AssetImage("images/about_song.png")
                                            ),
                                      ),

                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              top: AppSize.height(170)),
                                          child: Text(
                                            '我来约歌',
                                            style: TextStyle(
                                            color: ThemeColor.user_select_sing,
                                            fontSize: AppSize.sp(54),
                                            ),
                                          ),
                                        ),
                                    ]
                                    ),
                                    ),

                                      Container(
                                        height: AppSize.height(80),
                                        width: AppSize.width(400),
                                        padding: EdgeInsets.only(
                                            top: AppSize.height(30),left: AppSize.width(30)),
                                        child: Text(
                                          '找人唱K，一键预约',
                                          style: TextStyle(
                                          color: Color(0xFF6F97D9),
                                          fontSize: AppSize.sp(37),
                                          ),
                                        ),
                                      ),
                                  ],
                                  ),

                          ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: AppSize.height(100)),

                          child:Container(
                            height: AppSize.height(500),
                            width: AppSize.width(388),
                            child: Column(
                              children: <Widget>[


                              InkWell(
                                  onTap: () => Routes.instance.navigateTo(context, Routes.user_singer),

                                  child:Stack(
                                    children: <Widget>[


                                     Container(
                                          height: AppSize.height(388),
                                          width: AppSize.width(388),
                                          decoration: BoxDecoration(
                                            //color: Colors.red,
                                            border: Border.all(width: 1, color: ThemeColor.user_select_bg),
                                            borderRadius: BorderRadius.circular(5),),
                                          child: Image(
                                              height: AppSize.height(388),
                                              width: AppSize.width(388),
                                              fit: BoxFit.fill,
                                              image: AssetImage("images/is_singer.png")
                                          ),
                                        ),

                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                            top: AppSize.height(170)),
                                        child: Text(
                                          '我是歌手',
                                          style: TextStyle(
                                            color: ThemeColor.user_select_sing,
                                            fontSize: AppSize.sp(54),
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                                ),

                                  Container(
                                    height: AppSize.height(80),
                                    width: AppSize.width(400),
                                    padding: EdgeInsets.only(
                                        top: AppSize.height(30),left: AppSize.width(30)),
                                    child: Text(
                                    '入驻平台，随时接单',
                                    style: TextStyle(
                                      color: Color(0xFF43BB91),
                                      fontSize: AppSize.sp(37),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ),
                        ),

                    ],

                  ),
                  ),
                    ],
                  ),
                    Container(
                        height: AppSize.height(670),
                        width: AppSize.width(296),
                        margin: EdgeInsets.only(top: AppSize.height(0),right: AppSize.height(700),left: AppSize.height(1)),
                      child: Image(
                          height: AppSize.height(544),
                          width: AppSize.width(296),
                          fit: BoxFit.cover,
                          image: AssetImage("images/sing_down.png")
                      ),
                      ),

               ],
              ),
            ),
        ),
    );

}
}