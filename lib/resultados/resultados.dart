import 'package:flutter/material.dart';
import 'package:plat_praticas/common/mensagem_erro.dart';
import 'package:plat_praticas/resultados/list_recomendacoes.dart';
import 'package:plat_praticas/resultados/result_item.dart';
import 'package:plat_praticas/common/util.dart';

class ResultPage extends StatelessWidget {

  late List<String> recomendacoes;
  late List<String> recomendacoesPadrao;

  late List<List<String>> tabelaRecomendacoes;

  ResultPage(
      {super.key, required this.recomendacoes, required this.recomendacoesPadrao});

  Future<List<ResultItem>> buildResults() async {
    tabelaRecomendacoes = await Util.lerTabela("tabela_recomendacoes.csv");

    List<ResultItem> results = [];

    recomendacoes.addAll(recomendacoesPadrao);

    for (String r in recomendacoes) {
      int indiceRec = Util.encontrarIndicePorId(tabelaRecomendacoes, r);
      results.add(ResultItem(
          recomendacao: tabelaRecomendacoes[indiceRec][0],
          prioridade: tabelaRecomendacoes[indiceRec][3],
          descricao: tabelaRecomendacoes[indiceRec][2],
          padrao: recomendacoesPadrao.contains(r),
          link: tabelaRecomendacoes[indiceRec][1]),
      );
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: FutureBuilder<List<ResultItem>>(
        future: buildResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorMessageDialog(
                      errorMessage: snapshot.error.toString(),
                    ),
              );
            });
            return const SizedBox.shrink();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) =>
                const ErrorMessageDialog(
                  errorMessage: "Falha ao carregar os dados de resultado",
                ),
              );
            });
            return const SizedBox.shrink();
          }

          List<ResultItem> standardControls = [];
          List<ResultItem> assessmentControls = [];
          for (var item in snapshot.data!) {
            if (item.padrao) {
              standardControls.add(item);
            } else {
              assessmentControls.add(item);
            }
          }

          // Sort the lists by priority
          Map<String, int> priorityOrder = {'Alta': 3, 'Média': 2, 'Baixa': 1};
          standardControls.sort((a, b) =>
              priorityOrder[b.prioridade.trim()]!.compareTo(
                  priorityOrder[a.prioridade.trim()]!));
          assessmentControls.sort((a, b) =>
              priorityOrder[b.prioridade.trim()]!.compareTo(
                  priorityOrder[a.prioridade.trim()]!));


          List<Widget> listaAssessment = assessmentControls.map((e) {
            ListRecomendacoes listRecomendacao = ListRecomendacoes(item: e);
            return listRecomendacao;
          }).toList();

          List<Widget> listaPadrao = standardControls.map((e) {
            ListRecomendacoes listRecomendacao = ListRecomendacoes(item: e);
            return listRecomendacao;
          }).toList();

          return ListView(
            children: [
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text(
                      'Práticas recomendadas a partir das respostas do questionário'),
                  initiallyExpanded: true,
                  children: listaAssessment
                ),
              ),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text('Práticas recomendadas por padrão'),
                  children: listaPadrao
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color definirCor(String prioridade) {
    switch (prioridade.trim()) {
      case 'Alta':
        return Colors.redAccent.shade200;
      case 'Média':
        return Colors.amber;
      case 'Baixa':
        return Colors.lightGreen.shade200;
      default:
        return Colors.black;
    }
  }

}