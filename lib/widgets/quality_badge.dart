import 'package:flutter/material.dart';

import '../api/models.dart';
import '../theme/tune_tokens.dart';

/// Audio quality tier — the audiophile classification shared with the iPad app.
///
/// - **dsd**   — codec is dsd/dsf/dff.
/// - **hires** — above CD (over 16-bit / 44.1 kHz), per [Quality.isHiRes].
/// - **cd**    — CD-quality lossless (flac/alac/wav/… or unknown codec).
/// - **lossy** — mp3/aac/ogg/opus…
enum QualityTier { dsd, hires, cd, lossy }

const _dsdCodecs = {'dsd', 'dsf', 'dff'};
const _losslessCodecs = {
  'flac', 'alac', 'wav', 'wave', 'aiff', 'aif', 'ape', 'wv', 'wavpack',
  'tak', 'shn', 'pcm',
};

/// Classifies [q] into a [QualityTier]; null when there is nothing to classify.
///
/// Mirrors the iPad app's `QualityTier.from(_:)` so both clients label the same
/// track identically.
QualityTier? qualityTierOf(Quality? q) {
  if (q == null || q.isEmpty) return null;
  final codec = (q.codec ?? '').toLowerCase();
  if (_dsdCodecs.contains(codec)) return QualityTier.dsd;
  // Some sources report DSD as its PCM-equivalent rate rather than by codec.
  if ((q.sampleRate ?? 0) >= 2000000) return QualityTier.dsd;
  if (q.isHiRes) return QualityTier.hires;
  if (codec.isEmpty || _losslessCodecs.contains(codec)) return QualityTier.cd;
  return QualityTier.lossy;
}

extension QualityTierStyle on QualityTier {
  /// Short label shown on the badge and on the filter chips.
  String get label => switch (this) {
        QualityTier.dsd => 'DSD',
        QualityTier.hires => 'HR',
        QualityTier.cd => 'CD',
        QualityTier.lossy => 'LOSSY',
      };

  Color get background => switch (this) {
        QualityTier.dsd => TuneTokens.badgeDsd,
        QualityTier.hires => TuneTokens.badgeHr,
        QualityTier.cd => TuneTokens.badgeCd,
        QualityTier.lossy => TuneTokens.surface2,
      };

  Color get foreground => switch (this) {
        QualityTier.dsd => TuneTokens.badgeOnBadgeDark,
        QualityTier.hires => TuneTokens.badgeOnBadge,
        QualityTier.cd => TuneTokens.badgeOnBadge,
        QualityTier.lossy => TuneTokens.muted,
      };
}

/// Provenance / quality badge — the audiophile signature shared with the iPad
/// app. Renders a compact colored pill for a track's [Quality], driven by the
/// shared design tokens.
///
/// Set [showDetail] to append the exact bit/kHz (e.g. `24/192`) beside the tier.
class QualityBadge extends StatelessWidget {
  final Quality? quality;
  final bool showDetail;

  const QualityBadge({super.key, required this.quality, this.showDetail = false});

  @override
  Widget build(BuildContext context) {
    final q = quality;
    final tier = qualityTierOf(q);
    if (q == null || tier == null) return const SizedBox.shrink();

    // Lossy shows the actual codec name (MP3, AAC…) rather than "LOSSY".
    final label = tier == QualityTier.lossy && (q.codec ?? '').isNotEmpty
        ? q.codec!.toUpperCase()
        : tier.label;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: tier.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child:
          Text(label, style: TuneTokens.badge.copyWith(color: tier.foreground)),
    );

    if (!showDetail || q.short.isEmpty) return badge;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        const SizedBox(width: 6),
        Text(q.short,
            style: const TextStyle(fontSize: 11, color: TuneTokens.muted)),
      ],
    );
  }
}
