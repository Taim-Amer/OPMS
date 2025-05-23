import 'package:flutter/material.dart';

class TPaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int perPage;
  final int totalItemCount;
  final List<int> perPageOptions;

  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback? onFirst;
  final VoidCallback? onLast;
  final ValueChanged<int> onPerPageChanged;
  final bool showFirstLastIcons;

  const TPaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.totalItemCount,
    required this.perPageOptions,
    required this.onNext,
    required this.onPrevious,
    this.onFirst,
    this.onLast,
    required this.onPerPageChanged,
    this.showFirstLastIcons = false,
  });

  @override
  Widget build(BuildContext context) {
    final int from = totalItemCount == 0 ? 0 : ((currentPage - 1) * perPage + 1).clamp(1, totalItemCount);
    final int to = totalItemCount == 0 ? 0 : (from + perPage - 1).clamp(from, totalItemCount);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text("Rows per page: "),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: perPage,
          items: perPageOptions
              .map((value) => DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          ))
              .toList(),
          onChanged: (value) {
            if (value != null) onPerPageChanged(value);
          },
        ),
        const SizedBox(width: 16),
        Text("$from–$to of $totalItemCount"),
        if (showFirstLastIcons)
          IconButton(
            onPressed: currentPage > 1 ? onFirst : null,
            icon: const Icon(Icons.first_page),
          ),
        IconButton(
          onPressed: currentPage > 1 ? onPrevious : null,
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton(
          onPressed: currentPage < totalPages ? onNext : null,
          icon: const Icon(Icons.chevron_right),
        ),
        if (showFirstLastIcons)
          IconButton(
            onPressed: currentPage < totalPages ? onLast : null,
            icon: const Icon(Icons.last_page),
          ),
      ],
    );
  }
}
