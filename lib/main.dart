import 'package:flutter/material.dart';
import 'package:plat_praticas/common/mensagem_erro.dart';
import 'package:plat_praticas/maquina_estado.dart';
import 'package:plat_praticas/resultados/resultados.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionário de práticas para ambientes cloud AWS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Questionário de práticas para ambientes cloud em AWS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MaquinaEstado maquinaEstado = MaquinaEstado();

  late String perguntaAtual = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      carregarTabela();
    });

    super.initState();
  }

  Future<List<List<String>>> carregarTabela() async {
    try {
      await maquinaEstado.validarTabela();
      maquinaEstado.listarControlesPadroes();

      setState(() {
        perguntaAtual = maquinaEstado.getPergunta();
      });


    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ErrorMessageDialog(
          errorMessage: e.toString(),
        ),
      );
    }
    return maquinaEstado.tabelaEstado;
  }

  void respondeuSim() {
    try {
      maquinaEstado.respostaSim();
      getPergunta();
    } on StateError catch (e) {
      print("Erro de Estado: ${e.toString()}");
      maquinaEstado.estadosPassados.removeLast();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(
          recomendacoes: maquinaEstado.controles,
          recomendacoesPadrao: maquinaEstado.controlesPadrao,)),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ErrorMessageDialog(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void respondeuNao() {
    try {
      maquinaEstado.respostaNao();
      getPergunta();
    } on StateError catch (e) {
      print("Erro de Estado: ${e.toString()}");
      maquinaEstado.estadosPassados.removeLast();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(
          recomendacoes: maquinaEstado.controles,
          recomendacoesPadrao: maquinaEstado.controlesPadrao)
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ErrorMessageDialog(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void getPergunta() {
    try {
      setState(() {
        perguntaAtual = maquinaEstado.getPergunta();
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ErrorMessageDialog(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void voltar() {
    try {
      maquinaEstado.voltar();
      getPergunta();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => ErrorMessageDialog(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          progresso(),
          Column(
            children: [
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.80,
                child: Text(
                  perguntaAtual,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => respondeuSim(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      "Sim",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () => respondeuNao(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      "Não",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50,),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => voltar(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0
            ),
            icon: const Icon(Icons.arrow_back),
            label: const Text(
              "Voltar",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget progresso() {
    return FutureBuilder(
      future: carregarTabela(),
      builder: (context, snapshot) {

        if(!snapshot.hasData) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                children: [
                  Text(
                    "Progresso atual: ${((maquinaEstado.progresso / (maquinaEstado.tabelaEstado.length-1))*100).floor()}%",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20,),
                  StepProgressIndicator(
                    totalSteps: maquinaEstado.tabelaEstado.length - 1,
                    currentStep: maquinaEstado.progresso,
                    size: 30,
                    padding: 0,
                    selectedColor: Colors.deepPurple,
                    unselectedColor: Colors.grey,
                    roundedEdges: const Radius.circular(10),
                  ),
                ],
              )
          ),
        );
      },
    );
  }

}
