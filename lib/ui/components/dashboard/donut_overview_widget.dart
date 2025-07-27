import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/material.dart';

class OverviewWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<OverviewData> data;
  final int totalValue;
  final String totalLabel;
  final String valuePrefix;

  const OverviewWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.data,
    required this.totalValue,
    required this.totalLabel,
    this.valuePrefix = '₦',
  });

  @override
  State<OverviewWidget> createState() => _OverviewWidgetState();
}

class _OverviewWidgetState extends State<OverviewWidget>
    with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late AnimationController _counterAnimationController;
  late Animation<double> _chartAnimation;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();

    // Chart animation controller
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Counter animation controller
    _counterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Chart animation
    _chartAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _chartAnimationController,
      curve: Curves.easeInOut,
    ));

    // Counter animation
    _counterAnimation = IntTween(
      begin: 0,
      end: widget.totalValue,
    ).animate(CurvedAnimation(
      parent: _counterAnimationController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _chartAnimationController.forward();
    _counterAnimationController.forward();
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    _counterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.filter_alt,
                color: Colors.blue[600],
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Donut Chart
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _chartAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(200, 200),
                        painter: DonutChartPainter(
                          products: widget.data,
                          animationValue: _chartAnimation.value,
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _counterAnimation,
                          builder: (context, child) {
                            return Text(
                              _counterAnimation.value
                                  .toString()
                                  .replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},',
                                  ),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            );
                          },
                        ),
                        Text(
                          widget.totalLabel,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Data List
          Column(
            children: widget.data.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.valuePrefix} ${item.amount.toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          )}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Example usage and demo
class ProductsOverviewDemo extends StatelessWidget {
  const ProductsOverviewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      OverviewData(
        name: 'Cement',
        amount: 4544,
        color: const Color(0xFF4F8EF7),
        percentage: 25,
      ),
      OverviewData(
        name: 'Paint',
        amount: 4544,
        color: const Color(0xFF00BCD4),
        percentage: 20,
      ),
      OverviewData(
        name: 'Tiles',
        amount: 4544,
        color: const Color(0xFF4CAF50),
        percentage: 15,
      ),
      OverviewData(
        name: 'Cement Mixer',
        amount: 4544,
        color: const Color(0xFFFFA726),
        percentage: 20,
      ),
      OverviewData(
        name: 'Paint brush',
        amount: 4544,
        color: const Color(0xFFEF5350),
        percentage: 10,
      ),
      OverviewData(
        name: 'Others',
        amount: 4544,
        color: const Color(0xFF9C27B0),
        percentage: 10,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Products Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: OverviewWidget(
          title: 'Products Overview',
          subtitle: 'View top selling products and total amount sold',
          data: products,
          totalValue: 1125,
          totalLabel: 'Products sold',
          valuePrefix: '₦',
        ),
      ),
    );
  }
}
