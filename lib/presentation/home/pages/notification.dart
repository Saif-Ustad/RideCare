import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ridecare/presentation/home/bloc/user/user_state.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/notification_entity.dart';
import '../bloc/notification/notification_bloc.dart';
import '../bloc/notification/notification_event.dart';
import '../bloc/notification/notification_state.dart';
import '../bloc/user/user_bloc.dart';

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
                          !_isToday(n.timestamp!) &&
                          !_isYesterday(n.timestamp!),
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
                  _buildSectionHeader(
                    "Today",
                    "Mark all as read",
                    () {
                      _markAllAsRead(context, today);
                    },
                    showAction: today.any((n) => !n.isRead!),
                  ),
                  ...today.map(
                    (n) => _buildNotificationTile(context, n, () {
                      _showNotificationDetail(context, n);
                    }),
                  ),
                  const SizedBox(height: 24),
                ],

                if (yesterday.isNotEmpty) ...[
                  _buildSectionHeader(
                    "Yesterday",
                    "Mark all as read",
                    () {
                      _markAllAsRead(context, yesterday);
                    },
                    showAction: yesterday.any((n) => !n.isRead!),
                  ),
                  ...yesterday.map(
                    (n) => _buildNotificationTile(context, n, () {
                      _showNotificationDetail(context, n);
                    }),
                  ),
                  const SizedBox(height: 24),
                ],

                if (older.isNotEmpty) ...[
                  _buildSectionHeader(
                    "Earlier",
                    "Mark all as read",
                    () {
                      _markAllAsRead(context, older);
                    },
                    showAction: older.any((n) => !n.isRead!),
                  ),
                  ...older.map(
                    (n) => _buildNotificationTile(context, n, () {
                      _showNotificationDetail(context, n);
                    }),
                  ),
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

  Widget _buildSectionHeader(
    String title,
    String actionText,
    VoidCallback onTap, {
    bool showAction = true,
  }) {
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
          if (showAction)
            GestureDetector(
              onTap: onTap,
              child: Text(
                actionText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    NotificationEntity notification,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: Key(notification.id!),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Delete Notification"),
                  content: const Text(
                    "Are you sure you want to delete this notification?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
          );
        },
        onDismissed: (_) {
          final userState = context.read<UserBloc>().state;
          if (userState is UserLoaded) {
            final userId = userState.user.uid;
            context.read<NotificationBloc>().add(
              DeleteNotificationEvent(
                userId: userId,
                notificationId: notification.id!,
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color:
                !notification.isRead!
                    ? const Color(0xFFF0F8FF)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          notification.isRead!
                              ? AppColors.lightGray
                              : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _mapTypeToIcon(notification.type),
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  if (!notification.isRead!)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            !notification.isRead!
                                ? FontWeight.bold
                                : FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGrey,
                        fontWeight:
                            notification.isRead!
                                ? FontWeight.normal
                                : FontWeight.w500,
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
        ),
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

  void _showNotificationDetail(
    BuildContext context,
    NotificationEntity notification,
  ) {
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded && !notification.isRead!) {
      context.read<NotificationBloc>().add(
        ReadNotificationEvent(
          userId: userState.user.uid,
          notificationId: notification.id!,
        ),
      );
    }
    final formattedDate = DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(notification.timestamp!);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Title & Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Timestamp Row
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.darkGrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// Close Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => context.pop(context),
                  icon: const Icon(Icons.done, color: Colors.white),
                  label: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _markAllAsRead(BuildContext context, List<NotificationEntity> list) {
    final navigator = Navigator.of(context);
    final userBloc = context.read<UserBloc>();
    final notificationBloc = context.read<NotificationBloc>();

    showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Mark all as read?'),
            content: const Text(
              'Are you sure you want to mark all unread notifications as read?',
            ),
            actions: [
              TextButton(
                onPressed: () => navigator.pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => navigator.pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
    ).then((shouldMark) {
      if (shouldMark != true) return;

      final userState = userBloc.state;
      if (userState is UserLoaded) {
        final userId = userState.user.uid;
        for (var notification in list.where((n) => !n.isRead!)) {
          notificationBloc.add(
            ReadNotificationEvent(
              userId: userId,
              notificationId: notification.id!,
            ),
          );
        }
      }
    });
  }
}
