import 'package:flutter/material.dart';
import 'package:plat_praticas/resultados/result_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ListRecomendacoes extends StatefulWidget {
  final ResultItem item;

  const ListRecomendacoes({super.key, required this.item});

  @override
  State<ListRecomendacoes> createState() => _ListRecomendacoesState();
}

class _ListRecomendacoesState extends State<ListRecomendacoes> {

  bool lido = false;
  
  @override
  Widget build(BuildContext context) {
    String caracteristicas = widget.item.caracteristicas.join(', ');
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Card(
            elevation: 2,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: definirCor(widget.item.prioridade),
                    ),
                  ),
                  Flexible(
                    child: Theme(
                      data: ThemeData().copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        onExpansionChanged: (bool v) {
                          setState(() {
                            lido = true;
                          });
                        },
                        iconColor: definirCor(widget.item.prioridade),
                        title: Text(
                          widget.item.recomendacao,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: lido ? FontWeight.normal : FontWeight.bold,
                            color: lido ? Colors.grey : Colors.black,
                          ),
                        ),
                        collapsedIconColor: definirCor(widget.item.prioridade),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Descrição: ${widget.item.descricao}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => launchUrl(Uri.parse(widget.item.link)),
                                  child: Text(
                                    widget.item.link,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Características: $caracteristicas',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Prioridade de implementação: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      getPrioridade(widget.item.prioridade),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: definirCor(widget.item.prioridade)
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Color definirCor(int prioridade) {
    switch (prioridade) {
      case 1:
        return Colors.redAccent.shade200;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.lightGreen.shade200;
      default:
        return Colors.black;
    }
  }

  String getPrioridade(int prioridade) {
    switch (prioridade) {
      case 1:
        return "Alta";
      case 2:
        return "Média";
      case 3:
        return "Baixa";
      default:
        return "";
    }
  }

}