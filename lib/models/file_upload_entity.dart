class FileEntity {
  FileModel  msgModel;
  FileEntity({this.msgModel});
  FileEntity.fromJson(Map<String, dynamic> json) {
    if (json['imgUrl'] != null) {
      msgModel =FileModel.fromJson(json);
    }
  }
}
class FileModel {
  String avatar;
  String msg;

  FileModel({this.avatar,this.msg});
  FileModel.fromJson(Map<String, dynamic> json) {
    avatar = json['imgUrl'];
    msg=json['msg'];
  }

}