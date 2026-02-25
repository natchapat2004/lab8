import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper function สำหรับ reorder list
/// ใช้ได้กับ List ทุกประเภท
void reorderList<T>(List<T> list, int oldIndex, int newIndex) {
  // เมื่อย้าย item ลง (newIndex > oldIndex)
  // Flutter คำนวณ newIndex รวมตำแหน่งเดิมของ item
  // ต้องลบ 1 เพื่อให้ได้ตำแหน่งจริง
  if (newIndex > oldIndex) {
    newIndex -= 1;
  }

  // ลบ item จากตำแหน่งเดิม
  final item = list.removeAt(oldIndex);

  // ใส่ item ที่ตำแหน่งใหม่
  list.insert(newIndex, item);
}

// Model สำหรับเพลง
class Song {
  final String id;
  final String title;
  final String artist;
  final Color imageColor;
  final IconData icon;
  final String imageUrl;
  int priority; // สำหรับเก็บลำดับจริง

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageColor,
    this.icon = Icons.music_note,
    required this.imageUrl,
    this.priority = 0,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'priority': priority,
    'imageUrl': imageUrl,
  };

  // From JSON
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      imageColor: _getColorById(json['id']),
      icon: _getIconById(json['id']),
      imageUrl: json['imageUrl'],
      priority: json['priority'] ?? 0,
    );
  }

  static Color _getColorById(String id) {
    final colors = {
      '1': const Color(0xFF9B59B6),
      '2': const Color(0xFF3498DB),
      '3': const Color(0xFFE74C3C),
      '4': const Color(0xFF2ECC71),
      '5': const Color(0xFFF39C12),
      '6': const Color(0xFFE67E22),
    };
    return colors[id] ?? const Color(0xFF95A5A6);
  }

  static IconData _getIconById(String id) {
    final icons = {
      '1': Icons.music_note,
      '2': Icons.nightlight_round,
      '3': Icons.favorite,
      '4': Icons.people,
      '5': Icons.star,
      '6': Icons.movie,
    };
    return icons[id] ?? Icons.album;
  }
}

class ReorderableBuilderExample extends StatefulWidget {
  const ReorderableBuilderExample({super.key});

  @override
  State<ReorderableBuilderExample> createState() =>
      _ReorderableBuilderExampleState();
}

