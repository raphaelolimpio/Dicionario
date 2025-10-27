import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Button/ButtonAdd/Floating_Add_Button.dart';
import 'package:dicionario/DS/Components/Button/ButtonNavigation/Button_navigation_bar.dart';
import 'package:dicionario/DS/Components/Button/ButtonNavigation/Button_navigation_bar_view_model.dart';
import 'package:dicionario/DS/Components/Button/ReturnButton/Return_Button.dart';
import 'package:dicionario/DS/Components/appBar/Custom_appBar.dart';
import 'package:dicionario/shared/color.dart';
import 'package:dicionario/view/Add_widget.dart';
import 'package:dicionario/view/Detail_widget.dart';
import 'package:dicionario/view/Favorite_widget.dart';
import 'package:dicionario/view/Home_widget.dart';
import 'package:flutter/material.dart';

enum AppView{ home, favorites, add, detail}

class PageHome extends StatefulWidget {
  const PageHome({super.key});
  @override
  State<StatefulWidget> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  AppView _currentView = AppView.home;
  AppView _previousView = AppView.home;
  PostModel? _selectedTermo;




  final List<ButtonNavigationBarViewModel> _bottomNavItems = [
    ButtonNavigationBarViewModel(name: 'Home', icon: Icons.home),
    ButtonNavigationBarViewModel(name: 'Favoritos', icon: Icons.favorite),
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentView = (index ==0) ? AppView.home : AppView.favorites;
      _previousView = _currentView;
      _selectedTermo = null;
    });
  }

  void _showTermoDetail(PostModel termo) {
    setState(() {
      _previousView = _currentView;
      _currentView = AppView.detail;
      _selectedTermo = termo;
    });
  }

    void _showFavorites() {
    setState(() {
      _currentView = AppView.favorites;
      _previousView = _currentView;
      _selectedTermo = null;
    });
  }

  void _goBack(){
    setState(() {
      _currentView = _previousView;
      _selectedTermo = null;
    });
  }

  Widget _buildBody() {
    switch (_currentView) {
      case AppView.detail:
        return DetalWidget(termo: _selectedTermo!);
      case AppView.add:
        return const AddWidget();
      case AppView.favorites:
        return FavorictWidget(onTermoSelected: _showTermoDetail);
      case AppView.home:
      return HomeWidget(onTermoSelected: _showTermoDetail);
    }
  }

  Widget? _buildFloatingButton(){
    if (_currentView == AppView.detail || _currentView == AppView.add) {
      return ReturnButton(
        onReturn: _goBack,
        backgroundColor: appBarColor,
        foregroundColor: WhiteIconColor,
      );
    }
    return FloatingAddButton(
        onPressed: (){
        setState(() {
          _selectedTermo = null;
          _previousView = _currentView;
          _currentView = AppView.add;

        });
      },
      icon: const Icon(Icons.add),
      backgroundColor: appBarColor,
      foregroundColor: WhiteIconColor,
      tooltip: "Criar",
    );
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex;
    bool _isFaroritePage = _currentView == AppView.favorites;

    if(_currentView == AppView.home){
      _selectedIndex = 0;
    } else if (_currentView == AppView.favorites){
      _selectedIndex = 1;
    } else {
      _selectedIndex = (_previousView == AppView.favorites) ? 1 : 0;
    }
    return WillPopScope(onWillPop: () async {
      if(_currentView == AppView.detail || _currentView == AppView.add){
        _goBack();
        return false;
      }
      return true;
    },
    child:  Scaffold(
      appBar: CustomAppBar(
        onShowFavorites: _showFavorites,
        isFaroritePage: _isFaroritePage,
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingButton(),
      floatingActionButtonLocation: FloatingAddButton.defaultLocation,
      bottomNavigationBar: ButtonNavigationBar(
        items: _bottomNavItems,
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    ),
    );
  }
}
