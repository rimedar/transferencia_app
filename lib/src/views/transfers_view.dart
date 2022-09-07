import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transferencia_bancaria/src/providers/text_fiel_validator.dart';
import 'package:transferencia_bancaria/src/providers/http_service.dart';
import 'package:transferencia_bancaria/src/utils/responsive.dart';
import 'package:transferencia_bancaria/src/utils/snackbar_dialog.dart';
import 'package:transferencia_bancaria/src/controllers/transfer_view_controller.dart';

class TransfersView extends StatefulWidget {
  const TransfersView(
      {Key? key,
      required this.nit,
      required this.saldo,
      required this.accountNumber})
      : super(key: key);
  final int nit;
  final int saldo;
  final int accountNumber;

  @override
  State<TransfersView> createState() => _TransfersViewState();
}

class _TransfersViewState extends State<TransfersView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController cedulaOrigen = TextEditingController();
  TextEditingController cedulaDestino = TextEditingController();
  TextEditingController cuentaOrigen = TextEditingController();
  TextEditingController cuentaDestino = TextEditingController();
  TextEditingController monto = TextEditingController();

  // Http httpServices = Http();
  TransfersViewController trnasfersViewController = TransfersViewController();

  @override
  void initState() {
    super.initState();
    cedulaOrigen.text = widget.nit.toString();
    cuentaOrigen.text = widget.accountNumber.toString();
    cuentaDestino.text = '';
    cedulaDestino.text = '';
    monto.text = '';
    // httpServices.getUsersAcount();
    // httpServices.getUser(123456789);
    // httpServices.getTransferencias(555);
    // httpServices.sumarSaldo(123456, 200000);
    // httpServices.restarSaldo(456789, 200000);
  }

  @override
  void dispose() {
    cedulaOrigen.dispose();
    cedulaDestino.dispose();
    cuentaOrigen.dispose();
    cuentaDestino.dispose();
    monto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final httpServiceProvider = Provider.of<HttpService>(context);

    final texFielValidator = Provider.of<TextFielValidator>(context);
    Future.delayed(Duration.zero, () async {
      if (cedulaOrigen.text.isNotEmpty) {
        texFielValidator.isActive = true;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencia'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Flexible(
                    child: TexFieldWidget(
                        labelText: 'Cedula Origen',
                        inputType: 'Cedula',
                        icon: Icons.perm_identity,
                        enabled: true,
                        controller: cedulaOrigen),
                  ),
                  Flexible(
                    child: TexFieldWidget(
                        labelText: 'Cedula Destino',
                        inputType: 'Cedula',
                        icon: Icons.perm_identity,
                        enabled: true,
                        controller: cedulaDestino),
                  ),
                ],
              ),
              Flexible(
                child: TexFieldWidget(
                    labelText: 'Cuenta Origen',
                    inputType: 'Cuenta',
                    icon: Icons.credit_card_rounded,
                    enabled: texFielValidator.isActive,
                    controller: cuentaOrigen),
              ),
              Flexible(
                child: TexFieldWidget(
                    labelText: 'Cuenta Destino',
                    inputType: 'Cuenta',
                    icon: Icons.credit_card_rounded,
                    enabled: texFielValidator.isActive,
                    controller: cuentaDestino),
              ),
              Flexible(
                child: TexFieldWidget(
                    labelText: 'Monto a transferir',
                    inputType: 'Monto',
                    icon: Icons.monetization_on_outlined,
                    enabled: texFielValidator.isActive,
                    controller: monto),
              ),
              ElevatedButton(
                  onPressed: httpServiceProvider.loading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            if (int.parse(monto.text) > widget.saldo) {
                              SnackbarDialog().showSnackbar(context,
                                  'Dinero Insuficiente, saldo es ${widget.saldo}');
                            } else if (widget.nit ==
                                int.parse(cedulaDestino.text)) {
                              SnackbarDialog().showSnackbar(context,
                                  'No puede transferir al mismo usuario');
                            } else {
                              int resul =
                                  await trnasfersViewController.sendTransaction(
                                widget.nit,
                                int.parse(cedulaDestino.text),
                                int.parse(cuentaOrigen.text),
                                int.parse(cuentaDestino.text),
                                int.parse(monto.text),
                              );
                              if (resul == 0) {
                                SnackbarDialog().showSnackbar(context,
                                    'Se realizo la transacción exitosamente');
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (route) => false);
                              } else if (resul == 1) {
                                SnackbarDialog().showSnackbar(context,
                                    'Cuenta de destino no asociada al usuario');
                              } else if (resul == 2) {
                                SnackbarDialog().showSnackbar(context,
                                    'Cuenta de usuario no existe, verifique la cédula');
                              }
                            }
                          }
                        },
                  child: const Text('Transferir'))
            ],
          ),
        ),
      ),
    );
  }
}

class TexFieldWidget extends StatefulWidget {
  const TexFieldWidget(
      {Key? key,
      required this.labelText,
      required this.inputType,
      required this.icon,
      required this.enabled,
      required this.controller})
      : super(key: key);
  final String labelText;
  final String inputType;
  final bool enabled;
  final IconData icon;
  final TextEditingController controller;

  @override
  State<TexFieldWidget> createState() => _TexFieldWidgetState();
}

class _TexFieldWidgetState extends State<TexFieldWidget> {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return Consumer<TextFielValidator>(
      builder: (context, texFielValidator, child) {
        return TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value!.isEmpty) {
              if (widget.inputType == 'Monto') {
                return 'digite un ${widget.inputType}';
              } else {
                return 'digite un número de ${widget.inputType}';
              }
            }

            if (value.length < 4 || value.length > 10) {
              if (widget.inputType == 'Monto') {
                return 'digite un ${widget.inputType} valido';
              } else {
                return 'digite un número de ${widget.inputType} valido';
              }
            }
          },
          onChanged: (value) {
            if (widget.inputType == 'Cedula') {
              if (widget.controller.text.isEmpty) {
                texFielValidator.isActive = false;
              } else {
                texFielValidator.isActive = true;
              }
            }
          },
          decoration: InputDecoration(
            icon: Icon(widget.icon),
            labelText: widget.labelText,
          ),
          style: TextStyle(
              fontSize: responsive.dp(2), fontWeight: FontWeight.w600),
        );
      },
    );
  }
}
