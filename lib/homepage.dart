import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<StockData> stockData = [
    StockData('NIFTY BANK', '52,323.30', const Color(0xFF10B981)),
    StockData('NIFTY FIN SERVICE', '25,255.75', const Color(0xFF10B981)),
    StockData('RELCHEMO', '162.73', const Color(0xFF10B981)),
  ];

  final List<OrderData> orders = [
    OrderData('08:14:31', 'AAA001', 'RELIANCE', 'Buy', 'CNC', '50/100', '250.50'),
    OrderData('08:14:31', 'AAA003', 'MRF', 'Buy', 'NRML', '10/20', '2,700.00'),
    OrderData('08:14:31', 'AAA002', 'ASIANPAINT', 'Buy', 'NRML', '10/30', '1,500.60'),
    OrderData('08:14:31', 'AAA002', 'TATAINVEST', 'Sell', 'INTRADAY', '10/10', '2,300.10'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final isMobile = screenWidth <= 768;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isDesktop ? 80 : 70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E2E), Color(0xFF2D1B69)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(CupertinoIcons.chart_bar_alt_fill, color: Colors.white),
            ),
            title: isMobile ? null : _buildStockTicker(isDesktop),
            actions: _buildAppBarActions(isMobile, isTablet),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile) _buildMobileStockTicker(),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFilterSection(isDesktop, isTablet, isMobile),
              const SizedBox(height: 24),
              _buildOrdersTable(isDesktop, isTablet, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockTicker(bool isDesktop) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: stockData.map((stock) => 
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stock.name,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  stock.value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: stock.color,
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildMobileStockTicker() {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stockData.length,
        itemBuilder: (context, index) {
          final stock = stockData[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  stock.color.withOpacity(0.2),
                  stock.color.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: stock.color.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.name,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  stock.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: stock.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildAppBarActions(bool isMobile, bool isTablet) {
    if (isMobile) {
      return [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('LK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ];
    }

    return [
      _buildNavButton('MARKETWATCH'),
      _buildNavButton('EXCHANGE FILES'),
      _buildDropdownButton('PORTFOLIO', ['Holdings', 'Positions']),
      _buildDropdownButton('FUNDS', ['Mutual Funds', 'SIP']),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('LK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    ];
  }

  Widget _buildNavButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _buildDropdownButton(String text, List<String> items) {
    return PopupMenuButton<String>(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const Icon(CupertinoIcons.chevron_down, size: 14, color: Colors.white70),
          ],
        ),
      ),
      itemBuilder: (context) => items.map((item) => 
        PopupMenuItem(value: item, child: Text(item))
      ).toList(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(CupertinoIcons.folder_open, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Text(
          'Open Orders',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.cloud_download, size: 18),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(bool isDesktop, bool isTablet, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E2E), Color(0xFF2D1B69)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildMobileFilters(),
          ] else ...[
            _buildDesktopFilters(),
          ],
          const SizedBox(height: 16),
          _buildFilterTags(),
        ],
      ),
    );
  }

  Widget _buildMobileFilters() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.person_crop_circle, size: 16, color: Colors.white70),
                    SizedBox(width: 8),
                    Text('AAA002', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text('Lalit', style: TextStyle(color: Colors.white)),
                    ),
                    Icon(CupertinoIcons.xmark, size: 14, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: const Row(
            children: [
              Icon(CupertinoIcons.search, color: Colors.white70),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search stocks, futures, options...',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopFilters() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.person_crop_circle, size: 16, color: Colors.white70),
              SizedBox(width: 8),
              Text('AAA002', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Lalit', style: TextStyle(color: Colors.white)),
              SizedBox(width: 8),
              Icon(CupertinoIcons.xmark, size: 14, color: Colors.white70),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.search, color: Colors.white70),
                SizedBox(width: 12),
                Text(
                  'Search for a stock, future, option or index',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTags() {
    return Row(
      children: [
        _buildFilterTag('RELIANCE', true),
        const SizedBox(width: 8),
        _buildFilterTag('ASIANPAINT', true),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF4757), Color(0xFFFF3838)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4757).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(CupertinoIcons.xmark_circle, size: 16),
            label: const Text('Cancel'),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTag(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: isSelected 
          ? const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)])
          : null,
        color: isSelected ? null : Colors.white12,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.white24,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 6),
            const Icon(CupertinoIcons.xmark, size: 12, color: Colors.white),
          ],
        ],
      ),
    );
  }

  Widget _buildOrdersTable(bool isDesktop, bool isTablet, bool isMobile) {
    if (isMobile) {
      return _buildMobileOrdersList();
    }
    
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E2E), Color(0xFF2D1B69)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ...orders.asMap().entries.map((entry) => 
            _buildTableRow(entry.value, entry.key)
          ).toList(),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildMobileOrdersList() {
    return Column(
      children: orders.map((order) => _buildMobileOrderCard(order)).toList(),
    );
  }

  Widget _buildMobileOrderCard(OrderData order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E2E), Color(0xFF2D1B69)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order.side == 'Buy' 
                    ? const Color(0xFF10B981).withOpacity(0.2)
                    : const Color(0xFFEF4444).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.side,
                  style: TextStyle(
                    color: order.side == 'Buy' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                order.time,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.ticker,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildInfoChip('Client', order.client),
              const SizedBox(width: 8),
              _buildInfoChip('Product', order.product),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quantity', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(order.quantity, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Price', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(
                    '₹${order.price}',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Time', flex: 2),
          _buildHeaderCell('Client', flex: 2),
          _buildHeaderCell('Ticker', flex: 3),
          _buildHeaderCell('Side', flex: 2),
          _buildHeaderCell('Product', flex: 2),
          _buildHeaderCell('Qty (Executed/Total)', flex: 3),
          _buildHeaderCell('Price', flex: 2),
          _buildHeaderCell('Actions', flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.white70,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Icon(CupertinoIcons.arrow_up_arrow_down, size: 12, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildTableRow(OrderData order, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : Colors.transparent,
        border: const Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          _buildCell(order.time, flex: 2),
          _buildCell(order.client, flex: 2),
          _buildTickerCell(order.ticker, flex: 3),
          _buildSideCell(order.side, flex: 2),
          _buildCell(order.product, flex: 2),
          _buildCell(order.quantity, flex: 3),
          _buildPriceCell(order.price, flex: 2),
          _buildActionsCell(flex: 2),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.white),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildTickerCell(String ticker, {int flex = 1}) {
    bool hasIndicator = ticker == 'RELIANCE' || ticker == 'ASIANPAINT';
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Flexible(
            child: Text(
              ticker,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (hasIndicator) ...[
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSideCell(String side, {int flex = 1}) {
    Color color = side == 'Buy' ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          side,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPriceCell(String price, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        '₹$price',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF10B981),
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildActionsCell({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white),
          iconSize: 16,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {},
              child: const Text('Previous', style: TextStyle(color: Colors.white70)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Page 1',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {},
              child: const Text('Next', style: TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }
}

class StockData {
  final String name;
  final String value;
  final Color color;

  StockData(this.name, this.value, this.color);
}

class OrderData {
  final String time;
  final String client;
  final String ticker;
  final String side;
  final String product;
  final String quantity;
  final String price;

  OrderData(
    this.time,
    this.client,
    this.ticker,
    this.side,
    this.product,
    this.quantity,
    this.price,
  );
}