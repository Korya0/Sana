import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_search_body.dart';

class HadithSearchView extends StatefulWidget {
  const HadithSearchView({super.key});

  @override
  State<HadithSearchView> createState() => _HadithSearchViewState();
}

class _HadithSearchViewState extends State<HadithSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = true;
  bool _autoFocus = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
    context.read<HadithCubit>().onSearchQueryChanged(query);
  }

  void _toggleSearch() {
    final wasVisible = _isSearchVisible;
    setState(() {
      _isSearchVisible = !wasVisible;
      _autoFocus = true;
    });

    if (wasVisible) {
      _searchController.clear();
      context.read<HadithCubit>().onSearchQueryChanged('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HadithSearchBody(
        scrollController: _scrollController,
        isSearchVisible: _isSearchVisible,
        autoFocus: _autoFocus,
        searchController: _searchController,
        onToggleSearch: _toggleSearch,
        onSearchChanged: _onSearchChanged,
        onSuggestionTap: (text) {
          setState(() {
            _isSearchVisible = true;
            _autoFocus = false;
            _searchController.text = text;
          });
          unawaited(context.read<HadithCubit>().searchHadith(text));
        },
        onRetry: () => unawaited(context.read<HadithCubit>().searchHadith(_searchController.text)),
      ),
    );
  }
}
