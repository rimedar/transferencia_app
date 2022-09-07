// ignore_for_file: unnecessary_new

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:transferencia_bancaria/src/models/trasnfers_model.dart';
import 'package:transferencia_bancaria/src/models/user_acount.dart';
import 'dart:async';

import '../models/user_model.dart';
import 'dart:convert';

class HttpService with ChangeNotifier {
  final url = 'http://192.168.1.8:3000/';
  final users = 'users/';
  final cuenta = 'cuenta/';
  final cuentasUsuario = 'cuentas_usuario/';
  final transactionsRecord = 'transactions_record/';
  final headers = {'Content-Type': 'application/json'};
  final encoding = Encoding.getByName('utf-8');

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool status) {
    _loading = status;
    notifyListeners();
  }

  List<dynamic> _transfers = [];

  List<dynamic> get transfers => _transfers;
  set transfers(List<dynamic> data) {
    _transfers = data;
    notifyListeners();
  }

  HttpService();

  Future<List<dynamic>> getUsersAcount() async {
    List<dynamic>? userAccoust;
    try {
      http.Response response = await http.get(
        Uri.parse('$url$cuentasUsuario'),
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var decodedData = json.decode(response.body);

        userAccoust =
            decodedData.map((e) => UserAccountModel.fromMap(e)).toList();

        // userAccoust = List<dynamic>.from(
        //   json.decode(response.body).map<dynamic>(
        //         (dynamic item) => item,
        //       ),
        // ).toList();

      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return userAccoust!;
  }

  Future<UserModel?> getUser(int nit) async {
    UserModel? user;
    try {
      http.Response response = await http.get(
        Uri.parse('$url$users$nit'),
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        user = UserModel.fromJson(response.body);
        debugPrint(user.name);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return user;
  }

  Future<http.Response> saveTransfer(String id, int nitUsuario,
      int cuentaOrigen, int cuentaDestino, int monto, String fecha) async {
    loading = true;
    Map<String, dynamic> data = {
      'idTransaction': id,
      'nitUsuario': nitUsuario,
      'fecha': fecha,
      'cuentaOrigen': cuentaOrigen,
      'cuentaDestino': cuentaDestino,
      'monto': monto
    };
    String body = json.encode(data);
    http.Response? response;
    try {
      response = await http.post(Uri.parse('$url$transactionsRecord'),
          headers: headers, body: body, encoding: encoding);
      if (response.statusCode == 200) {
        debugPrint(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      loading = false;
    }
    loading = false;
    return response!;
  }

  Future<List<dynamic>> getTransferers(int nitUsuario) async {
    // List<dynamic>? transfers;
    loading = true;
    http.Response response;
    notifyListeners();
    try {
      response = await http.get(
        Uri.parse('$url$transactionsRecord$nitUsuario'),
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var decodedData = json.decode(response.body);
        transfers = decodedData.map((e) => TrasnfersModel.fromMap(e)).toList();
        notifyListeners();
        // userAccoust = List<dynamic>.from(
        //   json.decode(response.body).map<dynamic>(
        //         (dynamic item) => item,
        //       ),
        // ).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
      loading = false;
    }
    loading = false;
    return transfers;
  }
}
