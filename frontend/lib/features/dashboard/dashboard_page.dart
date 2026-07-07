import 'package:flutter/material.dart';
import '../workouts/workouts_page.dart';
import '../community/community_page.dart';
import '../ai_recommendations/ai_page.dart';
import '../nutrition/nutrition_page.dart';
import '../chat/chat_page.dart';
import '../virtual_classes/virtual_classes_page.dart';
import '../premium/premium_page.dart';
import '../../core/utils/responsive_helper.dart';
import '../../providers_or_bloc/app_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<DashboardTab> tabs = [
    DashboardTab(
      label: 'Home',
      icon: Icons.home,
      page: const HomePage(),
    ),
    DashboardTab(
      label: 'Workouts',
      icon: Icons.fitness_center,
      page: const WorkoutsPage(),
    ),
    DashboardTab(
      label: 'Community',
      icon: Icons.people,
      page: const CommunityPage(),
    ),
    DashboardTab(
      label: 'AI Coach',
      icon: Icons.smart_toy,
      page: const AIRecommendationsPage(),
    ),
    DashboardTab(
      label: 'Nutrition',
      icon: Icons.restaurant,
      page: const NutritionPage(),
    ),
    DashboardTab(
      label: 'Classes',
      icon: Icons.video_camera_back,
      page: const VirtualClassesPage(),
    ),
    DashboardTab(
      label: 'Chat',
      icon: Icons.message,
      page: const ChatPage(),
    ),
    DashboardTab(
      label: 'Premium',
      icon: Icons.star,
      page: const PremiumPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GymFlow Pro'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings')),
              );
            },
          ),
          if (isDesktop) const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Sidebar for desktop
          if (isDesktop)
            SizedBox(
              width: 280,
              child: _SidebarNavigation(
                tabs: tabs,
                selectedIndex: _selectedIndex,
                onTabChanged: (index) {
                  setState(() => _selectedIndex = index);
                },
              ),
            ),
          // Main content
          Expanded(
            child: tabs[_selectedIndex].page,
          ),
        ],
      ),
      // Bottom navigation for mobile
      bottomNavigationBar: isMobile
          ? _BottomNavigation(
              tabs: tabs,
              selectedIndex: _selectedIndex,
              onTabChanged: (index) {
                setState(() => _selectedIndex = index);
              },
            )
          : null,
      // Navigation drawer for tablet
      drawer: !isDesktop && !isMobile
          ? _DrawerNavigation(
              tabs: tabs,
              selectedIndex: _selectedIndex,
              onTabChanged: (index) {
                Navigator.pop(context);
                setState(() => _selectedIndex = index);
              },
            )
          : null,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    final appState = AppScope.watch(context);

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome back! 👋',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to crush your fitness goals?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Quick Stats
            _QuickStats(),
            const SizedBox(height: 32),
            // Today's Workout
            _TodayWorkout(),
            const SizedBox(height: 32),
            // Quick Actions
            _QuickActions(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gridCount = ResponsiveHelper.isMobile(context) ? 2 : 4;

    return GridView.count(
      crossAxisCount: gridCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _StatBox(
          title: 'Streak',
          value: '12 Days',
          icon: '🔥',
          color: Colors.red,
        ),
        _StatBox(
          title: 'Workouts',
          value: '24 This Month',
          icon: '💪',
          color: Colors.blue,
        ),
        _StatBox(
          title: 'Calories',
          value: '2,450 kcal',
          icon: '🔥',
          color: Colors.orange,
        ),
        _StatBox(
          title: 'Level',
          value: 'Elite',
          icon: '⭐',
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final Color color;

  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayWorkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Recommended Workout',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '💪',
                      style: const TextStyle(fontSize: 48),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'AI Recommended',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Upper Body Strength Building',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      avatar: const Text('⏱️'),
                      label: const Text('45 min'),
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: const Text('🔥'),
                      label: const Text('320 cal'),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Workout started! 🎯'),
                        ),
                      );
                    },
                    child: const Text('Start Workout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ActionButton(
              icon: Icons.message,
              label: 'Message Trainer',
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.event,
              label: 'Book Class',
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.restaurant,
              label: 'Log Meal',
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.analytics,
              label: 'View Stats',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _SidebarNavigation extends StatelessWidget {
  final List<DashboardTab> tabs;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const _SidebarNavigation({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: ListView(
        children: List.generate(
          tabs.length,
          (index) => _NavItem(
            icon: tabs[index].icon,
            label: tabs[index].label,
            isSelected: selectedIndex == index,
            onTap: () => onTabChanged(index),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final List<DashboardTab> tabs;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const _BottomNavigation({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTabChanged,
      type: BottomNavigationBarType.shifting,
      items: tabs.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}

class _DrawerNavigation extends StatelessWidget {
  final List<DashboardTab> tabs;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const _DrawerNavigation({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🏋️',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'GymFlow Pro',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          ...List.generate(
            tabs.length,
            (index) => ListTile(
              leading: Icon(tabs[index].icon),
              title: Text(tabs[index].label),
              selected: selectedIndex == index,
              onTap: () => onTabChanged(index),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: isSelected,
      selectedTileColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      onTap: onTap,
    );
  }
}

class DashboardTab {
  final String label;
  final IconData icon;
  final Widget page;

  DashboardTab({
    required this.label,
    required this.icon,
    required this.page,
  });
}
