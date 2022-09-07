import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:transferencia_bancaria/src/providers/http_service.dart';
import 'package:transferencia_bancaria/src/utils/responsive.dart';
import 'package:transferencia_bancaria/src/views/transfers_history_view.dart';
import 'package:transferencia_bancaria/src/views/transfers_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HttpService httpService = HttpService();
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  size: responsive.dp(4),
                ))
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: responsive.wp(98),
              height: responsive.hp(98),
              child: FutureBuilder(
                  future: httpService.getUsersAcount(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else if (snapshot.hasData) {
                        return AnimationLimiter(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    curve: Curves.easeInCirc,
                                    child: FadeInAnimation(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(2),
                                          vertical: responsive.hp(1.5),
                                        ),
                                        child: Container(
                                          width: responsive.wp(90),
                                          height: responsive.horizontal!
                                              ? responsive.hp(15)
                                              : responsive.hp(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: responsive.wp(35),
                                                child: Text(
                                                  snapshot.data[index].name,
                                                  style: TextStyle(
                                                      fontSize:
                                                          responsive.dp(2),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              SizedBox(
                                                width: responsive.wp(25),
                                                child: Text(
                                                  '\$' +
                                                      snapshot.data[index]
                                                          .saldoCuenta
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          responsive.dp(2),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Image(
                                                  image: const AssetImage(
                                                      'assets/images/transferencia.png'),
                                                  width: responsive.wp(10),
                                                  height: responsive.wp(10),
                                                ),
                                                onPressed: () {
                                                  Route route =
                                                      MaterialPageRoute(
                                                    builder: (c) =>
                                                        TransfersView(
                                                      nit: snapshot
                                                          .data[index].nit,
                                                      saldo: snapshot
                                                          .data[index]
                                                          .saldoCuenta,
                                                      accountNumber: snapshot
                                                          .data[index]
                                                          .numeroCuenta,
                                                    ),
                                                  );
                                                  Navigator.of(context)
                                                      .push(route);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.receipt_long_rounded,
                                                  color: Colors.blue,
                                                  size: responsive.dp(4),
                                                ),
                                                onPressed: () {
                                                  Route route =
                                                      MaterialPageRoute(
                                                    builder: (c) =>
                                                        TransfersHistoryView(
                                                      numeroCuenta: snapshot
                                                          .data[index]
                                                          .numeroCuenta,
                                                    ),
                                                  );
                                                  Navigator.of(context)
                                                      .push(route);
                                                },
                                              )
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[300]!,
                                                  offset:
                                                      const Offset(-0.1, 0.1),
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                ),
                                                BoxShadow(
                                                  color: Colors.grey[300]!,
                                                  offset:
                                                      const Offset(0.1, -0.1),
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                )
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return const Text('Empty data');
                      }
                    } else {
                      return Text('State: ${snapshot.connectionState}');
                    }
                  }),
            ),
          ),
        ));
    // child: Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     const Text(
    //       'RICARDO RAMIREZ NEGRETE',
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         ElevatedButton(
    //           child: Text('Transferencia'),
    //           onPressed: () => Navigator.of(context).pushNamed('/trasnfer'),
    //         ),
    //         ElevatedButton(
    //           child: Text('Consulta tus trasnferencias'),
    //           onPressed: () =>
    //               Navigator.of(context).pushNamed('/trasnfers_history'),
    //         ),
    //       ],
    //     ),
    //   ],
    //     ),
    //   ),
    // );
  }
}
