import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/query_card_widget.dart';
import './widgets/search_bar_widget.dart';

class QueryHistory extends StatefulWidget {
  const QueryHistory({Key? key}) : super(key: key);

  @override
  State<QueryHistory> createState() => _QueryHistoryState();
}

class _QueryHistoryState extends State<QueryHistory>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<int> _selectedItems = [];

  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {
    'queryType': 'All',
    'dateRange': 'All Time',
    'cropType': 'All Crops',
    'severity': 'All Levels',
    'bookmarkedOnly': false,
  };

  bool _isMultiSelectMode = false;
  bool _isLoading = false;

  // Mock data for query history
  final List<Map<String, dynamic>> _allQueries = [
    {
      "id": 1,
      "type": "text",
      "query":
          "My rice crop leaves are turning yellow. What could be the reason?",
      "response":
          "Yellow leaves in rice can indicate nitrogen deficiency, overwatering, or pest issues. Check soil moisture and consider applying nitrogen fertilizer. Monitor for brown planthopper or stem borer damage.",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "location": "Warangal, Telangana",
      "isBookmarked": true,
      "cropType": "Rice",
      "severity": "Medium",
    },
    {
      "id": 2,
      "type": "voice",
      "query": "Cotton crop lo white flies ekkuva unnai. Em cheyali?",
      "response":
          "White flies ni control cheyadaniki neem oil spray cheyandi. Roju morning lo spray cheyandi. Yellow sticky traps kuda vadandi. Imidacloprid insecticide kuda effective untundi.",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "location": "Karimnagar, Telangana",
      "isBookmarked": false,
      "cropType": "Cotton",
      "severity": "High",
    },
    {
      "id": 3,
      "type": "image",
      "query": "Leaf disease identification - Tomato plant",
      "response":
          "Based on the image analysis, your tomato plant shows signs of early blight (Alternaria solani). Apply copper-based fungicide and ensure proper spacing for air circulation. Remove affected leaves immediately.",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "location": "Hyderabad, Telangana",
      "isBookmarked": true,
      "cropType": "Tomato",
      "severity": "High",
    },
    {
      "id": 4,
      "type": "text",
      "query": "Best time for sowing maize in Telangana?",
      "response":
          "In Telangana, maize can be sown during Kharif (June-July) and Rabi (November-December) seasons. For Kharif, sow after sufficient monsoon rains. For Rabi, ensure irrigation availability.",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "location": "Nizamabad, Telangana",
      "isBookmarked": false,
      "cropType": "Maize",
      "severity": "Low",
    },
    {
      "id": 5,
      "type": "voice",
      "query": "Groundnut crop ki fertilizer schedule enti?",
      "response":
          "Groundnut ki basal ga DAP 100kg/acre, Urea 50kg/acre apply cheyandi. 30 days taruvata urea 25kg/acre top dressing cheyandi. Gypsum 200kg/acre flowering time lo apply cheyandi.",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "location": "Anantapur, Andhra Pradesh",
      "isBookmarked": true,
      "cropType": "Groundnut",
      "severity": "Low",
    },
    {
      "id": 6,
      "type": "image",
      "query": "Sugarcane pest identification",
      "response":
          "The image shows red rot disease in sugarcane. This is a serious fungal disease. Remove affected canes immediately and burn them. Apply Carbendazim fungicide to healthy plants as preventive measure.",
      "timestamp": DateTime.now().subtract(Duration(days: 4)),
      "location": "West Godavari, Andhra Pradesh",
      "isBookmarked": false,
      "cropType": "Sugarcane",
      "severity": "Critical",
    },
    {
      "id": 7,
      "type": "text",
      "query": "Organic farming methods for vegetable cultivation",
      "response":
          "Use compost and vermicompost for soil nutrition. Practice crop rotation with legumes. Use neem-based pesticides and pheromone traps. Encourage beneficial insects through companion planting.",
      "timestamp": DateTime.now().subtract(Duration(days: 5)),
      "location": "Chittoor, Andhra Pradesh",
      "isBookmarked": true,
      "cropType": "Vegetables",
      "severity": "Low",
    },
    {
      "id": 8,
      "type": "voice",
      "query": "Drip irrigation system cost and benefits enti?",
      "response":
          "Drip irrigation ki acre ki 40,000-60,000 rupees cost untundi. Government subsidy 90% varaku untundi. Water 40-50% save avutundi. Yield 20-30% perugutundi. Labor cost kuda taggutundi.",
      "timestamp": DateTime.now().subtract(Duration(days: 6)),
      "location": "Kurnool, Andhra Pradesh",
      "isBookmarked": false,
      "cropType": "All Crops",
      "severity": "Low",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreQueries();
    }
  }

  void _loadMoreQueries() {
    if (!_isLoading) {
      setState(() => _isLoading = true);

      // Simulate loading more data
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    }
  }

  List<Map<String, dynamic>> get _filteredQueries {
    List<Map<String, dynamic>> filtered = _allQueries;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((query) {
        final queryText = (query['query'] as String).toLowerCase();
        final responseText = (query['response'] as String).toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        return queryText.contains(searchLower) ||
            responseText.contains(searchLower);
      }).toList();
    }

    // Apply type filter
    if (_activeFilters['queryType'] != 'All') {
      final typeFilter = _activeFilters['queryType'].toString().toLowerCase();
      filtered =
          filtered.where((query) => query['type'] == typeFilter).toList();
    }

    // Apply date range filter
    if (_activeFilters['dateRange'] != 'All Time') {
      final now = DateTime.now();
      DateTime cutoffDate;

      switch (_activeFilters['dateRange']) {
        case 'Today':
          cutoffDate = DateTime(now.year, now.month, now.day);
          break;
        case 'This Week':
          cutoffDate = now.subtract(Duration(days: 7));
          break;
        case 'This Month':
          cutoffDate = DateTime(now.year, now.month, 1);
          break;
        default:
          cutoffDate = DateTime(1970);
      }

      filtered = filtered.where((query) {
        final timestamp = query['timestamp'] as DateTime;
        return timestamp.isAfter(cutoffDate);
      }).toList();
    }

    // Apply crop type filter
    if (_activeFilters['cropType'] != 'All Crops') {
      filtered = filtered
          .where((query) => query['cropType'] == _activeFilters['cropType'])
          .toList();
    }

    // Apply severity filter
    if (_activeFilters['severity'] != 'All Levels') {
      filtered = filtered
          .where((query) => query['severity'] == _activeFilters['severity'])
          .toList();
    }

    // Apply bookmarked filter
    if (_activeFilters['bookmarkedOnly'] == true) {
      filtered =
          filtered.where((query) => query['isBookmarked'] == true).toList();
    }

    return filtered;
  }

  bool get _hasActiveFilters {
    return _activeFilters['queryType'] != 'All' ||
        _activeFilters['dateRange'] != 'All Time' ||
        _activeFilters['cropType'] != 'All Crops' ||
        _activeFilters['severity'] != 'All Levels' ||
        _activeFilters['bookmarkedOnly'] == true;
  }

  @override
  Widget build(BuildContext context) {
    final filteredQueries = _filteredQueries;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar:
          _isMultiSelectMode ? _buildMultiSelectAppBar() : _buildNormalAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            if (!_isMultiSelectMode) ...[
              SearchBarWidget(
                onSearchChanged: (query) =>
                    setState(() => _searchQuery = query),
                onFilterTap: _showFilterBottomSheet,
                hasActiveFilters: _hasActiveFilters,
              ),
            ],
            Expanded(
              child: filteredQueries.isEmpty
                  ? _searchQuery.isNotEmpty || _hasActiveFilters
                      ? _buildNoResultsWidget()
                      : EmptyStateWidget(
                          onStartQuerying: () =>
                              Navigator.pushNamed(context, '/home-dashboard'),
                        )
                  : RefreshIndicator(
                      onRefresh: _refreshQueries,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            filteredQueries.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == filteredQueries.length) {
                            return _buildLoadingIndicator();
                          }

                          final query = filteredQueries[index];
                          final isSelected =
                              _selectedItems.contains(query['id']);

                          return QueryCardWidget(
                            queryData: query,
                            isSelected: isSelected,
                            onTap: () => _handleCardTap(query),
                            onLongPress: () => _handleCardLongPress(query),
                            onReAsk: () => _handleReAsk(query),
                            onDelete: () => _handleDelete(query),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 4,
        onTap: (index) {},
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/home-dashboard'),
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 6.w,
              ),
            ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      title: Text(
        'Query History',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showSortOptions,
          icon: CustomIconWidget(
            iconName: 'sort',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildMultiSelectAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _exitMultiSelectMode,
        icon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      title: Text(
        '${_selectedItems.length} selected',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _selectedItems.isNotEmpty ? _shareSelected : null,
          icon: CustomIconWidget(
            iconName: 'share',
            color: _selectedItems.isNotEmpty
                ? AppTheme.lightTheme.colorScheme.onSurface
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
            size: 6.w,
          ),
        ),
        IconButton(
          onPressed: _selectedItems.isNotEmpty ? _deleteSelected : null,
          icon: CustomIconWidget(
            iconName: 'delete',
            color: _selectedItems.isNotEmpty
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Results Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            TextButton(
              onPressed: _clearSearchAndFilters,
              child: Text('Clear Search & Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }

  void _handleCardTap(Map<String, dynamic> query) {
    if (_isMultiSelectMode) {
      _toggleSelection(query['id']);
    } else {
      _showQueryDetails(query);
    }
  }

  void _handleCardLongPress(Map<String, dynamic> query) {
    if (!_isMultiSelectMode) {
      setState(() {
        _isMultiSelectMode = true;
        _selectedItems.add(query['id']);
      });
    }
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
        if (_selectedItems.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedItems.add(id);
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedItems.clear();
    });
  }

  void _handleReAsk(Map<String, dynamic> query) {
    final queryType = query['type'] as String;
    switch (queryType) {
      case 'text':
        Navigator.pushNamed(context, '/text-input-query');
        break;
      case 'voice':
        Navigator.pushNamed(context, '/voice-input-query');
        break;
      case 'image':
        Navigator.pushNamed(context, '/image-upload-analysis');
        break;
    }
  }

  void _handleDelete(Map<String, dynamic> query) {
    setState(() {
      _allQueries.removeWhere((q) => q['id'] == query['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Query deleted successfully'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allQueries.add(query);
              _allQueries.sort((a, b) => (b['timestamp'] as DateTime)
                  .compareTo(a['timestamp'] as DateTime));
            });
          },
        ),
      ),
    );
  }

  void _shareSelected() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${_selectedItems.length} queries')),
    );
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Selected Queries'),
        content: Text(
            'Are you sure you want to delete ${_selectedItems.length} selected queries?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allQueries.removeWhere(
                    (query) => _selectedItems.contains(query['id']));
                _selectedItems.clear();
                _isMultiSelectMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected queries deleted')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showQueryDetails(Map<String, dynamic> query) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: query['type'] == 'voice'
                                ? 'mic'
                                : query['type'] == 'image'
                                    ? 'camera_alt'
                                    : 'keyboard',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Query Details',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                query['location'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 6.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question:',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              query['query'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyLarge,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'AI Response:',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              query['response'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() => _activeFilters = filters);
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort By',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              title: Text('Most Recent'),
              onTap: () {
                Navigator.pop(context);
                _sortByDate();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'star',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 5.w,
              ),
              title: Text('Bookmarked First'),
              onTap: () {
                Navigator.pop(context);
                _sortByBookmarks();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'priority_high',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 5.w,
              ),
              title: Text('By Severity'),
              onTap: () {
                Navigator.pop(context);
                _sortBySeverity();
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _sortByDate() {
    setState(() {
      _allQueries.sort((a, b) =>
          (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
    });
  }

  void _sortByBookmarks() {
    setState(() {
      _allQueries.sort((a, b) {
        final aBookmarked = a['isBookmarked'] as bool;
        final bBookmarked = b['isBookmarked'] as bool;
        if (aBookmarked && !bBookmarked) return -1;
        if (!aBookmarked && bBookmarked) return 1;
        return (b['timestamp'] as DateTime)
            .compareTo(a['timestamp'] as DateTime);
      });
    });
  }

  void _sortBySeverity() {
    final severityOrder = {'Critical': 0, 'High': 1, 'Medium': 2, 'Low': 3};
    setState(() {
      _allQueries.sort((a, b) {
        final aSeverity = severityOrder[a['severity']] ?? 4;
        final bSeverity = severityOrder[b['severity']] ?? 4;
        return aSeverity.compareTo(bSeverity);
      });
    });
  }

  void _clearSearchAndFilters() {
    setState(() {
      _searchQuery = '';
      _activeFilters = {
        'queryType': 'All',
        'dateRange': 'All Time',
        'cropType': 'All Crops',
        'severity': 'All Levels',
        'bookmarkedOnly': false,
      };
    });
  }

  Future<void> _refreshQueries() async {
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Simulate refreshing data
      });
    }
  }
}
