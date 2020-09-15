class UserEntity {
	UserInfoModel  userInfoModel;
	MsgModel msgModel;
	UserEntity({this.userInfoModel,this.msgModel});
	UserEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			if(json['data'].isNotEmpty){
				userInfoModel =new UserInfoModel.fromJson(json['data']);
			}else{
				msgModel=new MsgModel.fromJson(json);
			}
		}
	}
}
class UserInfoModel {
	String avatar;
	String mobile;
	String nickName;
	String userType;
	int age;
	String sex;
	String onlineStatus;
	int coins;
	String dateOfBirth;
	Map<String, dynamic> jsonMap;


	UserInfoModel({this.avatar, this.mobile, this.nickName,this.userType,
		this.age,
		this.sex,
		this.onlineStatus,
		this.coins,
		this.dateOfBirth,
	});

	UserInfoModel.fromJson(Map<String, dynamic> json) {

		avatar = json['mobileUser']['avatar'];
		mobile = json['mobileUser']['username'];
		nickName = json['mobileUser']['nickName'];
		userType = json['mobileUser']['userType'];
		age = json['mobileUser']['age'];
		sex = json['mobileUser']['sex'];
		onlineStatus = json['mobileUser']['onlineStatus'];
		dateOfBirth = json['mobileUser']['dateOfBirth'];
	}

}
class MsgModel{
	String msg;
	MsgModel({this.msg});
	MsgModel.fromJson(Map<String, dynamic> json){
		msg=json['msg'];
	}

}
