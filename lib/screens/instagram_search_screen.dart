import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class InstagramSearchScreen extends StatefulWidget {
  const InstagramSearchScreen({Key? key}) : super(key: key);

  @override
  State<InstagramSearchScreen> createState() => _InstagramSearchScreenState();
}

class _InstagramSearchScreenState extends State<InstagramSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserSearchResult> _allUsers = [];
  List<UserSearchResult> _filteredUsers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _allUsers = [
      UserSearchResult(
        username: 'danielavillalba',
        fullName: 'Daniela Villalba',
        avatarUrl: 'https://i.pravatar.cc/150?img=11',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'demisjewels',
        fullName: 'Demis Jewelry and Watchmaking',
        avatarUrl: 'https://i.pravatar.cc/150?img=25',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'gabrielcali',
        fullName: 'Gabriel Cali',
        avatarUrl: 'https://i.pravatar.cc/150?img=26',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'gabyhawryluk',
        fullName: 'Gabriela Hawryluk',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        isVerified: false,
        isFollowing: true,
      ),
      UserSearchResult(
        username: 'gladyshawryluk',
        fullName: 'Gladys Hawryluk',
        avatarUrl: 'https://i.pravatar.cc/150?img=27',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'intelinnovation',
        fullName: 'Intel Innovation',
        avatarUrl: 'https://i.pravatar.cc/150?img=28',
        isVerified: true,
      ),
      UserSearchResult(
        username: 'javianabeautyspa',
        fullName: 'Javiana Beauty Spa',
        avatarUrl: 'https://i.pravatar.cc/150?img=29',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'melinavillalba',
        fullName: 'Melina Villalba',
        avatarUrl: 'https://i.pravatar.cc/150?img=13',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'nvidia',
        fullName: 'Nvidia GeForce RTX',
        avatarUrl: 'https://i.pravatar.cc/150?img=30',
        isVerified: true,
      ),
      UserSearchResult(
        username: 'pablohawryluk',
        fullName: 'Oscar Pablo Hawryluk',
        avatarUrl: 'https://i.pravatar.cc/150?img=31',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'sarah_smith',
        fullName: 'Sarah Smith',
        avatarUrl: 'https://i.pravatar.cc/150?img=15',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'alex_johnson',
        fullName: 'Alex Johnson',
        avatarUrl: 'https://i.pravatar.cc/150?img=16',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'emma_wilson',
        fullName: 'Emma Wilson',
        avatarUrl: 'https://i.pravatar.cc/150?img=17',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'mike_brown',
        fullName: 'Mike Brown',
        avatarUrl: 'https://i.pravatar.cc/150?img=18',
        isVerified: false,
      ),
      UserSearchResult(
        username: 'lisa_anderson',
        fullName: 'Lisa Anderson',
        avatarUrl: 'https://i.pravatar.cc/150?img=19',
        isVerified: false,
      ),
    ];

    _filteredUsers = _allUsers;
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredUsers = _allUsers
            .where(
              (user) =>
                  user.username.toLowerCase().contains(query.toLowerCase()) ||
                  user.fullName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        elevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterUsers,
            style: TextStyle(color: theme.textColor, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: theme.secondaryTextColor, fontSize: 16),
              prefixIcon: Icon(Icons.search, color: theme.secondaryTextColor, size: 22),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: theme.secondaryTextColor,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _filterUsers('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          if (_isSearching)
            TextButton(
              onPressed: () {
                _searchController.clear();
                _filterUsers('');
                FocusScope.of(context).unfocus();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.textColor, fontSize: 16),
              ),
            ),
        ],
      ),
      body: _filteredUsers.isEmpty && _isSearching
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: theme.secondaryTextColor),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: TextStyle(
                      color: theme.secondaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try searching for something else',
                    style: TextStyle(color: theme.secondaryTextColor, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _filteredUsers.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return _buildUserTile(user, theme);
              },
            ),
    );
  }

  Widget _buildUserTile(UserSearchResult user, ThemeProvider theme) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${user.username}\'s profile'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.username,
                          style: TextStyle(
                            color: theme.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF0095F6),
                          size: 14,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.fullName,
                    style: TextStyle(color: theme.secondaryTextColor, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user.isFollowing) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Following',
                      style: TextStyle(color: theme.secondaryTextColor, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: theme.secondaryTextColor, size: 20),
              onPressed: () {
                setState(() {
                  _filteredUsers.remove(user);
                  _allUsers.remove(user);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class UserSearchResult {
  final String username;
  final String fullName;
  final String avatarUrl;
  final bool isVerified;
  final bool isFollowing;

  UserSearchResult({
    required this.username,
    required this.fullName,
    required this.avatarUrl,
    this.isVerified = false,
    this.isFollowing = false,
  });
}
