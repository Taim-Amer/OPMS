import 'package:flutter/material.dart';

class SearchField<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemToString;
  final void Function(List<T>) onSearchResult;

  const SearchField({
    super.key,
    required this.items,
    required this.itemToString,
    required this.onSearchResult,
  });

  @override
  _SearchFieldState<T> createState() => _SearchFieldState<T>();
}

class _SearchFieldState<T> extends State<SearchField<T>> {
  final TextEditingController _controller = TextEditingController();

  void _filterList(String query) {
    final result = widget.items.where((item) {
      final text = widget.itemToString(item).toLowerCase();
      return text.contains(query.toLowerCase());
    }).toList();

    widget.onSearchResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: "Search anything ....",
      ),
      onChanged: _filterList,
    );
  }
}
