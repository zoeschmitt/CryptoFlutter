import 'package:data_moving/blocs/bloc/crypto_bloc.dart';
import 'package:data_moving/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';
import 'package:data_moving/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CryptoBloc>(
      create: (_) => CryptoBloc(
        cryptoRepository: CryptoRepository(),
        )..add(AppStarted()),
          child: MaterialApp(
          title: 'flutter demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.tealAccent
          ),
        home: HomePage(),
      ),
    );
  }
}
