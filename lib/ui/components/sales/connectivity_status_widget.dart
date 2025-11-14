import 'package:builders_konnect/core/core.dart';

class ConnectivityStatusWidget extends ConsumerWidget {
  const ConnectivityStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityVm = ref.watch(connectivityViewModelProvider);
    final textTheme = Theme.of(context).textTheme;

    // Don't show anything if we're online and no unsynced orders
    if (connectivityVm.isOnline && !connectivityVm.hasUnsyncedOrders) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
        vertical: Sizer.height(8),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(12),
        vertical: Sizer.height(8),
      ),
      decoration: BoxDecoration(
        color: connectivityVm.isOnline
            ? AppColors.dayBreakBlue
            : AppColors.yellowE6,
        borderRadius: BorderRadius.circular(Sizer.radius(6)),
        border: Border.all(
          color: connectivityVm.connectivityStatusColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (connectivityVm.isSyncing)
            SizedBox(
              width: Sizer.width(16),
              height: Sizer.width(16),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    connectivityVm.connectivityStatusColor),
              ),
            )
          else
            Icon(
              connectivityVm.isOnline ? Icons.wifi : Icons.wifi_off,
              size: Sizer.width(16),
              color: connectivityVm.connectivityStatusColor,
            ),
          XBox(8),
          Expanded(
            child: Text(
              connectivityVm.isOnline
                  ? 'Online - ${connectivityVm.connectivityStatusText}'
                  : 'Working offline - Orders will sync when connection is restored',
              style: textTheme.bodySmall?.copyWith(
                color: connectivityVm.connectivityStatusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityVm = ref.watch(connectivityViewModelProvider);
    final textTheme = Theme.of(context).textTheme;

    // Don't show if no unsynced orders
    if (!connectivityVm.hasUnsyncedOrders) {
      return const SizedBox.shrink();
    }

    final syncStats = connectivityVm.syncStats;
    final pendingCount = syncStats?.pendingCount ?? 0;
    final failedCount = syncStats?.failedCount ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
        vertical: Sizer.height(4),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(12),
        vertical: Sizer.height(8),
      ),
      decoration: BoxDecoration(
        color: failedCount > 0 ? AppColors.red1 : AppColors.dayBreakBlue,
        borderRadius: BorderRadius.circular(Sizer.radius(6)),
        border: Border.all(
          color: failedCount > 0 ? AppColors.red2D : AppColors.primaryBlue,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (connectivityVm.isSyncing)
            SizedBox(
              width: Sizer.width(16),
              height: Sizer.width(16),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  failedCount > 0 ? AppColors.red2D : AppColors.primaryBlue,
                ),
              ),
            )
          else
            Icon(
              failedCount > 0 ? Icons.sync_problem : Icons.sync,
              size: Sizer.width(16),
              color: failedCount > 0 ? AppColors.red2D : AppColors.primaryBlue,
            ),
          XBox(8),
          Expanded(
            child: Text(
              connectivityVm.isSyncing
                  ? 'Syncing orders...'
                  : failedCount > 0
                      ? '$failedCount orders failed to sync, $pendingCount pending'
                      : '$pendingCount orders pending sync',
              style: textTheme.bodySmall?.copyWith(
                color:
                    failedCount > 0 ? AppColors.red2D : AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (connectivityVm.canManualSync)
            InkWell(
              onTap: () => connectivityVm.triggerManualSync(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizer.width(8),
                  vertical: Sizer.height(4),
                ),
                decoration: BoxDecoration(
                  color:
                      failedCount > 0 ? AppColors.red2D : AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                ),
                child: Text(
                  'Sync Now',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OrderSyncStatusBadge extends StatelessWidget {
  final SyncStatus status;
  final int? retryCount;

  const OrderSyncStatusBadge({
    super.key,
    required this.status,
    this.retryCount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case SyncStatus.pending:
        backgroundColor = AppColors.yellowE6;
        textColor = AppColors.yellow6;
        text = 'Pending Sync';
        icon = Icons.schedule;
        break;
      case SyncStatus.syncing:
        backgroundColor = AppColors.dayBreakBlue;
        textColor = AppColors.primaryBlue;
        text = 'Syncing...';
        icon = Icons.sync;
        break;
      case SyncStatus.synced:
        backgroundColor = AppColors.greenED;
        textColor = AppColors.green1A;
        text = 'Synced';
        icon = Icons.check_circle;
        break;
      case SyncStatus.failed:
        backgroundColor = AppColors.red1;
        textColor = AppColors.red2D;
        text = retryCount != null && retryCount! > 0
            ? 'Failed ($retryCount retries)'
            : 'Sync Failed';
        icon = Icons.error;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(8),
        vertical: Sizer.height(4),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Sizer.radius(12)),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: Sizer.width(12),
            color: textColor,
          ),
          XBox(4),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
