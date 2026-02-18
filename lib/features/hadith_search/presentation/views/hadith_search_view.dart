import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_cubit.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_results_builder.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_search_sliver_app_bar.dart';

class HadithSearchView extends StatefulWidget {
  const HadithSearchView({super.key});

  @override
  State<HadithSearchView> createState() => _HadithSearchViewState();
}

class _HadithSearchViewState extends State<HadithSearchView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearchVisible = false;
  bool _autoFocus = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HadithCubit>().loadMoreHadiths();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (query.trim().length >= 2) {
        _performSearch(query.trim());
      }
    });
  }

  void _performSearch(String query) {
    context.read<HadithCubit>().searchHadith(query);
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      _autoFocus = true; // Always autofocus when manually toggling
      if (!_isSearchVisible) {
        _searchController.clear();
        context.read<HadithCubit>().searchHadith('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            HadithSearchSliverAppBar(
              isSearchVisible: _isSearchVisible,
              autoFocus: _autoFocus,
              searchController: _searchController,
              onToggleSearch: _toggleSearch,
              onSearchChanged: _onSearchChanged,
            ),
            HadithSearchResultsBuilder(
              onSuggestionTap: (text) {
                setState(() {
                  _isSearchVisible = true;
                  _autoFocus =
                      false; // Disable keyboard when tapping suggestion
                  _searchController.text = text;
                });
                _performSearch(text);
              },
              onRetry: () => _performSearch(_searchController.text),
            ),
          ],
        ),
      ),
    );
  }
}
