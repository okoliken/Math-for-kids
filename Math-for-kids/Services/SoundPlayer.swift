//
//  SoundPlayer.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 15/06/2026.
//

import AudioToolbox
import AVFoundation

/// Plays short sound effects. Prefers a bundled audio file by name and falls
/// back to a system sound when that asset isn't in the bundle — so the app
/// still ticks/clicks before custom audio is added.
final class SoundPlayer {
    static let shared = SoundPlayer()

    /// Cached players keyed by resource name, so repeated effects (like the
    /// once-a-second countdown tick) don't reload the file each time.
    private var players: [String: AVAudioPlayer] = [:]

    private init() {
        #if os(iOS)
        // Play effects alongside any other audio, and keep them audible even
        // when the ring/silent switch is set.
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
    }

    /// Plays the bundled sound `name` (any of `extensions`); if it isn't found,
    /// plays `fallbackSystemSound` instead.
    ///
    /// When `restartIfPlaying` is `false`, a call while the clip is still playing
    /// is ignored so it finishes — useful for clips longer than the interval they
    /// fire on (e.g. a tick that should play in full rather than restart each second).
    func play(
        _ name: String,
        extensions: [String] = ["wav", "caf", "mp3", "m4a", "aiff"],
        fallbackSystemSound: SystemSoundID? = nil,
        restartIfPlaying: Bool = true
    ) {
        if let player = player(for: name, extensions: extensions) {
            if player.isPlaying && !restartIfPlaying { return }
            player.currentTime = 0
            player.play()
        } else if let systemSound = fallbackSystemSound {
            AudioServicesPlaySystemSound(systemSound)
        }
    }

    /// Stops `name` if it's mid-playback — e.g. when leaving the screen that
    /// triggered it, so a sound doesn't keep ringing out after the view is gone.
    func stop(_ name: String) {
        players[name]?.stop()
    }

    private func player(for name: String, extensions: [String]) -> AVAudioPlayer? {
        if let cached = players[name] { return cached }

        guard let url = extensions
            .lazy
            .compactMap({ Bundle.main.url(forResource: name, withExtension: $0) })
            .first,
            let player = try? AVAudioPlayer(contentsOf: url)
        else { return nil }

        player.prepareToPlay()
        players[name] = player
        return player
    }
}
