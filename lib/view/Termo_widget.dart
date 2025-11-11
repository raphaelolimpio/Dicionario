import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/Card_enum.dart';
import 'package:dicionario/DS/Components/Card/ListCard/List_card_custom.dart';
import 'package:dicionario/DS/Components/Card/model/card_custom/Card_custom_view_model.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
import 'package:dicionario/Service/termo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermoWidget extends StatefulWidget {
  final void Function(PostModel)? onTermoSelected;
  final String? searchTerm;
  const TermoWidget({Key? key, this.onTermoSelected, this.searchTerm})
    : super(key: key);
  @override
  State<StatefulWidget> createState() => _TermoWidgetState();
}

class _TermoWidgetState extends State<TermoWidget>
    with TickerProviderStateMixin {

  @override
  void didUpdateWidget(covariant TermoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchTerm != oldWidget.searchTerm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final currentTopico = context
              .read<TermoService>()
              .selectedTopicoFilter;
          _fetchTermo(topico: currentTopico, nome: widget.searchTerm);
        }
      });
    }
  }

  void _fetchTermo({String? topico, String? nome}) {
    context.read<TermoService>().fetchTermos(topico: topico, nome: nome);
  }

  List<CardCustomViewModel> _mapPostsToCardViewModels(List<PostModel> posts) {
    return posts.map((post) {
      return CardCustomViewModel(
        id: post.id,
        topico: post.topico,
        nome: post.nome ?? "sem nome",
        categoria: post.categoria ?? "sem nome",
        definicao: post.definicao ?? "sem nome",
        comando_exemplo: post.comando_exemplo ?? "",
        explicacao_pratica: post.explicacao_pratica ?? "sem nome",
        dicas_de_uso: post.dicas_de_uso ?? "",
        buttonText: 'Detalhes',
        onButtonPressed: (context) {
          if (widget.onTermoSelected != null) {
            widget.onTermoSelected!(post);
          }
        },
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
      );
    }).toList();
  }

  Widget _buildTryAgainButton(String message, VoidCallback onPressed) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final termoService = context.watch<TermoService>();
    switch (termoService.pageState) {
      case RequestState.loading:
      case RequestState.idle:
        return const Center(child: CircularProgressIndicator());
      case RequestState.error:
        return _buildTryAgainButton(
          termoService.pageError ?? 'Ocorreu um erro.',
          () => context.read<TermoService>().initialLoad(),
        );
      case RequestState.success:
        final categories = ['Todos', ...termoService.topicosResponse!.data!];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Filtrar por Tópicos',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                value: termoService.selectedTopicoFilter ?? 'Todos',
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _fetchTermo(
                    topico: newValue == 'Todos' ? null : newValue,
                    nome: widget.searchTerm,
                  );
                },
              ),
            ),
            const Divider(height: 20, thickness: 1),
            Expanded(
              child: termoService.termosResponse == null
                  ? const Center(child: CircularProgressIndicator())
                  : termoService.termosResponse!.data!.isEmpty
                  ? const Center(child: Text('Nenhum Termo encontrado'))
                  : ListCard(
                      cards: _mapPostsToCardViewModels(
                        termoService.termosResponse!.data!,
                      ),
                      cardModelType: CardModelType.cardCustom,
                      displayMode: CardDisplayMode.verticalList,
                      listHeight: 400,
                    ),
            ),
          ],
        );
    }
  }
}
