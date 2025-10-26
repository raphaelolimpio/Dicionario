import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Button/ButtonNavigation/Button_navigation_bar.dart';
import 'package:dicionario/DS/Components/Button/ButtonNavigation/Button_navigation_bar_view_model.dart';
import 'package:dicionario/DS/Components/appBar/Custom_appBar.dart';
import 'package:dicionario/view/Add_widget.dart';
import 'package:dicionario/view/Detail_widget.dart';
import 'package:dicionario/view/Favorite_widget.dart';
import 'package:dicionario/view/Home_widget.dart';
import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});
  @override
  State<StatefulWidget> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _selectedIndex = 0;
  PostModel? _selectedTermo;
  bool _isShowingFavorites = false;
  bool _isShowingAdd = false;

  final List<ButtonNavigationBarViewModel> _bottomNavItems = [
    ButtonNavigationBarViewModel(name: 'Home', icon: Icons.home),
    ButtonNavigationBarViewModel(name: 'Favoritos', icon: Icons.favorite),
     ButtonNavigationBarViewModel(name: 'Criar', icon: Icons.add),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedTermo = null;
      _isShowingFavorites = index == 1;
      _isShowingAdd = index == 2;

    });
  }

  void _showTermoDetail(PostModel termo) {
    setState(() {
      _selectedTermo = termo;
      _isShowingFavorites = false;
      _isShowingAdd = false;
      _selectedIndex = 0;
    });
  }

    void _showFavorites() {
    setState(() {
      _isShowingFavorites = true;
      _selectedTermo = null;
      _isShowingAdd = false;
      _selectedIndex = 1;
    });
  }

  Widget _buildBody() {
    if(_selectedTermo != null) {
      return DetalWidget(termo: _selectedTermo!);
    }
    if (_isShowingFavorites || _selectedIndex == 1) {
      return FavorictWidget(onTermoSelected: _showTermoDetail,);
    }
    if (_isShowingAdd || _selectedIndex == 2){
      return const AddWidget();
    }
   
    return HomeWidget(
      onTermoSelected: _showTermoDetail,
    );
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onShowFavorites: _showFavorites,
        isFaroritePage: _isShowingFavorites,
      ),
      body: _buildBody(),
      bottomNavigationBar: ButtonNavigationBar(
        items: _bottomNavItems,
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
