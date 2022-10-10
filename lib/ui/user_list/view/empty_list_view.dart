import 'package:fb_users/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// [EmptyListView]
/// this view show when the shopping list is empty

class EmptyListView extends StatelessWidget {
  const EmptyListView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxHeight: size.height * 0.8,
        maxWidth: size.height * 0.8,
        minWidth: size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.addNewItemInstruction,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall!.copyWith(
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}