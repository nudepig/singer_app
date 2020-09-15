class LoginEntity {
	UserModel  userModel;
	MsgModel msgModel;
	LoginEntity({this.userModel,this.msgModel});
	LoginEntity.fromJson(Map<String, dynamic> json) {
				if (json['token'] != null) {
				userModel =new UserModel.fromJson(json);
			}else{
				msgModel=new MsgModel.fromJson(json);
			}
//		}
	}
}
class UserModel {

	String token;
	UserModel({ this.token});

	UserModel.fromJson(Map<String, dynamic> json) {

		token = json['token'];
	}

}
class MsgModel{
	String msg;
	MsgModel({this.msg});
	MsgModel.fromJson(Map<String, dynamic> json){
		msg=json['msg'];
	}

}
