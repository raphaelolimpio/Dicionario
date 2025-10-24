import 'package:dicionario/Config/model/Post_model.dart'; 
import 'package:dicionario/DS/Components/Reactive/Reactive.dart';
import 'package:dicionario/Service/favorite_service.dart';
import 'package:flutter/material.dart';


class FavoriteToggleButton extends StatefulWidget {
  final int itemId;
  final PostModel itemModel; 
  const FavoriteToggleButton({
    Key? key,
    required this.itemId,
    required this.itemModel,
  }) : super(key: key);

  @override
  State<FavoriteToggleButton> createState() => _FavoriteToggleButtonState();
}

class _FavoriteToggleButtonState extends State<FavoriteToggleButton> {
  late Future<bool> _isFavoritedFuture;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    _isFavoritedFuture = FavoriteService.isFavorite(widget.itemId);
  }

  Future<void> _toggleFavorite(bool isCurrentlyFavorited) async {
    if (isCurrentlyFavorited) {

      final removedItem = await FavoriteService.removeFavorite(widget.itemId);
      if (removedItem != null && mounted) { 
        Reactive.showUndoSnackBar(
          context: context,
          message: 'Item removido dos favoritos.',
          onUndo: () async {
            await FavoriteService.addFavorite(removedItem);
            if (mounted) {
              setState(() {
                _checkFavoriteStatus();
              });
            }
          },
        );
      }
    } else {
      await FavoriteService.addFavorite(widget.itemModel);
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Adicionado aos favoritos!'),
             duration: Duration(seconds: 2), 
           ),
         );
      }
    }
    if (mounted) {
      setState(() {
        _checkFavoriteStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isFavoritedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const IconButton(
            icon: SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.red),
            ),
            onPressed: null, 
          );
        }
        bool isFavorited = snapshot.hasData && snapshot.data == true;

        return IconButton(
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () => _toggleFavorite(isFavorited), 
          tooltip: isFavorited ? 'Desfavoritar' : 'Favoritar',
        );
      },
    );
  }
}
