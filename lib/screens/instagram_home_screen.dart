import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../providers/theme_provider.dart';
import 'instagram_login_screen.dart';
import 'instagram_search_screen.dart';

class InstagramHomeScreen extends StatefulWidget {
  const InstagramHomeScreen({Key? key}) : super(key: key);

  @override
  State<InstagramHomeScreen> createState() => _InstagramHomeScreenState();
}

class _InstagramHomeScreenState extends State<InstagramHomeScreen> {
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();
  List<Post> _posts = [];
  String _currentUsername = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final credentials = await _authService.loadCredentials();
    final posts = await _storageService.loadPosts();

    setState(() {
      _currentUsername = credentials['username'] ?? 'user';
      _posts = posts;
    });
  }

  Future<void> _toggleLike(Post post) async {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
    await _storageService.updatePost(post);
  }

  Future<void> _logout() async {
    await _authService.clearCredentials();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const InstagramLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: _currentIndex == 0 ? _buildHomeAppBar(themeProvider) : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeBody(themeProvider),
          const InstagramSearchScreen(),
          _buildAddPostScreen(themeProvider),
          _buildActivityScreen(themeProvider),
          _buildProfileScreen(themeProvider),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(themeProvider),
    );
  }

  PreferredSizeWidget _buildHomeAppBar(ThemeProvider theme) {
    return AppBar(
      backgroundColor: theme.backgroundColor,
      elevation: 0,
      title: Text(
        'Instagram',
        style: GoogleFonts.grandHotel(fontSize: 32, color: theme.textColor),
      ),
      actions: [
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.favorite_border, color: theme.textColor, size: 28),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.messenger_outline, color: theme.textColor, size: 28),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHomeBody(ThemeProvider theme) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 88,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              children: [
                _buildStory(
                  'Your story',
                  'https://cdn-icons-png.flaticon.com/512/6858/6858569.png',
                  isYourStory: true,
                  theme: theme,
                ),
                _buildStory(
                  'danielavil...',
                  'https://i.pravatar.cc/150?img=11',
                  hasGradient: true,
                  theme: theme,
                ),
                _buildStory(
                  'gabyhawryluk',
                  'https://i.pravatar.cc/150?img=12',
                  hasGradient: true,
                  theme: theme,
                ),
                _buildStory(
                  'melinavill...',
                  'https://i.pravatar.cc/150?img=13',
                  hasGradient: true,
                  theme: theme,
                ),
                _buildStory(
                  'john_doe',
                  'https://i.pravatar.cc/150?img=14',
                  hasGradient: true,
                  theme: theme,
                ),
                _buildStory(
                  'sarah_sm...',
                  'https://i.pravatar.cc/150?img=15',
                  hasGradient: true,
                  theme: theme,
                ),
              ],
            ),
          ),
          Divider(color: theme.dividerColor, height: 0),
          Expanded(
            child: _posts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) =>
                        _buildPost(_posts[index], theme),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPostScreen(ThemeProvider theme) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title: Text('New Post', style: TextStyle(color: theme.textColor)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: theme.textColor, width: 2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: theme.textColor,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create New Post',
              style: TextStyle(
                color: theme.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Share photos with your followers',
              style: TextStyle(color: theme.secondaryTextColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityScreen(ThemeProvider theme) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title: Text('Activity', style: TextStyle(color: theme.textColor)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Today',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildActivityItem('john_doe', 'liked your photo.', '2h', theme),
          _buildActivityItem(
            'sarah_smith',
            'started following you.',
            '4h',
            theme,
          ),
          _buildActivityItem(
            'mike_brown',
            'commented: "Nice pic! 🔥"',
            '5h',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String username,
    String action,
    String time,
    ThemeProvider theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=$username',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: theme.textColor, fontSize: 14),
                children: [
                  TextSpan(
                    text: username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' $action '),
                  TextSpan(
                    text: time,
                    style: TextStyle(color: theme.secondaryTextColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen(ThemeProvider theme) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title: Text(
          _currentUsername,
          style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: theme.textColor),
            onPressed: () {
              theme.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.menu, color: theme.textColor),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/6858/6858569.png',
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Posts', '12', theme),
                        _buildStatColumn('Followers', '1.2K', theme),
                        _buildStatColumn('Following', '348', theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentUsername,
                    style: TextStyle(
                      color: theme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📍 Location\n🔗 Bio link here\n✨ Living my best life',
                    style: TextStyle(
                      color: theme.secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(color: theme.textColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Share Profile',
                        style: TextStyle(color: theme.textColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: 9,
              itemBuilder: (context, index) => Image.network(
                'https://picsum.photos/200?random=$index',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count, ThemeProvider theme) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: theme.secondaryTextColor, fontSize: 14),
        ),
      ],
    );
  }

  void _showProfileMenu(ThemeProvider theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.secondaryTextColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: theme.textColor),
            title: Text('Settings', style: TextStyle(color: theme.textColor)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(
              theme.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.textColor,
            ),
            title: Text(
              theme.isDarkMode ? 'Light Mode' : 'Dark Mode',
              style: TextStyle(color: theme.textColor),
            ),
            trailing: Switch(
              value: theme.isDarkMode,
              onChanged: (value) => theme.toggleTheme(),
              activeColor: const Color(0xFF0095F6),
            ),
            onTap: () => theme.toggleTheme(),
          ),
          ListTile(
            leading: Icon(Icons.bookmark_border, color: theme.textColor),
            title: Text('Saved', style: TextStyle(color: theme.textColor)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStory(
    String name,
    String imageUrl, {
    bool isYourStory = false,
    bool hasGradient = false,
    required ThemeProvider theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasGradient
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFF58529),
                        Color(0xFFDD2A7B),
                        Color(0xFF8134AF),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    )
                  : null,
              border: !hasGradient
                  ? Border.all(color: theme.borderColor, width: 2)
                  : null,
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.backgroundColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 65,
            child: Text(
              name,
              style: TextStyle(color: theme.textColor, fontSize: 10),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(Post post, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(post.userImage),
              ),
              const SizedBox(width: 10),
              Text(
                post.username,
                style: TextStyle(
                  color: theme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.more_vert, color: theme.textColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Image.network(
          post.postImage,
          width: double.infinity,
          height: 400,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 400,
            color: theme.cardColor,
            child: Center(child: Icon(Icons.error, color: theme.textColor)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : theme.textColor,
                  size: 28,
                ),
                onPressed: () => _toggleLike(post),
              ),
              IconButton(
                icon: Icon(
                  Icons.mode_comment_outlined,
                  color: theme.textColor,
                  size: 28,
                ),
                onPressed: () => _showCommentsBottomSheet(post, theme),
              ),
              IconButton(
                icon: Icon(
                  Icons.send_outlined,
                  color: theme.textColor,
                  size: 26,
                ),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.bookmark_border,
                  color: theme.textColor,
                  size: 28,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${post.likes} likes',
            style: TextStyle(
              color: theme.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: theme.textColor, fontSize: 14),
              children: [
                TextSpan(
                  text: post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' '),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ),
        if (post.comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: GestureDetector(
              onTap: () => _showCommentsBottomSheet(post, theme),
              child: Text(
                'View all ${post.comments.length} comments',
                style: TextStyle(color: theme.secondaryTextColor, fontSize: 14),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            _getTimeAgo(post.timestamp),
            style: TextStyle(color: theme.secondaryTextColor, fontSize: 12),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBottomNav(ThemeProvider theme) {
    return BottomNavigationBar(
      backgroundColor: theme.backgroundColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.textColor,
      unselectedItemColor: theme.secondaryTextColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(_currentIndex == 1 ? Icons.search : Icons.search_outlined),
          label: 'Search',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == 3 ? Icons.favorite : Icons.favorite_border,
          ),
          label: 'Likes',
        ),
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _currentIndex == 4
                    ? theme.textColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/6858/6858569.png',
              ),
            ),
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }

  void _showCommentsBottomSheet(Post post, ThemeProvider theme) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.secondaryTextColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments',
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: theme.textColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(color: theme.dividerColor, height: 1),
                Expanded(
                  child: post.comments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  color: theme.textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Start the conversation.',
                                style: TextStyle(
                                  color: theme.secondaryTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: post.comments.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (context, index) {
                            final comment = post.comments[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/150?img=${index + 30}',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: theme.textColor,
                                              fontSize: 14,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: comment.username,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const TextSpan(text: '  '),
                                              TextSpan(text: comment.text),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _getTimeAgo(comment.timestamp),
                                          style: TextStyle(
                                            color: theme.secondaryTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: theme.textColor,
                                      size: 14,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  color: theme.cardColor,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('❤️', style: TextStyle(fontSize: 28)),
                      Text('🙌', style: TextStyle(fontSize: 28)),
                      Text('🔥', style: TextStyle(fontSize: 28)),
                      Text('👏', style: TextStyle(fontSize: 28)),
                      Text('😢', style: TextStyle(fontSize: 28)),
                      Text('😍', style: TextStyle(fontSize: 28)),
                      Text('😮', style: TextStyle(fontSize: 28)),
                      Text('😂', style: TextStyle(fontSize: 28)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 12,
                    right: 12,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border(
                      top: BorderSide(color: theme.dividerColor, width: 0.5),
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/6858/6858569.png',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            style: TextStyle(color: theme.textColor),
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: TextStyle(
                                color: theme.secondaryTextColor,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            maxLines: null,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (commentController.text.trim().isNotEmpty) {
                              final comment = Comment(
                                username: _currentUsername,
                                text: commentController.text.trim(),
                                timestamp: DateTime.now(),
                                id: '',
                                userImage: '',
                              );
                              post.comments.add(comment);
                              await _storageService.updatePost(post);
                              commentController.clear();
                              setModalState(() {});
                              setState(() {});
                            }
                          },
                          child: const Text(
                            'Post',
                            style: TextStyle(
                              color: Color(0xFF0095F6),
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes} minutes ago';
    return 'Just now';
  }
}
