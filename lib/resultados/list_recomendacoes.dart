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
                                      widget.item.prioridade.trim(),
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
  
  Color definirCor(String prioridade) {
    switch (prioridade.trim()) {
      case 'Alta':
        return Colors.redAccent.shade200; // You can change this color according to your preference
      case 'Média':
        return Colors.amber; // You can change this color according to your preference
      case 'Baixa':
        return Colors.lightGreen.shade200; // You can change this color according to your preference
      default:
        return Colors.black; // Default color
    }
  }

}