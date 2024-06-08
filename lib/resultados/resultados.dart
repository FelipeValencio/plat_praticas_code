import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:plat_praticas/common/mensagem_erro.dart';
import 'package:plat_praticas/resultados/list_recomendacoes.dart';
import 'package:plat_praticas/resultados/result_item.dart';
import 'package:plat_praticas/common/util.dart';

class ResultPage extends StatelessWidget {

  late List<String> recomendacoes;
  late List<String> recomendacoesPadrao;

  late List<List<String>> tabelaRecomendacoes;

  late List<ResultItem> resultsCsv;

  ResultPage(
      {super.key, required this.recomendacoes, required this.recomendacoesPadrao});

  Future<List<ResultItem>> buildResults() async {
    tabelaRecomendacoes = await Util.lerTabela("tabela_auxiliar.csv");

    List<ResultItem> results = [];

    resultsCsv = results;

    recomendacoes.addAll(recomendacoesPadrao);

    for (String r in recomendacoes) {
      int indiceRec = Util.encontrarIndicePorId(tabelaRecomendacoes, r);
      results.add(ResultItem(
          recomendacao: tabelaRecomendacoes[indiceRec][0],
          prioridade: int.parse(tabelaRecomendacoes[indiceRec][4]),
          caracteristicas: tabelaRecomendacoes[indiceRec][3].trim().split(";"),
          descricao: tabelaRecomendacoes[indiceRec][2],
          padrao: recomendacoesPadrao.contains(r),
          link: tabelaRecomendacoes[indiceRec][1]));
    }

    return results;
  }

  String listToCsv(List<ResultItem> results) {
    final csvBuffer = StringBuffer();
    csvBuffer.writeln(ResultItem.csvHeader());

    for (var result in results) {
      csvBuffer.writeln(result.toCsvRow());
    }

    return csvBuffer.toString();
  }

  void downloadCSV(String file) async {
    Uint8List bytes = Uint8List.fromList(utf8.encode(file));

    await FileSaver.instance.saveFile(
      name: 'recomendacoes_aws',
      bytes: bytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        actions: [
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Baixar resultados'),
                onPressed: () => downloadCSV(listToCsv(resultsCsv)),
              ),
            ],
          )
        ],
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

          // Sort the lists by priority (integer field) in descending order
          standardControls.sort((a, b) => a.prioridade.compareTo(b.prioridade));
          assessmentControls.sort((a, b) => a.prioridade.compareTo(b.prioridade));

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

}