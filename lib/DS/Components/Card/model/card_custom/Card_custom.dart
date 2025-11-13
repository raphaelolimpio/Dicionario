import 'package:dicionario/DS/Components/Button/Favorite/Favorite_toggle_button.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom/Card_custom_view_model.dart';
import 'package:dicionario/DS/Components/IconText/Icon_Text.dart';
import 'package:dicionario/DS/Components/bash/Code_Block.dart';
import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class CardCustom extends StatefulWidget {
  final CardCustomViewModel viewModel;
  final double? cardWidth;

  const CardCustom({super.key, required this.viewModel, this.cardWidth});

  @override
  State<CardCustom> createState() => _CardCustomState();
}

class _CardCustomState extends State<CardCustom> {


  
  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        width: widget.cardWidth,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: WhiteTextColor,
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: IconTextRow(
                      iconModel: widget.viewModel.topicoIcon,
                      label: "",
                      text: widget.viewModel.topico,
                      style: TextStyle(
                        color: theme.shadowColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  FavoriteToggleButton(
                    itemId: widget.viewModel.id,
                    itemModel: widget.viewModel.toPostModel(),
                  ),
                ],
              ),
              const Divider(height: 10),
              IconTextRow(
                iconModel: widget.viewModel.categorIcon,
                label: "Categoria: ",
                text: widget.viewModel.nome,
                style: TextStyle(
                  color: BlackTextColor,
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                ),
              ),

              IconTextRow(
                iconModel: widget.viewModel.definicaoIcon,
                label: "Definição: ",
                text: widget.viewModel.definicao,
                style: TextStyle(
                  color: BlackTextColor,
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                ),
              ),
              IconTextRow(
                iconModel: widget.viewModel.comandoExemploIcon,
                label: "Comando Exemplo: ",
                text: "",
                
              ),

              CodeBlock(code: widget.viewModel.comando_exemplo),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(theme.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () => widget.viewModel.onButtonPressed(context),
                  child: Text(widget.viewModel.buttonText, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
