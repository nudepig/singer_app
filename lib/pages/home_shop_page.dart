import 'package:flutter/material.dart';
import 'package:singer_app/common.dart';
import 'package:singer_app/routes/routes.dart';
import 'package:singer_app/utils/app_size.dart';
import 'package:singer_app/view/app_topbar.dart';
import 'package:singer_app/view/customize_appbar.dart';
import 'package:singer_app/view/theme_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:singer_app/utils/dialog_utils.dart';
import 'package:singer_app/utils/bottom_dialog.dart';
import '../common.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:singer_app/dao/file_upload_dao.dart';
import 'package:singer_app/models/file_upload_entity.dart';
import 'package:singer_app/dao/config.dart';


/**
 * app 首页
 */

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Widget_AppBar_State();
  }
}
/**
    AppBar({
    Key key,
    this.leading,//在标题前面显示的一个控件，在首页通常显示应用的 logo；在其他界面通常显示为返回按钮
    this.automaticallyImplyLeading = true,
    this.title,//Toolbar 中主要内容，通常显示为当前界面的标题文字
    this.actions,//一个 Widget 列表，代表 Toolbar 中所显示的菜单，对于常用的菜单，通常使用 IconButton 来表示；对于不常用的菜单通常使用 PopupMenuButton 来显示为三个点，点击后弹出二级菜单
    this.flexibleSpace,//一个显示在 AppBar 下方的控件，高度和 AppBar 高度一样，可以实现一些特殊的效果，该属性通常在 SliverAppBar 中使用
    this.bottom,//一个 AppBarBottomWidget 对象，通常是 TabBar。用来在 Toolbar 标题下面显示一个 Tab 导航栏
    this.elevation = 4.0,//纸墨设计中控件的 z 坐标顺序，默认值为 4，对于可滚动的 SliverAppBar，当 SliverAppBar 和内容同级的时候，该值为 0， 当内容滚动 SliverAppBar 变为 Toolbar 的时候，修改 elevation 的值
    this.backgroundColor,//APP bar 的颜色，默认值为 ThemeData.primaryColor。该值通常和下面的三个属性一起使用
    this.brightness,//App bar 的亮度，有白色和黑色两种主题，默认值为 ThemeData.primaryColorBrightness
    this.iconTheme,//App bar 上图标的颜色、透明度、和尺寸信息。默认值为 ThemeData.primaryIconTheme
    this.textTheme,//App bar 上的文字样式。默认值为 ThemeData.primaryTextTheme
    this.primary = true,
    this.centerTitle,//标题是否居中显示，默认值根据不同的操作系统，显示方式不一样,true居中 false居左
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    })
 */
class Widget_AppBar_State extends State<HomePage> {
  var tabs = <Widget>[
    Tab(text: "订单中心",),
    Tab(text: "房间中心",),

  ];
  int currentIndex=0;
  String orderTime = '2020-07-30 18:00:00';
  String orderEvaluate = '已评价';
  String orderTimeSlot = '16:00 - 18:00';
  String orderMoney = '200金币';
  String orderStatus = '未到账';
  File primaryFile;
  File compressedFile;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: createMaterialColor(ThemeColor.loignColor),
          ),
          home: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              //title: Text("标题标题标题标题标题标题标题标题标题"),
              centerTitle: false,
              //accentColor: Colors.white,
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
              ),
              title: TabBar(
                labelStyle: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600),
                unselectedLabelStyle: new TextStyle(fontSize: 14.0),
                isScrollable: true,
                tabs: tabs,
              ),
              elevation: 0,
              backgroundColor: Colors.white,
