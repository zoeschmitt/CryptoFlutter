import 'dart:async';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:data_moving/models/coin_model.dart';
import 'package:data_moving/repositories/crypto_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/semantics.dart';
import 'package:meta/meta.dart';

part 'crypto_event.dart';
part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository _cryptoRepository;

  CryptoBloc({@required CryptoRepository cryptoRepository})
      : assert(cryptoRepository != null),
        _cryptoRepository = cryptoRepository;

  @override
  CryptoState get initialState => CryptoEmpty();

  @override
  Stream<CryptoState> mapEventToState(
    CryptoEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCoins) {
      yield* _getCoins(coins: []);
    } else if (event is LoadMoreCoins) {
      yield* _mapLoadMoreCoinsToState(event); 
    }
  }

  Stream<CryptoState> _getCoins({List<Coin> coins, int page = 0}) async* {
    //request coins
    try {
      List<Coin> newCoinsList =
      coins + await _cryptoRepository.getTopCoins(page: page);
      yield CryptoLoaded(coins: newCoinsList);
    } catch (err) {
      yield CryptoError();
    }
  }

  Stream<CryptoState> _mapAppStartedToState() async* {
    yield CryptoLoading();
    yield* _getCoins(coins: []);
  }

  Stream<CryptoState> _mapLoadMoreCoinsToState(LoadMoreCoins event) async* {
    final int nextPage = event.coins.length ~/ CryptoRepository.perPage;
    yield* _getCoins(coins: event.coins, page: nextPage);
  }
}
