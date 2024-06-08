class ResultItem {
  final String recomendacao;
  final String descricao;
  final String link;
  final List<String> caracteristicas;
  final int prioridade;
  final bool padrao;

  ResultItem({required this.caracteristicas, required this.recomendacao,
    required this.descricao, required this.link,
    required this.prioridade, required this.padrao});

  String toCsvRow() {
    final caracteristicasStr = caracteristicas.join(',');
    return '$recomendacao;$prioridade;$caracteristicasStr;$descricao;$link';
  }

  static String csvHeader() {
    return 'Recomendacao;Prioridade;Caracteristicas;Descricao;Link';
  }
}
