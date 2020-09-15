
import 'package:singer_app/models/login_entity.dart';
import 'package:singer_app/models/msg_entity.dart';
import 'package:singer_app/models/user_entity.dart';
import 'package:singer_app/models/user_service_entity.dart';
import 'file_upload_entity.dart';


class EntityFactory {
  static T generateOBJ<T>(dynamic json) {
    print(T);
    if (1 == 0) {
      return null;

    }else if (T.toString() == "LoginEntity"){
      return LoginEntity.fromJson(json) as T;
    }else if (T.toString() == "FileEntity"){
      return FileEntity.fromJson(json) as T;
    }else if (T.toString() == "MsgEntity"){
      return MsgEntity.fromJson(json) as T;
    }else if (T.toString() == "UserEntity"){
      return UserEntity.fromJson(json) as T;
    }else if (T.toString() == "UserServiceEntity"){
      return UserServiceEntity.fromJson(json) as T;
    }
    else {
      return null;
    }
  }
}