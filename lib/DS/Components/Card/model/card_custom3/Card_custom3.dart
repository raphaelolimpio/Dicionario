import 'package:dicionario/DS/Components/Card/model/card_custom3/Card_custom3_view_model.dart';
import 'package:dicionario/DS/Components/Reactive/Reactive.dart';
import 'package:dicionario/Service/favorite_service.dart';
import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';


class CardCustom3 extends StatefulWidget {
  final CardCustom3ViewModel viewModel;
  final double? cardWidth;
  final VoidCallback? onFavortiteRemoved;

  const CardCustom3({
    super.key,
    required this.viewModel,
    this.onFavortiteRemoved,
    this.cardWidth,
  });

  @override
  State<CardCustom3> createState() => _CardCustom3State();
}

class _CardCustom3State extends State<CardCustom3> {
  late Future<bool> _isFavoritedFuture;


  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    _isFavoritedFuture = FavoriteService.isFavorite(widget.viewModel.id);
    setState(() {});
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.viewModel.topico,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Text(
                    widget.viewModel.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<bool>(
                  future: _isFavoritedFuture,
                  builder: (context, snapshot) {
                    bool isFavorited = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        if (isFavorited) {
                          final removedItem =
                              await FavoriteService.removeFavorite(
                                widget.viewModel.id,
                              );
                          if (removedItem != null) {
                            if (widget.onFavortiteRemoved != null) {
                              widget.onFavortiteRemoved!();
                            }
                            Reactive.showUndoSnackBar(
                              context: context,
                              message: 'Item removido dos favoritos.',
                              onUndo: () async {
                                await FavoriteService.addFavorite(removedItem);
                                _checkFavoriteStatus();
                              },
                            );
                            _checkFavoriteStatus();
                          }
                        } else {
                          await FavoriteService.addFavorite(
                            widget.viewModel.toPostModel(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Adicionado aos favoritos!'),
                            ),
                          );
                          _checkFavoriteStatus();
                        }
                      },
                      tooltip: isFavorited ? 'Desfavoritar' : 'Favoritar',
                    );
                  },
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
