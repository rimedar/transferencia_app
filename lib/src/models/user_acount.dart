import 'dart:convert';

import 'package:transferencia_bancaria/src/entities/user_account.dart';

// Generated by https://quicktype.io

class UserAccountModel extends UserAccount {
  UserAccountModel({
    required int nit,
    required String name,
    required int idCuenta,
    required int numeroCuenta,
    required int saldoCuenta,
  }) : super(
            nit: nit,
            name: name,
            idCuenta: idCuenta,
            numeroCuenta: numeroCuenta,
            saldoCuenta: saldoCuenta);

  Map<String, dynamic> toMap() {
    return {
      'nit': nit,
      'name': name,
      'idCuenta': idCuenta,
      'numeroCuenta': numeroCuenta,
      'saldoCuenta': saldoCuenta,
    };
  }

  factory UserAccountModel.fromMap(Map<String, dynamic> map) {
    return UserAccountModel(
      nit: map['nit']?.toInt() ?? 0,
      name: map['name'] ?? '',
      idCuenta: map['idCuenta']?.toInt() ?? 0,
      numeroCuenta: map['numeroCuenta']?.toInt() ?? 0,
      saldoCuenta: map['saldoCuenta']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccountModel.fromJson(String source) =>
      UserAccountModel.fromMap(json.decode(source));
}
