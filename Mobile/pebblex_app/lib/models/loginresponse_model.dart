import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    LoginResponseModel({
        required this.isSuccess,
        required this.data,
        required this.error,
        required this.message,
    });

    final bool? isSuccess;
    final String? data;
    final dynamic error;
    final String? message;

    factory LoginResponseModel.fromJson(Map<String, dynamic> json){ 
        return LoginResponseModel(
            isSuccess: json["isSuccess"],
            data: json["data"],
            error: json["error"],
            message: json["message"],
        );
    }

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "data": data,
        "error": error,
        "message": message,
    };

}

