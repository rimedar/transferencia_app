import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:transferencia_bancaria/src/providers/http_service.dart';
import 'package:transferencia_bancaria/src/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class TransfersViewController {
  HttpService httpServices = HttpService();

  var uuid = const Uuid();

  Future<int> sendTransaction(int nit, int cedulaDestino, int cuentaOrigen,
      int cuentaDestino, int monto) async {
    int mensajeId = 0;
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedTime = DateFormat('h:mm:sa').format(now);
    var formattedDate = formatter.format(now) + ' ' + formattedTime;
    var id = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
    try {
      UserModel? user = await httpServices.getUser(cedulaDestino);
      if (user != null) {
        if (user.numeroCuenta == cuentaDestino) {
          mensajeId = 0;
          // await httpServices.restarSaldo(cuentaOrigen, monto);
          // await httpServices.sumarSaldo(cuentaDestino, monto);
          await httpServices.saveTransfer(
              id, nit, cuentaOrigen, cuentaDestino, monto, formattedDate);
        } else {
          mensajeId = 1;
          debugPrint('Cuenta de destino no asociada al usuario');
        }
      } else {
        mensajeId = 2;
        debugPrint('Cuenta de usuario no existe, verifique la cédula');
      }
    } on WebSocketException catch (e) {
      debugPrint(e.message);
    }
    // if(user['idCuenta'])
    return mensajeId;
  }
}
