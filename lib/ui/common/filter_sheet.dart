import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical_social_media/cubit/posts/posts_cubit.dart';
import 'package:practical_social_media/extensions/enum.dart';
import 'package:practical_social_media/model/user_model.dart';

class FilterBottomSheet extends StatelessWidget {
  final PostsCubit postsCubit;
  final UserModel? currentUserModel;

  const FilterBottomSheet({
    super.key,
    required this.postsCubit,
    required this.currentUserModel,
  });

  @override
  Widget build(BuildContext context) {
    final currentFilter = postsCubit.currentFilter;

    final filters = [PostFilterType.all, PostFilterType.myPosts];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filter Posts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ...filters.map(
              (filter) => _buildFilterTile(
                context,
                filter: filter,
                selected: currentFilter == filter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// helper to build each filter item
  Widget _buildFilterTile(
    BuildContext context, {
    required PostFilterType filter,
    required bool selected,
  }) {
    return ListTile(
      title: Text(
        filter.title,
        style: TextStyle(
          color: selected ? Colors.blue : Colors.black87,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing:
          selected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
      onTap: () {
        postsCubit.applyFilter(filter);
        Get.back();
      },
    );
  }
}
