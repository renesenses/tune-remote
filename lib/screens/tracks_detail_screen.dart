import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../widgets/cover.dart';
import '../widgets/favorite_button.dart';
import '../widgets/mini_player.dart';
import '../widgets/quality_badge.dart';
import '../widgets/quality_filter_bar.dart';
import '../widgets/responsive.dart';
import '../widgets/track_tile.dart';

/// Generic "list of tracks" screen used for albums and playlists.
class TracksDetailScreen extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? coverPath;
  final Future<List<Track>> Function() loadTracks;

  /// Optional favorite target for the whole collection (album / playlist).
  final String? favoriteSource;
  final String? favoriteType; // 'albums' | 'playlists'
  final String? favoriteId;

  /// Editable-playlist hooks. When set, a delete action and per-track remove
  /// (via the track ⋮ menu) are shown.
  final Future<void> Function()? onDelete;
  final Future<void> Function(int index, Track track)? onRemoveTrack;

  const TracksDetailScreen({
    super.key,
    required this.title,
    required this.loadTracks,
    this.subtitle,
    this.coverPath,
    this.favoriteSource,
    this.favoriteType,
    this.favoriteId,
    this.onDelete,
    this.onRemoveTrack,
  });

  @override
  State<TracksDetailScreen> createState() => _TracksDetailScreenState();
}

class _TracksDetailScreenState extends State<TracksDetailScreen> {
  List<Track>? _tracks;
  String? _error;
  Set<QualityTier> _tierFilter = {}; // empty = show every quality

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final t = await widget.loadTracks();
      if (mounted) setState(() => _tracks = t);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  /// Plays [list] from [startIndex]. [list] is what the user currently sees —
  /// with a quality filter on, that is the filtered selection, not the whole
  /// album ("play what you see").
  Future<void> _playList(List<Track> list, int startIndex) async {
    final app = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);
    final t = AppL.of(context);
    try {
      // No success toast — the mini player is the confirmation.
      await app.playTracks(list, startIndex: startIndex);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(t.errorWith('$e'))));
    }
  }

  Future<void> _removeTrack(int index, Track track) async {
    final messenger = ScaffoldMessenger.of(context);
    final t = AppL.of(context);
    setState(() => _tracks = List.of(_tracks!)..remove(track));
    try {
      await widget.onRemoveTrack!(index, track);
      messenger.showSnackBar(SnackBar(content: Text(t.trackRemoved)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(t.errorWith('$e'))));
      await _load(); // restore authoritative list on failure
    }
  }

  Future<void> _confirmDelete() async {
    final t = AppL.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.deletePlaylist),
        content: Text(t.deletePlaylistConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false), child: Text(t.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(t.delete)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.onDelete!();
      navigator.pop(true);
      messenger.showSnackBar(SnackBar(content: Text(t.playlistDeleted)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(t.errorWith('$e'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracks = _tracks;
    final t = AppL.of(context);
    // Positions (in the full list) of the tracks passing the quality filter.
    // Keeping the original indices matters: `onRemoveTrack` sends the index to
    // the server as the playlist position, so a filtered index would delete the
    // wrong track.
    final shownIdx = tracks == null
        ? const <int>[]
        : [
            for (var i = 0; i < tracks.length; i++)
              if (_tierFilter.isEmpty ||
                  _tierFilter.contains(qualityTierOf(tracks[i].quality)))
                i,
          ];
    final shown = [for (final i in shownIdx) tracks![i]];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis),
        actions: [
          if (widget.favoriteId != null && widget.favoriteType != null)
            FavoriteButton(
              source: widget.favoriteSource ?? '',
              type: widget.favoriteType!,
              id: widget.favoriteId!,
            ),
          if (widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: t.deletePlaylist,
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: _error != null
          ? Center(child: Text(t.errorWith(_error!)))
          : tracks == null
              ? const Center(child: CircularProgressIndicator())
              : MaxWidth(
                  maxWidth: 860,
                  child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Cover(path: widget.coverPath, size: 96, radius: 10),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.title,
                                    style: Theme.of(context).textTheme.titleLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                if (widget.subtitle != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(widget.subtitle!,
                                        style: const TextStyle(color: Colors.white54)),
                                  ),
                                const SizedBox(height: 10),
                                FilledButton.icon(
                                  onPressed:
                                      shown.isEmpty ? null : () => _playList(shown, 0),
                                  icon: const Icon(Icons.play_arrow),
                                  label: Text(t.playAll),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    QualityFilterBar(
                      tracks: tracks,
                      selected: _tierFilter,
                      onChanged: (s) => setState(() => _tierFilter = s),
                    ),
                    const Divider(height: 1),
                    if (tracks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(child: Text(t.noTracks)),
                      )
                    else
                      for (var vi = 0; vi < shownIdx.length; vi++)
                        TrackTile(
                          track: shown[vi],
                          // Start from the visible position within the visible
                          // list; removal keeps the original index.
                          onTap: () => _playList(shown, vi),
                          onRemove: widget.onRemoveTrack == null
                              ? null
                              : () => _removeTrack(shownIdx[vi], shown[vi]),
                        ),
                    const SizedBox(height: 24),
                  ],
                  ),
                ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}