//              bottom: TabBar(
//                isScrollable: true,
//                tabs: tabs,
//              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.email,color: ThemeColor.loignColor,),
                  tooltip: "Alarm",
                  onPressed: () {
                    print("Alarm");
                  },
                ),
              ],
            ),

            body: new TabBarView(
              children: <Widget>[
                saleOrder(),
                Notice(),

              ],
            ),




          ),
        ));
  }

  Widget saleOrder() {
    return SingleChildScrollView(
     child: Container(
       child: Column(
           children: <Widget>[
        Container(
          //color: Colors.white,
          height: AppSize.height(560),
          width: double.infinity,
          margin: EdgeInsets.only(
              top: AppSize.height(40),left: AppSize.width(40), right: AppSize.width(40)),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(3),
    //        boxShadow: [BoxShadow(color: Colors.black12,
    //            //offset: Offset(5.0, 5.0),
    //            blurRadius: 1, spreadRadius: 1)],
          ),

          child: Column(
            children: <Widget>[

              Container(
                height: AppSize.height(100),
                margin: EdgeInsets.only(
                    top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
                decoration: BoxDecoration(
                    border:Border(bottom:BorderSide(width: 1,color: Color(0xffe5e5e5)) )
                ),
                child:Stack(
                  children: <Widget>[
                    Container(
                      width: AppSize.width(100),
                      margin: EdgeInsets.only(
                          top: AppSize.height(25),left: AppSize.width(0)),
                      child: Text(
                        '${AppConfig.nickName}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: AppSize.sp(40),
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          top: AppSize.height(30),left: AppSize.width(120)),
                      child: Text(
                        orderTime,
                        style: TextStyle(fontSize: AppSize.sp(35),
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          top: AppSize.height(30),left: AppSize.width(800)),
                      child: Text(
                        orderEvaluate,
                        style: TextStyle(fontSize: AppSize.sp(35),
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                  ],
                ),
              ),

            Container(
              height: AppSize.height(260),
              margin: EdgeInsets.only(
                  top: AppSize.height(20),left: AppSize.width(20), right: AppSize.width(20)),
              decoration: BoxDecoration(
                  border:Border(bottom:BorderSide(width: 1,color: Color(0xffe5e5e5)) )
              ),
              child:Stack(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: AppSize.width(710),top: AppSize.height(20)),
                    //            alignment: Alignment.center,
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: ThemeColor.loignColor),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: ClipOval(
                      child: _buildIsHasHead(),
                    ),
                  ),

                  Container(
                    width: AppSize.width(450),
                    margin: EdgeInsets.only(left: AppSize.width(270),top: AppSize.height(10)),

                    child:Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Text(
                        '手  机  号：  ' + '${AppConfig.mobile}',
                        overflow: TextOverflow.ellipsis,
                        maxLines:1,
                        textAlign:TextAlign.left,
                        style: TextStyle(fontSize: AppSize.sp(35),
                            color: Color(0xFF333333),fontWeight: FontWeight.w500),
                      ),
                        SizedBox(height: 6),
                        Text(
                          '时  间  段：  ' + '$orderTimeSlot',
                          overflow: TextOverflow.ellipsis,
                          textAlign:TextAlign.left,
                          style: TextStyle(fontSize: AppSize.sp(35),
                              color: Color(0xFF333333),fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '金        额：  ' + '$orderMoney',
                          overflow: TextOverflow.ellipsis,
                          maxLines:1,
                          textAlign:TextAlign.left,
                          style: TextStyle(fontSize: AppSize.sp(35),
                              color: Color(0xFF333333),fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '到账状态：  ' + '$orderStatus',
                          overflow: TextOverflow.ellipsis,
                          textAlign:TextAlign.left,
                          maxLines:1,
                          style: TextStyle(fontSize: AppSize.sp(35),
                              color: Color(0xFF333333),fontWeight: FontWeight.w500),
                        ),

                  ]
                  ),
                ),
              ],
              ),
              ),
            Stack(
              children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: AppSize.width(40),top: AppSize.height(55)),
                alignment: Alignment.centerLeft,
                child:Text(
                  '评价后立即到账，未评价三天后到账',
                  overflow: TextOverflow.ellipsis,
                  textAlign:TextAlign.left,
                  maxLines:1,
                  style: TextStyle(fontSize: AppSize.sp(35),
                      color: Color(0xFFFFB017),fontWeight: FontWeight.w500),
                ),
              ),

                InkWell(
                  onTap: () {
                  
                  },

                  child:Container(
                    width: AppSize.width(196),
                    height: AppSize.height(78),
                    padding: EdgeInsets.only(
                        top: AppSize.height(15)),
                    margin: EdgeInsets.only(
                        left: AppSize.width(760),top: AppSize.height(40)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: ThemeColor.loignColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '查看',
                      textAlign : TextAlign.center,
                      style: TextStyle(fontSize: AppSize.sp(35),
                          color: ThemeColor.loignColor),
                    ),
                  ),
                ),


                ]
            )


            ],
          ),
          ),
         Container(
               //color: Colors.white,
               height: AppSize.height(560),
               width: double.infinity,
               margin: EdgeInsets.only(
                   top: AppSize.height(40),left: AppSize.width(40), right: AppSize.width(40)),
               decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border.all(width: 1, color: Colors.white),
                 borderRadius: BorderRadius.circular(3),
                 //        boxShadow: [BoxShadow(color: Colors.black12,
                 //            //offset: Offset(5.0, 5.0),
                 //            blurRadius: 1, spreadRadius: 1)],
               ),

               child: Column(
                 children: <Widget>[

                   Container(
                     height: AppSize.height(100),
                     margin: EdgeInsets.only(
                         top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
                     decoration: BoxDecoration(
                         border:Border(bottom:BorderSide(width: 1,color: Color(0xffe5e5e5)) )
                     ),
                     child:Stack(
                       children: <Widget>[
                         Container(
                           width: AppSize.width(100),
                           margin: EdgeInsets.only(
                               top: AppSize.height(25),left: AppSize.width(0)),
                           child: Text(
                             '${AppConfig.nickName}',
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle(fontSize: AppSize.sp(40),
                                 color: Color(0xFF333333),
                                 fontWeight: FontWeight.w500),
                           ),
                         ),

                         Container(
                           margin: EdgeInsets.only(
                               top: AppSize.height(30),left: AppSize.width(120)),
                           child: Text(
                             orderTime,
                             style: TextStyle(fontSize: AppSize.sp(35),
                                 color: Color(0xFF333333),
                                 fontWeight: FontWeight.w500),
                           ),
                         ),

                         Container(
                           margin: EdgeInsets.only(
                               top: AppSize.height(30),left: AppSize.width(800)),
                           child: Text(
                             orderEvaluate,
                             style: TextStyle(fontSize: AppSize.sp(35),
                                 color: Color(0xFF666666),
                                 fontWeight: FontWeight.w500),
                           ),
                         ),

                       ],
                     ),
                   ),

                   Container(
                     height: AppSize.height(260),
                     margin: EdgeInsets.only(
                         top: AppSize.height(20),left: AppSize.width(20), right: AppSize.width(20)),
                     decoration: BoxDecoration(
                         border:Border(bottom:BorderSide(width: 1,color: Color(0xffe5e5e5)) )
                     ),
                     child:Stack(
                       //mainAxisAlignment: MainAxisAlignment.center,
                       //crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Container(
                           margin: EdgeInsets.only(right: AppSize.width(710),top: AppSize.height(20)),
                           //            alignment: Alignment.center,
                           width: 72,
                           height: 72,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             border: Border.all(width: 1, color: ThemeColor.loignColor),
                             borderRadius: BorderRadius.circular(36),
                           ),
                           child: ClipOval(
                             child: _buildIsHasHead(),
                           ),
                         ),

                         Container(
                           width: AppSize.width(450),
                           margin: EdgeInsets.only(left: AppSize.width(270),top: AppSize.height(10)),

                           child:Column(

                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text(
                                   '手  机  号：  ' + '${AppConfig.mobile}',
                                   overflow: TextOverflow.ellipsis,
                                   maxLines:1,
                                   textAlign:TextAlign.left,
                                   style: TextStyle(fontSize: AppSize.sp(35),
                                       color: Color(0xFF333333),fontWeight: FontWeight.w500),
                                 ),
                                 SizedBox(height: 6),
                                 Text(
                                   '时  间  段：  ' + '$orderTimeSlot',
                                   overflow: TextOverflow.ellipsis,
                                   textAlign:TextAlign.left,
                                   style: TextStyle(fontSize: AppSize.sp(35),
                                       color: Color(0xFF333333),fontWeight: FontWeight.w500),
                                 ),
                                 SizedBox(height: 6),
                                 Text(
                                   '金        额：  ' + '$orderMoney',
                                   overflow: TextOverflow.ellipsis,
                                   maxLines:1,
                                   textAlign:TextAlign.left,
                                   style: TextStyle(fontSize: AppSize.sp(35),
                                       color: Color(0xFF333333),fontWeight: FontWeight.w500),
                                 ),
                                 SizedBox(height: 6),
                                 Text(
                                   '到账状态：  ' + '$orderStatus',
                                   overflow: TextOverflow.ellipsis,
                                   textAlign:TextAlign.left,
                                   maxLines:1,
                                   style: TextStyle(fontSize: AppSize.sp(35),
                                       color: Color(0xFF333333),fontWeight: FontWeight.w500),
                                 ),

                               ]
                           ),
                         ),
                       ],
                     ),
                   ),
                   Stack(
                       children: <Widget>[
                         Container(
                           margin: EdgeInsets.only(left: AppSize.width(40),top: AppSize.height(55)),
                           alignment: Alignment.centerLeft,
                           child:Text(
                             '评价后立即到账，未评价三天后到账',
                             overflow: TextOverflow.ellipsis,
                             textAlign:TextAlign.left,
                             maxLines:1,
                             style: TextStyle(fontSize: AppSize.sp(35),
                                 color: Color(0xFFFFB017),fontWeight: FontWeight.w500),
                           ),
                         ),

                         InkWell(
                           onTap: () {
                          
                           },

                           child:Container(
                             width: AppSize.width(196),
                             height: AppSize.height(78),
                             padding: EdgeInsets.only(
                                 top: AppSize.height(15)),
                             margin: EdgeInsets.only(
                                 left: AppSize.width(760),top: AppSize.height(40)),
                             decoration: BoxDecoration(
                               color: Colors.white,
                               border: Border.all(width: 1, color: ThemeColor.loignColor),
                               borderRadius: BorderRadius.circular(5),
                             ),
                             child: Text(
                               '查看',
                               textAlign : TextAlign.center,
                               style: TextStyle(fontSize: AppSize.sp(35),
                                   color: ThemeColor.loignColor),
                             ),
                           ),
                         ),


                       ]
                   )


                 ],
               ),
             ),
         Container(
               //color: Colors.white,
               height: AppSize.height(560),
               width: double.infinity,
               margin: EdgeInsets.only(
                   top: AppSize.height(40),left: AppSize.width(40), right: AppSize.width(40)),
               decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border.all(width: 1, color: Colors.white),
                 borderRadius: BorderRadius.circular(3),
                 //        boxShadow: [BoxShadow(color: Colors.black12,
                 //            //offset: Offset(5.0, 5.0),
                 //            blurRadius: 1, spreadRadius: 1)],
               ),

               child: Column(
                 children: <Widget>[

                   Container(
                     height: AppSize.height(100),
                     margin: EdgeInsets.only(
                         top: AppSize.height(20),left: AppSize.width(10), right: AppSize.width(20)),
                     decoration: BoxDecoration(
                         border:Border(bottom:BorderSide(width: 1,color: Color(0xffe5e5e5)) )
                     ),
                     child:Stack(
                       children: <Widget>[
                         Container(
                           width: AppSize.width(100),
                           margin: EdgeInsets.only(
                               top: AppSize.height(25),left: AppSize.width(0)),
                           child: Text(
                             '${AppConfig.nickName}',
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle(fontSize: AppSize.sp(40),
                                 color: Color(0xFF333333),
                                 fontWeight: FontWeight.w500),
                           ),
                         ),

                         Container(
                           margin: EdgeInsets.only(
                               top: AppSize.height(30),left: AppSize.width(120)),
                           child: Text(
                             orderTime,
                             style: TextStyle(fontSize: AppSize.sp(35),
                                 color: Color(0xFF333333),
                                 fontWeight: FontWeight.w500),
                           ),
                         ),

                         Container(
                           margin: EdgeInsets.only(
                               top: AppSize.height(30),left: AppSize.width(800)),
                           child: Text(
                             orderEvaluate,
                             style: TextStyle(fontSize: AppSize.sp(35),
                                 color: Color(0xFF666666),
                                 fontWeight: FontWeight.w500),
                           ),
                         ),

                       ],
                     ),
                   ),

                   Container(
                     height: AppSize.height(260),
                     margin: EdgeInsets.only(
                         top: AppSize.height(20),left: AppSize.width(20), right: AppSize.width(20)),
                     decoration: BoxDecoration(
                         border:Border(bottom:BorderSide(width: 1,color: Color(0xffe5e5e5)) )
                     ),
                     child:Stack(
                       //mainAxisAlignment: MainAxisAlignment.center,
                       //crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Container(
                           margin: EdgeInsets.only(right: AppSize.width(710),top: AppSize.height(20)),
                           //            alignment: Alignment.center,
                           width: 72,
                           height: 72,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             border: Border.all(width: 1, color: ThemeColor.loignColor),
                             borderRadius: BorderRadius.circular(36),
                           ),
                           child: ClipOval(
                             child: _buildIsHasHead(),
                           ),
                         ),

                         Container(
                           width: AppSize.width(450),
                           margin: EdgeInsets.only(left: AppSize.width(270),top: AppSize.height(10)),

                           child:Column(

                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text(
                                   '手  机  号：  ' + '${AppConfig.mobile}',
                                   overflow: TextOverflow.ellipsis,
                                   maxLines:1,
                                   textAlign:TextAlign.left,
                                   style: TextStyle(fontSize: AppSize.sp(35),
                                       color: Color(0xFF333333),fontWeight: FontWeight.w500),
                                 ),
                                 SizedBox(height: 6),
                                 Text(
                                   '时  间  段：  ' + '$orderTimeSlot',
                                   overflow: TextOverflow.ellipsis,
                                   textAlign:TextAlign.left,
                                   style: TextStyle(fontSize: AppSize.sp(35),
                                       color: Color(0xFF333333),fontWeight: FontWeight.w500),
                                 ),
                                 SizedBox(height: 6),
                                 Text(
                                   '金        额：  ' + '$orderMoney',
                                   overflow: TextOverflow.ellipsis,
                                   maxLines:1,
                                   textAlign:TextAlign.left,
                                   style: TextStyle(fontSize: AppSize.sp(35),
                                       color: Color(0xFF333333),fontWeight: FontWeight.w500),
                                 ),
                                 SizedBox(height: 6),
                                 Text(
                                   '到账状态：  ' + '$orderStatus',
                                   overflow: TextOverflow.ellipsis,
                                   textAlign:TextAlign.left,
                                   maxLines:1,
                                   style: TextStyle(fontSize: AppSize.sp(35),
                                       color: Color(0xFF333333),fontWeight: FontWeight.w500),
                                 ),

                               ]
                           ),
                         ),
                       ],
                     ),
                   ),
                   Stack(
                       children: <Widget>[
                         Container(
                           margin: EdgeInsets.only(left: AppSize.width(40),top: AppSize.height(55)),
                           alignment: Alignment.centerLeft,
                           child:Text(
                             '评价后立即到账，未评价三天后到账',
                             overflow: TextOverflow.ellipsis,
                             textAlign:TextAlign.left,
                             maxLines:1,
                             style: TextStyle(fontSize: AppSize.sp(35),
                                 color: Color(0xFFFFB017),fontWeight: FontWeight.w500),
                           ),
                         ),

                         InkWell(
                           onTap: () {
                            
                           },

                           child:Container(
                             width: AppSize.width(196),
                             height: AppSize.height(78),
                             padding: EdgeInsets.only(
                                 top: AppSize.height(15)),
                             margin: EdgeInsets.only(
                                 left: AppSize.width(760),top: AppSize.height(40)),
                             decoration: BoxDecoration(
                               color: Colors.white,
                               border: Border.all(width: 1, color: ThemeColor.loignColor),
                               borderRadius: BorderRadius.circular(5),
                             ),
                             child: Text(
                               '查看',
                               textAlign : TextAlign.center,
                               style: TextStyle(fontSize: AppSize.sp(35),
                                   color: ThemeColor.loignColor),
                             ),
                           ),
                         ),


                       ]
                   )


                 ],
               ),
             ),

          ],
          ),
          ),
      );
  }

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

  Widget Notice() {
    if(AppConfig.room==true) {

    return Scaffold(
      appBar: MyAppBar(
        backgroundColor:ThemeColor.user_select_bg,
        preferredSize: Size.fromHeight(AppSize.height(0)),
        child: CommonBackTopBar(
            title: "", onBack: () => Navigator.pop(context)
        ),
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

                    height: AppSize.height(600),
                    width: AppSize.width(1000),
                    margin: EdgeInsets.only(top: AppSize.height(523),left: AppSize.height(0),right: AppSize.height(1)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: AppSize.height(80)),
                          child:Container(
                            height: AppSize.height(600),
                            width: AppSize.width(388),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => Routes.instance.navigateTo(context, Routes.create_room),
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
                                              image: AssetImage("images/creata_room.png")
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              top: AppSize.height(170)),
                                          child: Text(
                                            '创建房间',
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
                                    '创建房间成为经纪人',
                                    style: TextStyle(
                                      color: Color(0xFF6F97D9),
                                      fontSize: AppSize.sp(37),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: AppSize.height(80),
                                  width: AppSize.width(350),
                                  padding: EdgeInsets.only(
                                      top: AppSize.height(10),left: AppSize.width(60)),
                                  child: Text(
                                    '享受全部分佣',
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
                            height: AppSize.height(600),
                            width: AppSize.width(388),
                            child: Column(
                              children: <Widget>[


                                InkWell(
                                  onTap: () => Routes.instance.navigateTo(context, Routes.search_room),

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
                                              image: AssetImage("images/search_room.png")
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              top: AppSize.height(170)),
                                          child: Text(
                                            '搜索房间',
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
                                  width: AppSize.width(350),
                                  padding: EdgeInsets.only(
                                      top: AppSize.height(30),left: AppSize.width(70)),
                                  child: Text(
                                    '搜索加入房间',
                                    style: TextStyle(
                                      color: Color(0xFF43BB91),
                                      fontSize: AppSize.sp(37),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: AppSize.height(80),
                                  width: AppSize.width(400),
                                  padding: EdgeInsets.only(
                                      top: AppSize.height(10),left: AppSize.width(50)),
                                  child: Text(
                                    '享受更多曝光机会',
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
    }else{
    return Scaffold(
        appBar: MyAppBar(
          backgroundColor:ThemeColor.user_select_bg,
          preferredSize: Size.fromHeight(AppSize.height(0)),
          child: CommonBackTopBar(
              title: "", onBack: () => Navigator.pop(context)
          ),
        ),
        body:ListView(
          children: <Widget>[
            _topHeader(),

          ],
        ),

    );
  }
  }

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
                  child: _buildIsRoom(),
                ),
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(
                top: AppSize.height(360), left: AppSize.height(520)),
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




          Container(
            height: AppSize.height(60),
            width: double.infinity,
            margin: EdgeInsets.only(
                top: AppSize.height(460)),
            //padding: const EdgeInsets.only(top: 15),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: AppSize.width(240)),
//                  width: AppSize.width(300),
                  child:Text(
                    '星星之火',
                    textAlign : TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: AppSize.sp(51),
                        color: Colors.white,fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(

          )


        ],
      ),
    );
  }

  ///头像是否为空
  Widget _buildIsRoom() {
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




}


MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}



