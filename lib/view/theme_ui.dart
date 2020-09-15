import 'package:flutter/material.dart';
import 'package:singer_app/utils/app_size.dart';
///
///  封装app整体主题风格控件
///
class ThemeView{


  static Widget divider({Orient orient = Orient.horizontal}){
    if (orient == Orient.horizontal){
      return Divider(height: 0.0,color: Color(0xFF6ECF9F));
    }else{
      return VerticalDivider(width: 0.0,color: Color(0xFF6ECF9F));
    }
  }


}

enum Orient{
  horizontal,
  vertical
}

class ThemeColor{
  static const Color appBg = const Color(0xfff5f6f7);
  static const Color appBarTopBg = const Color(0xff00C2FD);
  static const Color appBarBottomBg = const Color(0xff00C2FD);
  static const Color hintTextColor = const Color(0xff333333);
  static const Color subTextColor = const Color(0xff999999);
  static const Color starColor = const Color(0xFFFFA516);
  static const Color loignColor = const Color(0xFF6ECF9F);
  static const Color smscodeColor = const Color(0xFFA9A9A9);
  static const Color user_agreement_first = const Color(0xFF666666);
  static const Color user_agreement = const Color(0xFFF67A70);
  static const Color user_select_bg = const Color(0xFFEAFBF7);
  static const Color user_select_sing = const Color(0xFFFFFFFF);
  static const Color song_lin = const Color(0xFFF1F1F1);
  static const Color small_sex = const Color(0xFFF67A70);
}

class ThemeTextStyle{
  static final primaryStyle = TextStyle(fontSize: AppSize.sp(44),color: Color(0xff333333));
  static final primaryStyle2 = TextStyle(fontSize: AppSize.sp(44),color: Color(0xff656565));
  static final menuStyle = TextStyle(fontSize: AppSize.sp(36),color: Color(0xff666666));
  static final menuStyle2 = TextStyle(fontSize: AppSize.sp(36),color: Color(0xff656565));
  static final menuStyle3 = TextStyle(fontSize: AppSize.sp(36),color: Color(0xff333333));
  static final priceStyle = TextStyle(fontSize: AppSize.sp(32),color: Color(0xffee4646));


  static final cardTitleStyle = TextStyle(fontSize: AppSize.sp(40),color: Color(0xff333333));
  static final cardPriceStyle = TextStyle(fontSize: AppSize.sp(35),color: Color(0xffee4646));
  static final cardNumStyle = TextStyle(fontSize: AppSize.sp(32),color: Color(0xff999999));



  static final orderFormStatusStyle = TextStyle(fontSize: AppSize.sp(38),color: Color(0xff999999));
  static final orderFormTitleStyle = TextStyle(fontSize: AppSize.sp(38),color: Color(0xff333333));
  static final orderFormBtnStyle = TextStyle(fontSize: AppSize.sp(44),color: ThemeColor.appBarTopBg);
  static final orderCancelBtnStyle = TextStyle(fontSize: AppSize.sp(44),color: Color(0xff999999));
  static final orderContentStyle = TextStyle(fontSize: AppSize.sp(36),color: Color(0xff999999));


  static final personalShopNameStyle = TextStyle(fontSize: AppSize.sp(52),color: Color(0xff333333));
  static final detailStyle = TextStyle(fontSize: AppSize.sp(44),color: Color(0xff999999));
  static final detailStylePrice = TextStyle(fontSize: AppSize.sp(44),color: Color(0xffee4646));
  static final orderStylePrice = TextStyle(fontSize: AppSize.sp(44),color: Color(0xffffffff));
  static final personalNumStyle = TextStyle(
      fontSize: AppSize.sp(44),
      color: ThemeColor.appBarTopBg,
      fontWeight: FontWeight.w700);

  static final primaryBoldStyle = TextStyle(
      fontSize: AppSize.sp(44),
      color: Color(0xff333333),
      fontWeight: FontWeight.w700);


}

class ThemeDecoration{
  static final card = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6)
  );

  static final card2 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8)
  );

  static final outlineBtn = BoxDecoration(
    border: Border.all(color: ThemeColor.appBarTopBg),
    borderRadius:BorderRadius.circular(20),
  );

  static final outlineCancelBtn = BoxDecoration(
    border: Border.all(color: Color(0xffcccccc)),
    borderRadius:BorderRadius.circular(20),
  );
}

