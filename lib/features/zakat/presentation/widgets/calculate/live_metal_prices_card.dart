import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

class LiveMetalPricesCard extends StatelessWidget {
  const LiveMetalPricesCard({
    super.key,
    required this.prices,
    required this.goldKarat,
    required this.onRefresh,
  });

  final MetalPrices prices;
  final int goldKarat;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wifi, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'تم جلب أسعار الذهب والفضة تلقائيًا عبر الإنترنت',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                tooltip: 'إعادة التحديث',
                onPressed: onRefresh,
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'سعر جرام الذهب (عيار $goldKarat):',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                '${NumberUtils.formatAmount(prices.priceForKarat(goldKarat))} جنيه',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'سعر جرام الفضة النقية:',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '${NumberUtils.formatAmount(prices.silverPricePerGram)} جنيه',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
