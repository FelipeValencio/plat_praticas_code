import 'package:plat_praticas/resultados/result_item.dart';
import 'package:rxdart/rxdart.dart';

class FiltroBloc {

  final _listaFiltradaFetcher = PublishSubject<List<ResultItem>>();

  Stream<List<ResultItem>> get listaFiltrada => _listaFiltradaFetcher.stream;

  setListaFiltrada(List<ResultItem> list) async {

    _listaFiltradaFetcher.sink.add(list);

  }

  dispose() {

    _listaFiltradaFetcher.close();

  }

}

final filtroBloc = FiltroBloc();