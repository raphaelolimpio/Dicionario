import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/Config/server/Api_service.dart';
import 'package:dicionario/DS/Components/Card/model/Card_custom4/Card_custm4_view_model.dart';
import 'package:dicionario/DS/Components/Card/model/Card_custom4/Card_custom4.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
import 'package:dicionario/Service/Creat_service.dart';
import 'package:dicionario/Service/topico_sevice.dart';
import 'package:flutter/material.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({Key? key}) : super(key: key);

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  late Future<ApiResponse<List<String>>> _topicosFuture;

  Key _formCardKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _topicosFuture = TopicoSevice.getAllTopico();
  }

  Future<void> _handleSave(PostModel postData) async {
    try {
      final response = await CreatService.createTermo(postData);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Termo "${response.data?.nome}" salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _formCardKey = UniqueKey();
        });
      } else {
        throw Exception('Falha ao salvar: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar o termo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalTheme = Theme.of(context);
    return FutureBuilder<ApiResponse<List<String>>>(
      future: _topicosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.data == null) {
          return Center(
            child: Text(
              "Erro ao carregar os tópico. \n${snapshot.error}",
              textAlign: TextAlign.center, 
            ),
          );
        }
        final topicos = snapshot.data!.data!;
        if (topicos.isEmpty) {
          return const Center(
            child: Text(
              "Nenhum tópico encontrado para adicionar novos termos.",
            ),
          );
        }
        return Theme(
          data: ThemeData.light().copyWith(
            scaffoldBackgroundColor: globalTheme.scaffoldBackgroundColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CardCustom4(
                key: _formCardKey,
                topicos: topicos,
                dropdownBackgroundColor: globalTheme.scaffoldBackgroundColor,
                dropdownTextStyle: globalTheme.textTheme.bodyMedium,
                viewModel: CardCustom4ViewModel(
                  buttonText: 'Adicionar Novo Termo',
                  initialData: null,
                  onSave: _handleSave,
                  topicoIcon: IconViewModel(
                    icon: IconType.fixed,
                    color: colorType.darkblue,
                    size: IconSize.medium,
                  ),
                  categorIcon: IconViewModel(
                    icon: IconType.folder,
                    color: colorType.yellow,
                    size: IconSize.medium,
                  ),
                  definicaoIcon: IconViewModel(
                    icon: IconType.definition,
                    color: colorType.pink,
                    size: IconSize.medium,
                  ),
                  comandoExemploIcon: IconViewModel(
                    icon: IconType.bash,
                    color: colorType.green,
                    size: IconSize.medium,
                  ),
                  explicacaoPraticaIcon: IconViewModel(
                    icon: IconType.dialog,
                    color: colorType.cyan,
                    size: IconSize.medium,
                  ),
                  dicasDeUsoIcon: IconViewModel(
                    icon: IconType.dica,
                    color: colorType.orange,
                    size: IconSize.medium,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
