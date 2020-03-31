import 'dart:convert';

import 'package:rp_mobile/utils/exceptions.dart';

import '../../../../exceptions.dart';
class RegisterRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String matchingPassword;
  final String password;

  RegisterRequest({
    this.email,
    this.firstName,
    this.lastName,
    this.matchingPassword,
    this.password,
  }) {
    require(email != null, () => SchemeConsistencyException());
    // require(firstName != null, () => SchemeConsistencyException());
    // require(lastName != null, () => SchemeConsistencyException());
    require(matchingPassword != null, () => SchemeConsistencyException());
    require(password != null, () => SchemeConsistencyException());
  }
 
   Map<String, dynamic> toJson() => {
      "email": email == null ? null : email,
      "firstName": "  ",
      "lastName": "  ",
      "matchingPassword": matchingPassword == null ? null : matchingPassword,
      "password": password,
  };
}

class RegisterResposne {
    String timestamp;
    Result result;

    RegisterResposne({
        this.timestamp,
        this.result,
    });

    RegisterResposne copyWith({
        String timestamp,
        Result result,
    }) => 
        RegisterResposne(
            timestamp: timestamp ?? this.timestamp,
            result: result ?? this.result,
        );

    factory RegisterResposne.fromRawJson(String str) => RegisterResposne.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RegisterResposne.fromJson(Map<String, dynamic> json) => RegisterResposne(
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "timestamp": timestamp == null ? null : timestamp,
        "result": result == null ? null : result.toJson(),
    };
}

class Result {
    int id;
    String email;
    Role role;
    bool emailConfirmed;
    bool blocked;
    String lastName;
    String firstName;
    dynamic middleName;
    dynamic imageUrl;
    List<dynamic> parameters;
    bool deleted;
    dynamic product;
    dynamic inn;
    dynamic organizationName;

    Result({
        this.id,
        this.email,
        this.role,
        this.emailConfirmed,
        this.blocked,
        this.lastName,
        this.firstName,
        this.middleName,
        this.imageUrl,
        this.parameters,
        this.deleted,
        this.product,
        this.inn,
        this.organizationName,
    });

    Result copyWith({
        int id,
        String email,
        Role role,
        bool emailConfirmed,
        bool blocked,
        String lastName,
        String firstName,
        dynamic middleName,
        dynamic imageUrl,
        List<dynamic> parameters,
        bool deleted,
        dynamic product,
        dynamic inn,
        dynamic organizationName,
    }) => 
        Result(
            id: id ?? this.id,
            email: email ?? this.email,
            role: role ?? this.role,
            emailConfirmed: emailConfirmed ?? this.emailConfirmed,
            blocked: blocked ?? this.blocked,
            lastName: lastName ?? this.lastName,
            firstName: firstName ?? this.firstName,
            middleName: middleName ?? this.middleName,
            imageUrl: imageUrl ?? this.imageUrl,
            parameters: parameters ?? this.parameters,
            deleted: deleted ?? this.deleted,
            product: product ?? this.product,
            inn: inn ?? this.inn,
            organizationName: organizationName ?? this.organizationName,
        );

    factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"] == null ? null : json["id"],
        email: json["email"] == null ? null : json["email"],
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        emailConfirmed: json["emailConfirmed"] == null ? null : json["emailConfirmed"],
        blocked: json["blocked"] == null ? null : json["blocked"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        middleName: json["middleName"],
        imageUrl: json["imageUrl"],
        parameters: json["parameters"] == null ? null : List<dynamic>.from(json["parameters"].map((x) => x)),
        deleted: json["deleted"] == null ? null : json["deleted"],
        product: json["product"],
        inn: json["inn"],
        organizationName: json["organizationName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "email": email == null ? null : email,
        "role": role == null ? null : role.toJson(),
        "emailConfirmed": emailConfirmed == null ? null : emailConfirmed,
        "blocked": blocked == null ? null : blocked,
        "lastName": lastName == null ? null : lastName,
        "firstName": firstName == null ? null : firstName,
        "middleName": middleName,
        "imageUrl": imageUrl,
        "parameters": parameters == null ? null : List<dynamic>.from(parameters.map((x) => x)),
        "deleted": deleted == null ? null : deleted,
        "product": product,
        "inn": inn,
        "organizationName": organizationName,
    };
}

class Role {
    int roleId;
    String name;
    String description;
    bool editable;
    dynamic parameters;

    Role({
        this.roleId,
        this.name,
        this.description,
        this.editable,
        this.parameters,
    });

    Role copyWith({
        int roleId,
        String name,
        String description,
        bool editable,
        dynamic parameters,
    }) => 
        Role(
            roleId: roleId ?? this.roleId,
            name: name ?? this.name,
            description: description ?? this.description,
            editable: editable ?? this.editable,
            parameters: parameters ?? this.parameters,
        );

    factory Role.fromRawJson(String str) => Role.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        roleId: json["roleId"] == null ? null : json["roleId"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        editable: json["editable"] == null ? null : json["editable"],
        parameters: json["parameters"],
    );

    Map<String, dynamic> toJson() => {
        "roleId": roleId == null ? null : roleId,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "editable": editable == null ? null : editable,
        "parameters": parameters,
    };
}
