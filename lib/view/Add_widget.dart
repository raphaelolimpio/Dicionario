import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/model/Card_custom4/Card_custm4_view_model.dart';
import 'package:dicionario/DS/Components/Card/model/Card_custom4/Card_custom4.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
import 'package:dicionario/Service/Creat_service.dart';
import 'package:flutter/material.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({Key? key}) : super(key: key);

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CardCustom4(
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
              icon: IconType.definition,
              color: colorType.darkblue,
              size: IconSize.medium,
            ),
            dicasDeUsoIcon: IconViewModel(
              icon: IconType.fixed,
              color: colorType.darkblue,
              size: IconSize.medium,
            ),
          ),
        ),
      ),
    );
  }
}
