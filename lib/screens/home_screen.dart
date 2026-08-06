import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tune_tokens.dart';
import '../widgets/cover.dart';
import '../widgets/responsive.dart';
import '../widgets/track_tile.dart';

/// Home dashboard: what the library holds, how much it has been listened to
/// over the last 30 days, and what came back most often.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LibraryStats? _stats;
  ListeningDashboard? _listening;
  String? _error;
  String? _loadedHost; // reload when the server changes

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final app = context.watch<AppState>();
    if (app.host.isNotEmpty && app.host != _loadedHost) {
      _loadedHost = app.host;
      _load();
    }
  }

  Future<void> _load() async {
    final c = context.read<AppState>().client;
    if (c == null) return;
    try {
      // Independent calls — a missing dashboard shouldn't hide the counters.
      final results = await Future.wait([
        c.libraryStats().then<Object?>((v) => v).catchError((_) => null),
        c.listeningDashboard().then<Object?>((v) => v).catchError((_) => null),
      ]);
      if (!mounted) return;
      setState(() {
        _stats = results[0] as LibraryStats?;
        _listening = results[1] as ListeningDashboard?;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL.of(context);
    final app = context.watch<AppState>();
    if (app.host.isEmpty) {
      return Scaffold(body: NotConnected(label: t.notConnected));
    }

    final stats = _stats;
    final listening = _listening;

    return Scaffold(
      appBar: AppBar(title: Text(t.navHome)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: MaxWidth(
          maxWidth: 900,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(t.errorWith(_error!)),
                ),
              if (stats != null)
                _StatsRow(stats: stats)
              else
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (listening != null && listening.trend.isNotEmpty) ...[
                _SectionHeader(
                  title: t.listeningActivity,
                  trailing: t.playsCount(listening.plays),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: _TrendChart(days: listening.trend),
                ),
              ],
              if (listening != null && listening.topTracks.isNotEmpty) ...[
                _SectionHeader(title: t.mostPlayed),
                for (final tr in listening.topTracks) _PlayedTrackRow(track: tr),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// The library in numbers.
class _StatsRow extends StatelessWidget {
  final LibraryStats stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final t = AppL.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _StatCard(value: stats.albums, label: t.tabAlbums),
          _StatCard(value: stats.tracks, label: t.tabTracks),
          _StatCard(value: stats.artists, label: t.tabArtists),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final int value;
  final String label;
  const _StatCard({required this.value, required this.label});

  /// 53248 → "53 248" (thin spaces keep long counts readable on a phone).
  String get _formatted {
    final s = '$value';
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(' ');
      b.write(s[i]);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minWidth: 104),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(TuneTokens.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_formatted,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5)),
          const SizedBox(height: 2),
          Text(label.toUpperCase(),
              style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.8,
                  color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: TuneTokens.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          if (trailing != null) ...[
            const Spacer(),
            Text(trailing!,
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}

/// Daily listening activity. One bar per day of the period, including silent
/// days, so the timeline stays honest.
class _TrendChart extends StatelessWidget {
  final List<ListeningDay> days;
  const _TrendChart({required this.days});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final peak = days.fold<int>(0, (m, d) => d.plays > m ? d.plays : m);
    return SizedBox(
      height: 84,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final d in days)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Tooltip(
                  message: '${d.day.day}/${d.day.month} · ${d.plays}',
                  child: FractionallySizedBox(
                    // A day with plays never renders as nothing.
                    heightFactor:
                        peak == 0 ? 0.02 : (d.plays / peak).clamp(d.plays > 0 ? 0.06 : 0.02, 1.0),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: d.plays > 0
                            ? TuneTokens.accent
                            : cs.surfaceContainerHighest,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(2)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A most-played row: cover, title, artist, and how many times it came back.
class _PlayedTrackRow extends StatelessWidget {
  final PlayedTrack track;
  const _PlayedTrackRow({required this.track});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Cover(path: track.coverPath, size: 44, radius: 7),
      title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: track.artistName == null
          ? null
          : Text(track.artistName!,
              maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        AppL.of(context).playsCount(track.plays),
        style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
      ),
    );
  }
}
