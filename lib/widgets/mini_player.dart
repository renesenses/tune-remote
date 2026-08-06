import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/now_playing_screen.dart';
import '../state/app_state.dart';
import '../theme/tune_tokens.dart';
import 'cover.dart';
import 'quality_badge.dart';

/// Compact now-playing bar shown above the bottom navigation.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final z = app.currentZone;
    final t = z?.currentTrack;
    if (z == null || t == null || z.state == 'stopped') {
      return const SizedBox.shrink();
    }

    final dur = t.durationMs ?? 0;
    final progress = dur > 0 ? (z.positionMs / dur).clamp(0.0, 1.0) : 0.0;
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerHigh,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 2,
            color: TuneTokens.accent,
            backgroundColor: cs.surfaceContainerHighest,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const NowPlayingScreen())),
                    child: Row(
                      children: [
                        Cover(path: t.coverPath, size: 44, radius: 6),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(t.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Row(
                                children: [
                                  if (t.artistName != null)
                                    Flexible(
                                      child: Text(t.artistName!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: cs.onSurfaceVariant,
                                              fontSize: 12)),
                                    ),
                                  if (t.quality != null && !t.quality!.isEmpty) ...[
                                    if (t.artistName != null)
                                      const SizedBox(width: 6),
                                    QualityBadge(quality: t.quality),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: app.previous,
                ),
                IconButton.filled(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(z.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: app.togglePlay,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.skip_next),
                  onPressed: app.next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
