import 'package:plat_praticas/common/util.dart';

class MaquinaEstado {

  int progresso = 1;

  int estadoAtual = 2;

  late List<List<String>> tabelaEstado;

  late List<int> estadosPassados = [];

  List<String> controles = [];

  List<String> controlesPadrao = [];

  List<List<String>> controlesPassados = [];

  Future<void> validarTabela() async {

    tabelaEstado = await Util.lerTabela("tabela_estado.csv");

    var idsEncontrados = <String>{};
    var perguntasEncontradas = <String>{};

    for (var numLinha = 1; numLinha < tabelaEstado.length; numLinha++) {
      var linha = tabelaEstado[numLinha];
      if (linha[0].isEmpty) {
        throw("Erro: O campo ID é obrigatório e está vazio (Erro na linha "
            "${numLinha + 1}).");
      } else {
        // Verificar IDs duplicados
        var idAtual = linha[0];
        if (idsEncontrados.contains(idAtual)) {
          throw("Erro: ID '$idAtual' duplicado encontrado na linha ${numLinha +
              1}.");
        } else {
          idsEncontrados.add(idAtual);
        }
      }

      if (linha[1].isEmpty) {
        throw("Erro: O campo Perguntas é obrigatório e está vazio (Erro na linha "
                "${numLinha + 1}).");
      } else {
        // Verificar perguntas duplicados
        var perguntaAtual = linha[1];
        if (perguntasEncontradas.contains(perguntaAtual)) {
          throw("Erro: Pergunta '$perguntaAtual' duplicada encontrada na linha "
                  "${numLinha + 1}.");
        } else {
          perguntasEncontradas.add(perguntaAtual);
        }
      }

      // if (linha[2].isEmpty && linha[3].isEmpty) {
      //   throw("Erro: O campo Recomendações é obrigatório e está vazio (Erro na linha "
      //       "${numLinha + 1}).");
      // }
    }
  }

  void voltar() {
    if(estadosPassados.length <= 1) {
      estadoAtual = 2;
      progresso = 1;
      controles = [];
      return;
    }

    controles = controlesPassados.removeLast();
    estadoAtual = estadosPassados.removeLast();
    progresso--;
  }

  String getPergunta() {
    return "$progresso. ${tabelaEstado[estadoAtual][1]}";
  }

  void respostaSim() {
    estadosPassados.add(estadoAtual);

    estadoAtual =
        Util.encontrarIndicePorId(tabelaEstado, tabelaEstado[estadoAtual][4]);

    controlesPassados.add(copiaLiteral(controles));
    progresso++;

    var controlesSim = tabelaEstado[estadoAtual][2];

    controles.addAll(controlesSim.split('\n').where((c) {
      String trimmed = c.trim();
      return trimmed.isNotEmpty && !controles.contains(trimmed);
    }));
  }

  void respostaNao() {
    estadosPassados.add(estadoAtual);

    estadoAtual =
        Util.encontrarIndicePorId(tabelaEstado, tabelaEstado[estadoAtual][5]);

    controlesPassados.add(copiaLiteral(controles));
    progresso++;

    var controlesNao = tabelaEstado[estadoAtual][3];

    controles.addAll(controlesNao.split('\n').where((c) {
      String trimmed = c.trim();
      return trimmed.isNotEmpty && !controles.contains(trimmed);
    }));

  }

  List<String> copiaLiteral(List<String> list) {
    return List<String>.from(list);
  }

  void listarControlesPadroes() {
    var controlesPad = tabelaEstado[1][2];

    controlesPadrao.addAll(controlesPad.split('\n').where((c) {
      String trimmed = c.trim();
      return trimmed.isNotEmpty && !controlesPadrao.contains(trimmed);
    }));
  }
}