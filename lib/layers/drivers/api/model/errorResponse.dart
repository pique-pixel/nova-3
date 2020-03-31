// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

class ErrorResponse {
    int status;
    String path;
    String message;
    String exception;
    String timestamp;
    List<Error> errors;

    ErrorResponse({
        this.status,
        this.path,
        this.message,
        this.exception,
        this.timestamp,
        this.errors,
    });

    factory ErrorResponse.fromRawJson(String str) => ErrorResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        status: json["status"] == null ? null : json["status"],
        path: json["path"] == null ? null : json["path"],
        message: json["message"] == null ? null : json["message"],
        exception: json["exception"] == null ? null : json["exception"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        errors: json["errors"] == null ? null : List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "path": path == null ? null : path,
        "message": message == null ? null : message,
        "exception": exception == null ? null : exception,
        "timestamp": timestamp == null ? null : timestamp,
        "errors": errors == null ? null : List<dynamic>.from(errors.map((x) => x.toJson())),
    };

    List<String> get errorList {
      if(this.errors != null && this.errors.isNotEmpty){
        return this.errors.map((x)=>x.message).toList();
      }
      else{
        return null;
      }
    }
}

class Error {
    String message;
    String code;
    String objectName;
    String type;
    String field;
    String value;

    Error({
        this.message,
        this.code,
        this.objectName,
        this.type,
        this.field,
        this.value,
    });

    factory Error.fromRawJson(String str) => Error.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Error.fromJson(Map<String, dynamic> json) => Error(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        objectName: json["objectName"] == null ? null : json["objectName"],
        type: json["type"] == null ? null : json["type"],
        field: json["field"] == null ? null : json["field"],
        value: json["value"] == null ? null : json["value"],
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "objectName": objectName == null ? null : objectName,
        "type": type == null ? null : type,
        "field": field == null ? null : field,
        "value": value == null ? null : value,
    };
}
