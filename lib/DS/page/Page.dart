import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Button/ButtonAdd/Floating_Add_Button.dart';
import 'package:dicionario/DS/Components/Button/ButtonNavigation/Button_navigation_bar.dart';
import 'package:dicionario/DS/Components/Button/ButtonNavigation/Button_navigation_bar_view_model.dart';
import 'package:dicionario/DS/Components/Button/ReturnButton/Return_Button.dart';
import 'package:dicionario/DS/Components/appBar/Custom_appBar.dart';
import 'package:dicionario/DS/Components/appBarSearch/App_Bar_Search.dart';
import 'package:dicionario/DS/Components/theme/themeToggleButton/Theme_Toggle_Button.dart';
import 'package:dicionario/Service/favorite_service.dart';
import 'package:dicionario/Service/topico_sevice.dart';
import 'package:dicionario/shared/color.dart';
import 'package:dicionario/view/Add_widget.dart';
import 'package:dicionario/view/Detail_widget.dart';
import 'package:dicionario/view/Favorite_widget.dart';
import 'package:dicionario/view/Home_widget.dart';
import 'package:dicionario/view/Termo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AppView { home, termo, favorites, add, detail }

class PageHome extends StatefulWidget {
  const PageHome({super.key});
  @override
  State<StatefulWidget> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  AppView _currentView = AppView.home;
  AppView _previousView = AppView.home;
  PostModel? _selectedTermo;
  String _searchTerm = "";
  bool _isSearchExpanded = false;

  final List<ButtonNavigationBarViewModel> _bottomNavItems = [
    ButtonNavigationBarViewModel(name: "Home", icon: Icons.home),
    ButtonNavigationBarViewModel(name: 'Termos', icon: Icons.book),
    ButtonNavigationBarViewModel(name: 'Favoritos', icon: Icons.favorite),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _currentView = AppView.home;
      } else if (index == 1) {
        _currentView = AppView.termo;
      } else {
        _currentView = AppView.favorites;
      }
      _previousView = _currentView;
      _selectedTermo = null;
      _searchTerm = "";
      if (_currentView == AppView.home) {
        context.read<FavoriteService>().applyFilters(nome: "");
      }
      _isSearchExpanded = false;
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
      _previousView = _currentView;
      _currentView = AppView.favorites;
      _selectedTermo = null;
    });
  }

  void _goBack() {
    setState(() {
      _currentView = _previousView;
      _selectedTermo = null;
      _searchTerm = "";
      _isSearchExpanded = false;
    });
  }

  Future<List<PostModel>> _getSuggestions(String query) async {
    if (query.isEmpty) return [];
    if (_currentView == AppView.termo) {
      final response = await TopicoSevice.getTopicos(nome: query);
      return response.data ?? [];
    } else if (_currentView == AppView.favorites) {
      final favoriteService = context.read<FavoriteService>();
      final normaLizedQuery = query.toLowerCase().trim();
      return favoriteService.favorites
          .where(
            (post) => (post.nome ?? "").toLowerCase().contains(normaLizedQuery),
          )
          .toList();
    }
    return [];
  }

  void _onSwarchSubmitted(String query) {
    setState(() {
      _searchTerm = query;
    });
    if (_currentView == AppView.favorites) {
      context.read<FavoriteService>().applyFilters(nome: query);
    }
  }

  void _onSearchCleared() {
    setState(() {
      _searchTerm = "";
    });
    if (_currentView == AppView.favorites) {
      context.read<FavoriteService>().applyFilters(nome: "");
    }
  }

  Widget _buildBody() {
    switch (_currentView) {
      case AppView.home:
        return HomeWidget(onTermoSelected: _showTermoDetail);
      case AppView.detail:
        return DetalWidget(termo: _selectedTermo!);
      case AppView.add:
        return const AddWidget();
      case AppView.favorites:
        return FavorictWidget(onTermoSelected: _showTermoDetail);
      case AppView.termo:
        return TermoWidget(
          onTermoSelected: _showTermoDetail,
          searchTerm: _searchTerm,
        );
    }
  }

  Widget? _buildFloatingButton() {
    if (_currentView == AppView.detail || _currentView == AppView.add) {
      return ReturnButton(
        onReturn: _goBack,
        backgroundColor: appBarColor,
        foregroundColor: WhiteIconColor,
      );
    }
    return FloatingAddButton(
      onPressed: () {
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

    if (_currentView == AppView.home) {
      _selectedIndex = 0;
    } else if (_currentView == AppView.termo) {
      _selectedIndex = 1;
    } else if (_currentView == AppView.favorites) {
      _selectedIndex = 2;
    } else {
      if (_previousView == AppView.termo) {
        _selectedIndex = 1;
      } else if (_previousView == AppView.favorites) {
        _selectedIndex = 2;
      } else {
        _selectedIndex = 0;
      }
    }
    bool showSearch =
        _currentView == AppView.termo || _currentView == AppView.favorites;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (_currentView == AppView.detail || _currentView == AppView.add) {
            _goBack();
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: CustomAppBar(
            onShowFavorites: _showFavorites,
            isFaroritePage: _isFaroritePage,
            titleWidget:const ThemeToggleButton(),
            isSearchExpanded: _isSearchExpanded,
            searchWidget: showSearch
                ? AppBarSearch(
                    initialValue: _searchTerm,
                    onSuggestionSearch: _getSuggestions,
                    onSuggestionSelected: _showTermoDetail,
                    onSearchSubmitted: _onSwarchSubmitted,
                    onSearchCleared: _onSearchCleared,
                    onExpansionChanged: (isExpanded){
                      setState(() {
                        _isSearchExpanded = isExpanded;
                      });
                    },
                  )
                : null,
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
      ),
    );
  }
}
