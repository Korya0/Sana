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

  Future<void> _onScroll() async {
    if (_isBottom) {
      await context.read<HadithCubit>().loadMoreHadiths();
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

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().length >= 2) {
        await _performSearch(query.trim());
      }
    });
  }

  Future<void> _performSearch(String query) async {
    await context.read<HadithCubit>().searchHadith(query);
  }

  void _toggleSearch() {
    final wasVisible = _isSearchVisible;
    setState(() {
      _isSearchVisible = !wasVisible;
      _autoFocus = true;
    });

    if (wasVisible) {
      _searchController.clear();
      unawaited(context.read<HadithCubit>().searchHadith(''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          HadithSearchSliverAppBar(
            isSearchVisible: _isSearchVisible,
            autoFocus: _autoFocus,
            searchController: _searchController,
            onToggleSearch: _toggleSearch,
            onSearchChanged: _onSearchChanged,
          ),
          HadithSearchResultsBuilder(
            onSuggestionTap: (text) async {
              setState(() {
                _isSearchVisible = true;
                _autoFocus = false;
                _searchController.text = text;
              });
              await _performSearch(text);
            },
            onRetry: () => _performSearch(_searchController.text),
          ),
        ],
      ),
    );
  }
}
