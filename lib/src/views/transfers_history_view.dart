import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:transferencia_bancaria/src/providers/http_service.dart';
import 'package:transferencia_bancaria/src/utils/responsive.dart';

class TransfersHistoryView extends StatefulWidget {
  const TransfersHistoryView({Key? key, required this.numeroCuenta})
      : super(key: key);
  final int numeroCuenta;

  @override
  State<TransfersHistoryView> createState() => _TransfersHistoryViewState();
}

class _TransfersHistoryViewState extends State<TransfersHistoryView> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    final http = Provider.of<HttpService>(context, listen: false);
    Future.delayed(Duration.zero)
        .then((value) => http.getTransferers(widget.numeroCuenta));
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);

    TextStyle contentStyle =
        TextStyle(fontSize: responsive.dp(1.4), fontWeight: FontWeight.bold);
    debugPrint('Repintado');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Transferencias'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<HttpService>(
            builder: (context, httpService, child) {
              return SizedBox(
                width: responsive.wp(98),
                height: responsive.hp(98),
                child: httpService.transfers.isEmpty
                    ? Column(
                        children: const [
                          TableHeader(),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const TableHeader(),
                          SizedBox(
                            height: responsive.hp(1),
                          ),
                          Flexible(
                            child: AnimationLimiter(
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          childAspectRatio:
                                              responsive.horizontal! ? 12 : 6),
                                  itemCount: httpService.transfers.length - 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    bool send = widget.numeroCuenta ==
                                        httpService
                                            .transfers[index].cuentaOrigen;
                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      columnCount: 1,
                                      child: FadeInAnimation(
                                        child: FlipAnimation(
                                          child: Card(
                                            color: send
                                                ? Colors.green[100]
                                                : Colors.green[200],
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  // color: Colors.red,
                                                  width: responsive.wp(10),
                                                  child: Icon(
                                                    send
                                                        ? Icons
                                                            .arrow_forward_ios_rounded
                                                        : Icons
                                                            .arrow_back_ios_new_rounded,
                                                    color: send
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                ),
                                                SizedBox(
                                                  // color: Colors.red,
                                                  width: responsive.wp(20),
                                                  child: Text(
                                                    httpService
                                                        .transfers[index].fecha,
                                                    style: contentStyle,
                                                  ),
                                                ),
                                                SizedBox(
                                                  // color: Colors.red,
                                                  width: responsive.wp(18),
                                                  child: Text(
                                                      httpService
                                                          .transfers[index]
                                                          .cuentaOrigen
                                                          .toString(),
                                                      style: contentStyle),
                                                ),
                                                SizedBox(
                                                  width: responsive.wp(18),
                                                  child: Text(
                                                    httpService.transfers[index]
                                                        .cuentaDestino
                                                        .toString(),
                                                    style: contentStyle,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: responsive.wp(16),
                                                  child: Text(
                                                    httpService
                                                        .transfers[index].monto
                                                        .toString(),
                                                    style: contentStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  const TableHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    TextStyle titleStyle = TextStyle(
        fontSize: responsive.dp(1.4),
        fontWeight: FontWeight.bold,
        color: Colors.white);
    return Container(
      width: responsive.wp(98),
      height: responsive.hp(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: responsive.wp(8),
              child: Text(
                'TIPO',
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
            ),
            SizedBox(
              width: responsive.wp(12),
              child: Text(
                'FECHA',
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
            ),
            SizedBox(
              width: responsive.wp(14),
              child: Text(
                'CUENTA ORIGEN',
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
            ),
            SizedBox(
              width: responsive.wp(14),
              child: Text(
                'CUENTA DESTINO',
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
            ),
            SizedBox(
              width: responsive.wp(22),
              child: Text(
                'MONTO TRANSFERIDO',
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              offset: const Offset(-0.1, 0.1),
              blurRadius: 2,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.grey[300]!,
              offset: const Offset(0.1, -0.1),
              blurRadius: 2,
              spreadRadius: 2,
            )
          ]),
    );
  }
}