class _ReorderableBuilderExampleState extends State<ReorderableBuilderExample>
    with SingleTickerProviderStateMixin {
  late SharedPreferences _prefs;
  late AnimationController _fabAnimation;

  final List<Song> _allSongs = [
    Song(
      id: '1',
      title: 'Dynamite',
      artist: 'BTS',
      imageColor: const Color(0xFF9B59B6),
      icon: Icons.person,
      imageUrl:
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop',
      priority: 1,
    ),
    Song(
      id: '2',
      title: 'Butter',
      artist: 'BTS',
      imageColor: const Color(0xFF3498DB),
      icon: Icons.nightlight_round,
      imageUrl:
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=200&h=200&fit=crop',
      priority: 2,
    ),
    Song(
      id: '3',
      title: 'How You Like That',
      artist: 'BLACKPINK',
      imageColor: const Color(0xFFE74C3C),
      icon: Icons.favorite,
      imageUrl:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&h=200&fit=crop',
      priority: 3,
    ),
    Song(
      id: '4',
      title: 'God\'s Menu',
      artist: 'Stray Kids',
      imageColor: const Color(0xFF2ECC71),
      icon: Icons.people,
      imageUrl:
          'https://images.unsplash.com/photo-1508700115892-11e4d6f7d518?w=200&h=200&fit=crop',
      priority: 4,
    ),
    Song(
      id: '5',
      title: 'Liars',
      artist: 'IVE',
      imageColor: const Color(0xFFF39C12),
      icon: Icons.star,
      imageUrl:
          'https://images.unsplash.com/photo-1487180144351-b8472da7d491?w=200&h=200&fit=crop',
      priority: 5,
    ),
    Song(
      id: '6',
      title: 'TT',
      artist: 'TWICE',
      imageColor: const Color(0xFFE67E22),
      icon: Icons.movie,
      imageUrl:
          'https://images.unsplash.com/photo-1510915511874-f42d53556ae0?w=200&h=200&fit=crop',
      priority: 6,
    ),
  ];

  late List<Song> _albumSongs;

  @override
  void initState() {
    super.initState();
    _albumSongs = List.from(_allSongs);
    _fabAnimation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation.forward();
    _loadSongs();
  }

  @override
  void dispose() {
    _fabAnimation.dispose();
    super.dispose();
  }

  Future<void> _loadSongs() async {
    _prefs = await SharedPreferences.getInstance();
    final songsJson = _prefs.getStringList('songs');

    if (songsJson != null && songsJson.isNotEmpty) {
      setState(() {
        _albumSongs = songsJson
            .map((json) => Song.fromJson(jsonDecode(json)))
            .toList();
        _albumSongs.sort((a, b) => a.priority.compareTo(b.priority));
      });
    }
  }

  Future<void> _saveSongs() async {
    final songsJson = _albumSongs
        .map((song) => jsonEncode(song.toJson()))
        .toList();
    await _prefs.setStringList('songs', songsJson);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      reorderList(_albumSongs, oldIndex, newIndex);
      for (int i = 0; i < _albumSongs.length; i++) {
        _albumSongs[i].priority = i + 1;
      }
    });
    _saveSongs();
  }

  void _onDismissed(Song song, DismissDirection direction) {
    final removedSong = song;
    final removedIndex = _albumSongs.indexOf(song);

    setState(() {
      _albumSongs.remove(song);
      // อัปเดต priority
      for (int i = 0; i < _albumSongs.length; i++) {
        _albumSongs[i].priority = i + 1;
      }
    });

    _saveSongs(); // บันทึกลง SharedPreferences

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          direction == DismissDirection.endToStart
              ? '${removedSong.title} ถูกลบแล้ว'
              : '${removedSong.title} ถูกเพิ่มเข้า Favorites',
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'ยกเลิก',
          onPressed: () {
            setState(() {
              _albumSongs.insert(removedIndex, removedSong);
              // อัปเดต priority
              for (int i = 0; i < _albumSongs.length; i++) {
                _albumSongs[i].priority = i + 1;
              }
            });
            _saveSongs();
          },
        ),
      ),
    );
  }

  Future<bool?> _confirmDismiss(DismissDirection direction) async {
    if (direction == DismissDirection.endToStart) {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ลบเพลง?'),
            content: const Text('คุณแน่ใจว่าต้องการลบเพลงนี้?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('ลบ'),
              ),
            ],
          );
        },
      );
    }
    return true;
  }

  void _showAddSongDialog() {
    final titleController = TextEditingController();
    final artistController = TextEditingController();
    final urlController = TextEditingController(
      text:
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เพิ่มเพลงใหม่'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อเพลง',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: artistController,
                decoration: const InputDecoration(
                  labelText: 'ศิลปิน',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL รูปภาพ',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  artistController.text.isNotEmpty) {
                final newId = (int.parse(_albumSongs.last.id) + 1).toString();
                final newSong = Song(
                  id: newId,
                  title: titleController.text,
                  artist: artistController.text,
                  imageColor: Color(0xFF000000 + (newId.hashCode % 0xFFFFFF)),
                  imageUrl: urlController.text,
                  priority: _albumSongs.length + 1,
                );

                setState(() {
                  _albumSongs.add(newSong);
                });
                _saveSongs();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${newSong.title} เพิ่มสำเร็จ'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('เพิ่ม'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎵 My Playlist'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.pink.shade300.withOpacity(0.5),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Searching header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Searching',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          // Song list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.pink.shade300],
                ),
              ),
              child: ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _albumSongs.length,
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final song = _albumSongs[index];
                  return _buildSongItem(song, index);
                },
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      final double elevation = lerpDouble(
                        0,
                        8,
                        animation.value,
                      )!;
                      return Material(
                        elevation: elevation,
                        borderRadius: BorderRadius.circular(12),
                        shadowColor: Colors.black26,
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _showAddSongDialog,
          backgroundColor: Colors.pink.shade300,
          elevation: 6,
          tooltip: 'เพิ่มเพลง',
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildSongItem(Song song, int index) {
    return Dismissible(
      key: ValueKey(song.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: _confirmDismiss,
      onDismissed: (direction) => _onDismissed(song, direction),
      // Background เมื่อ swipe ขวาไปซ้าย (ลบ)
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade600],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      // Background เมื่อ swipe ซ้ายไปขวา (Favorite)
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.favorite, color: Colors.white, size: 30),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Hero(
              tag: 'song_${song.id}',
              child: Image.network(
                song.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: song.imageColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(song.icon, color: Colors.white, size: 30),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: song.imageColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          title: Text(
            song.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.artist,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: ReorderableDragStartListener(
            index: index,
            child: Icon(Icons.drag_handle, color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
