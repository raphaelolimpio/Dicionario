import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/model/Card_custom4/Card_custm4_view_model.dart';
import 'package:dicionario/DS/Components/IconText/Icon_Text.dart';
import 'package:dicionario/DS/Components/codeBlockForm/Code_block_form_field.dart';
import 'package:dicionario/DS/Components/IconTextForm/icon_text_form_field_row.dart';
import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class CardCustom4 extends StatefulWidget {
  final CardCustom4ViewModel viewModel;
  final double? cardWidth;

  const CardCustom4({super.key, required this.viewModel, this.cardWidth});

  @override
  State<CardCustom4> createState() => CardCustom4State();
}

class CardCustom4State extends State<CardCustom4> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _topicoController;
  late TextEditingController _nomeController;
  late TextEditingController _categoriaController;
  late TextEditingController _definicaoController;
  late TextEditingController _comandoExemploController;
  late TextEditingController _explicacaoPraticaController;
  late TextEditingController _dicasDeUsoController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.viewModel.initialData;
    _topicoController = TextEditingController(text: data?.topico ?? '');
    _nomeController = TextEditingController(text: data?.nome ?? '');
    _categoriaController = TextEditingController(text: data?.categoria ?? '');
    _definicaoController = TextEditingController(text: data?.definicao ?? '');
    _comandoExemploController = TextEditingController(
      text: data?.comando_exemplo ?? '',
    );
    _explicacaoPraticaController = TextEditingController(
      text: data?.explicacao_pratica ?? '',
    );
    _dicasDeUsoController = TextEditingController(
      text: data?.dicas_de_uso ?? '',
    );
  }

  @override
  void dispose() {
    _topicoController.dispose();
    _nomeController.dispose();
    _categoriaController.dispose();
    _definicaoController.dispose();
    _comandoExemploController.dispose();
    _explicacaoPraticaController.dispose();
    _dicasDeUsoController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final postModel = PostModel(
        id: widget.viewModel.initialData?.id ?? 0,
        topico: _topicoController.text,
        nome: _nomeController.text,
        categoria: _categoriaController.text,
        definicao: _definicaoController.text,
        comando_exemplo: _comandoExemploController.text.isNotEmpty
            ? _comandoExemploController.text
            : null,
        explicacao_pratica: _explicacaoPraticaController.text,
        dicas_de_uso: _dicasDeUsoController.text.isNotEmpty
            ? _dicasDeUsoController.text
            : null,
      );
      try {
        await widget.viewModel.onSave(postModel);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: WhiteTextColor,
          border: Border.all(color: GrayBorderColor),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: GrayBorderColor.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTextRow(
                iconModel: widget.viewModel.topicoIcon,
                label: "",
                text: _topicoController.text.isNotEmpty
                    ? _topicoController.text
                    : 'Novo tópico',
                style: TextStyle(
                  color: ThemeCardIconColorDarkblue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const Divider(height: 10),

              IconTextFormFieldRow(
                iconModel: widget.viewModel.categorIcon,
                label: "Categoria:",
                controller: _categoriaController,
                hintText: 'Categoria',
                requiredField: false,
              ),

              IconTextFormFieldRow(
                iconModel: widget.viewModel.definicaoIcon,
                label: "Definição:",
                controller: _definicaoController,
                hintText: 'Definição do termo',
                maxLines: 3,
                requiredField: true,
              ),
              IconTextRow(
                iconModel: widget.viewModel.comandoExemploIcon,
                label: "Comando Exemplo: ",
                text: "",
              ),
              CodeBlockFormField(
                controller: _comandoExemploController,
                maxLines: 6,
                hintText: 'Escreva o comando aqui...',
              ),

              IconTextFormFieldRow(
                iconModel: widget.viewModel.explicacaoPraticaIcon,
                label: "Explicação Prática:",
                controller: _explicacaoPraticaController,
                hintText: 'Explicação prática',
                maxLines: 3,
              ),

              IconTextFormFieldRow(
                iconModel: widget.viewModel.dicasDeUsoIcon,
                label: "Dicas de Uso:",
                controller: _dicasDeUsoController,
                hintText: 'Dicas de uso',
                maxLines: 2,
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      BlueButtonColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          widget.viewModel.buttonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
