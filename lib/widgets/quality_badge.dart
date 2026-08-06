import 'package:flutter/material.dart';

import '../api/models.dart';
import '../theme/tune_tokens.dart';

/// Provenance / quality badge — the audiophile signature shared with the iPad
/// app. Classifies a [Quality] into a tier (CD / HR / DSD / lossy) and renders
/// a compact colored pill driven by the shared design tokens.
///
/// Tiers:
/// - **DSD**  — codec is dsd/dsf/dff.
/// - **HR**   — hi-res (above 16-bit / 48 kHz), per [Quality.isHiRes].
/// - **CD**   — CD-quality lossless (flac/alac/wav/… or unknown codec).
/// - lossy    — mp3/aac/ogg/opus… shown muted with the codec name.
///
/// Set [showDetail] to append the exact bit/kHz (e.g. `24/192`) beside the tier.
class QualityBadge extends StatelessWidget {
  final Quality? quality;
  final bool showDetail;

  const QualityBadge({super.key, required this.quality, this.showDetail = false});

  static const _dsdCodecs = {'dsd', 'dsf', 'dff'};
  static const _losslessCodecs = {
    'flac', 'alac', 'wav', 'wave', 'aiff', 'aif', 'ape', 'wv', 'wavpack',
    'tak', 'shn', 'pcm',
  };

  _Tier _tierFor(Quality q) {
    final codec = (q.codec ?? '').toLowerCase();
    if (_dsdCodecs.contains(codec)) return _Tier.dsd;
    if (q.isHiRes) return _Tier.hires;
    if (codec.isEmpty || _losslessCodecs.contains(codec)) return _Tier.cd;
    return _Tier.lossy;
  }

  @override
  Widget build(BuildContext context) {
    final q = quality;
    if (q == null || q.isEmpty) return const SizedBox.shrink();

    final (Color bg, Color fg, String label) = switch (_tierFor(q)) {
      _Tier.dsd => (TuneTokens.badge_dsd, TuneTokens.badge_onBadgeDark, 'DSD'),
      _Tier.hires => (TuneTokens.badge_hr, TuneTokens.badge_onBadge, 'HR'),
      _Tier.cd => (TuneTokens.badge_cd, TuneTokens.badge_onBadge, 'CD'),
      _Tier.lossy => (
          TuneTokens.surface2,
          TuneTokens.muted,
          (q.codec ?? '').toUpperCase(),
        ),
    };

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TuneTokens.badge.copyWith(color: fg)),
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

enum _Tier { dsd, hires, cd, lossy }
