import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/notification_entity.dart';
import '../bloc/notification/notification_bloc.dart';
import '../bloc/notification/notification_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final now = DateTime.now();

            final today =
                state.notifications
                    .where(
                      (n) =>
                          n.timestamp!.year == now.year &&
                          n.timestamp!.month == now.month &&
                          n.timestamp!.day == now.day,
                    )
                    .toList();

            final yesterday =
                state.notifications.where((n) {
                  final yesterdayDate = now.subtract(const Duration(days: 1));
                  return n.timestamp!.year == yesterdayDate.year &&
                      n.timestamp!.month == yesterdayDate.month &&
                      n.timestamp!.day == yesterdayDate.day;
                }).toList();

            final older =
                state.notifications
                    .where(
                      (n) =>
                          !_isToday(n.timestamp!) && !_isYesterday(n.timestamp!),
                    )
                    .toList();

            if (today.isEmpty && yesterday.isEmpty && older.isEmpty) {
              return const Center(
                child: Text(
                  "No notifications found",
                  style: TextStyle(fontSize: 16, color: AppColors.darkGrey),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 16),
                if (today.isNotEmpty) ...[
                  _buildSectionHeader("Today", "Mark all as read"),
                  ...today.map((n) => _buildNotificationTile(n)),
                  const SizedBox(height: 24),
                ],

                if (yesterday.isNotEmpty) ...[
                  _buildSectionHeader("Yesterday", "Mark all as read"),
                  ...yesterday.map((n) => _buildNotificationTile(n)),
                  const SizedBox(height: 24),
                ],

                if (older.isNotEmpty) ...[
                  _buildSectionHeader("Earlier", "Mark all as read"),
                  ...older.map((n) => _buildNotificationTile(n)),
                ],

                if (today.isEmpty && yesterday.isEmpty && older.isEmpty)
                  const Center(child: Text("No notifications found")),

                const SizedBox(height: 16),
              ],
            );
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Notifications",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoaded) {
              final unreadCount =
                  state.notifications.where((n) => n.isRead == false).length;

              if (unreadCount == 0) return const SizedBox();

              return Container(
                margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$unreadCount NEW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey,
            ),
          ),
          Text(
            actionText,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(NotificationEntity notification) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.lightGray,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _mapTypeToIcon(notification.type),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.darkGrey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatTime(notification.timestamp!),
            style: const TextStyle(fontSize: 12, color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }

  IconData _mapTypeToIcon(String type) {
    switch (type.toLowerCase()) {
      case "booking":
        return Icons.event;
      case "discount":
        return Icons.percent;
      case "review":
        return Icons.star_border;
      case "payment":
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  bool _isToday(DateTime timestamp) {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }

  bool _isYesterday(DateTime timestamp) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return timestamp.year == yesterday.year &&
        timestamp.month == yesterday.month &&
        timestamp.day == yesterday.day;
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
