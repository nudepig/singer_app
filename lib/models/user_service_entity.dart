class UserServiceEntity {
  UserServiceMsg  userServiceMsg;
  UserServiceEntity({this.userServiceMsg});
  UserServiceEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      userServiceMsg =new UserServiceMsg.fromJson(json);
    }
  }
}
class UserServiceMsg {
  String msg;
  String qq;
  String phone;

  UserServiceMsg({this.msg, this.qq,this.phone});
  UserServiceMsg.fromJson(Map<String, dynamic> json) {
    msg = json['data']['msg'];
    qq = json['data']['qq'];
    phone = json['data']['phone'];
  }

}