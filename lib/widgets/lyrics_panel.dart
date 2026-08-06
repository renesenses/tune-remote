import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tune_tokens.dart';

/// Lyrics for the playing track.
///
/// Timed lyrics follow playback: the current line is highlighted and scrolled
/// to the middle. Without timings (or without the server's premium
/// entitlement) the plain text is shown instead, which is still useful.
class LyricsPanel extends StatefulWidget {
  /// Local library track id — streaming tracks have none, so lyrics are
  /// unavailable for them.
  final int? trackId;
  final int positionMs;

  const LyricsPanel({super.key, required this.trackId, required this.positionMs});

  @override
  State<LyricsPanel> createState() => _LyricsPanelState();
}

class _LyricsPanelState extends State<LyricsPanel> {
  final _scroll = ScrollController();
  Lyrics? _lyrics;
  bool _loading = false;
  int? _loadedFor;
  int _activeLine = -1;

  static const _lineHeight = 34.0;

  @override
  void didUpdateWidget(covariant LyricsPanel old) {
    super.didUpdateWidget(old);
    if (widget.trackId != _loadedFor) _load();
    _syncActiveLine();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = widget.trackId;
    _loadedFor = id;
    if (id == null) {
      setState(() {
        _lyrics = null;
        _activeLine = -1;
      });
      return;
    }
    final c = context.read<AppState>().client;
    if (c == null) return;
    setState(() => _loading = true);
    final res = await c.lyrics(id);
    if (!mounted || _loadedFor != id) return; // track changed while loading
    setState(() {
      _lyrics = res;
      _loading = false;
      _activeLine = -1;
    });
  }

  /// Follows playback, scrolling only when the active line actually changes.
  void _syncActiveLine() {
    final ly = _lyrics;
    if (ly == null || ly.lines.isEmpty) return;
    final i = ly.activeIndex(widget.positionMs);
    if (i == _activeLine) return;
    setState(() => _activeLine = i);
    if (i < 0 || !_scroll.hasClients) return;
    final target = (i * _lineHeight) - (_scroll.position.viewportDimension / 2) + _lineHeight;
    _scroll.animateTo(
      target.clamp(0.0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL.of(context);
    final cs = Theme.of(context).colorScheme;
    final ly = _lyrics;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (ly == null || ly.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(t.noLyrics,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant)),
        ),
      );
    }

    // Timed lyrics — follow along.
    if (ly.lines.isNotEmpty) {
      return ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: ly.lines.length,
        itemExtent: _lineHeight,
        itemBuilder: (_, i) {
          final active = i == _activeLine;
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: active ? 17 : 15,
                height: 1.2,
                fontWeight: active ? FontWeight.w800 : FontWeight.w400,
                color: active ? cs.onSurface : cs.onSurfaceVariant.withValues(alpha: 0.55),
              ),
              child: Text(ly.lines[i].text, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          );
        },
      );
    }

    // Plain text — no timings available (or synced lyrics need premium).
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        if (ly.premiumRequired)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(Icons.lock_outline, size: 14, color: TuneTokens.accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(t.syncedLyricsPremium,
                      style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                ),
              ],
            ),
          ),
        Text(ly.plainText,
            style: TextStyle(fontSize: 15, height: 1.5, color: cs.onSurfaceVariant)),
      ],
    );
  }
}
