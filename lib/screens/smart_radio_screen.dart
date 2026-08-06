import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/tune_tokens.dart';
import '../widgets/responsive.dart';
import '../widgets/track_tile.dart';

/// Moods the server knows about (`POST /smart-ai/mood`).
enum _Mood { happy, energetic, calm, focus, romantic, sad }

extension on _Mood {
  /// Wire value expected by the server — do not localize.
  String get id => switch (this) {
        _Mood.happy => 'happy',
        _Mood.energetic => 'energetic',
        _Mood.calm => 'calm',
        _Mood.focus => 'focus',
        _Mood.romantic => 'romantic',
        _Mood.sad => 'sad',
      };

  String label(AppL t) => switch (this) {
        _Mood.happy => t.moodHappy,
        _Mood.energetic => t.moodEnergetic,
        _Mood.calm => t.moodCalm,
        _Mood.focus => t.moodFocus,
        _Mood.romantic => t.moodRomantic,
        _Mood.sad => t.moodSad,
      };

  IconData get icon => switch (this) {
        _Mood.happy => Icons.sentiment_very_satisfied,
        _Mood.energetic => Icons.bolt,
        _Mood.calm => Icons.spa,
        _Mood.focus => Icons.center_focus_strong,
        _Mood.romantic => Icons.favorite,
        _Mood.sad => Icons.water_drop,
      };
}

/// Smart radio: one tap for a fresh selection drawn from your own library —
/// either a discovery mix built on what you actually listen to, or a mood.
class SmartRadioScreen extends StatefulWidget {
  const SmartRadioScreen({super.key});

  @override
  State<SmartRadioScreen> createState() => _SmartRadioScreenState();
}

class _SmartRadioScreenState extends State<SmartRadioScreen> {
  List<Track>? _tracks;
  _Mood? _mood; // null = discovery mix
  bool _loading = false;
  String? _error;

  Future<void> _generate({_Mood? mood}) async {
    final c = context.read<AppState>().client;
    if (c == null || _loading) return;
    setState(() {
      _loading = true;
      _mood = mood;
      _error = null;
    });
    try {
      final res =
          mood == null ? await c.discoveryMix() : await c.moodMix(mood.id);
      if (!mounted) return;
      setState(() {
        _tracks = res;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _playAll() async {
    final tracks = _tracks;
    if (tracks == null || tracks.isEmpty) return;
    final app = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);
    final t = AppL.of(context);
    try {
      await app.playTracks(tracks);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(t.errorWith('$e'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL.of(context);
    final app = context.watch<AppState>();
    if (app.host.isEmpty) {
      return Scaffold(body: NotConnected(label: t.notConnected));
    }
    final tracks = _tracks;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.smartRadio),
        actions: [
          if (tracks != null && tracks.isNotEmpty)
            IconButton(
              tooltip: t.playAll,
              icon: const Icon(Icons.play_arrow),
              onPressed: _playAll,
            ),
        ],
      ),
      body: MaxWidth(
        maxWidth: 860,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const SizedBox(height: 20),
            Center(child: _DiceButton(loading: _loading, onTap: () => _generate())),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 14, 32, 20),
              child: Text(
                t.smartRadioHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
            // Moods
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (final m in _Mood.values)
                    _MoodChip(
                      label: m.label(t),
                      icon: m.icon,
                      active: _mood == m,
                      onTap: _loading ? null : () => _generate(mood: m),
                    ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(t.errorWith(_error!), textAlign: TextAlign.center),
              ),
            if (tracks != null) ...[
              const SizedBox(height: 18),
              const Divider(height: 1),
              if (tracks.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text(t.noTracks)),
                )
              else
                for (final tr in tracks) TrackTile(track: tr),
            ],
          ],
        ),
      ),
    );
  }
}

/// The "surprise me" control. Deliberately the biggest thing on the screen.
class _DiceButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;
  const _DiceButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppL.of(context).smartRadioGenerate,
      child: InkWell(
        onTap: loading ? null : onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: TuneTokens.accent,
            boxShadow: [
              BoxShadow(
                color: TuneTokens.accent.withValues(alpha: 0.38),
                blurRadius: 34,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                        strokeWidth: 3, color: TuneTokens.onAccent),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.casino,
                          size: 42, color: TuneTokens.onAccent),
                      const SizedBox(height: 4),
                      Text(
                        AppL.of(context).smartRadioGenerate,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: TuneTokens.onAccent,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;
  const _MoodChip({
    required this.label,
    required this.icon,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TuneTokens.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? TuneTokens.accent : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(TuneTokens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 15,
                color: active ? TuneTokens.onAccent : cs.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? TuneTokens.onAccent : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
