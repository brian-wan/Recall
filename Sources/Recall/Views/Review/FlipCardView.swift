import SwiftUI

/// The card itself carries no visible border or fill — text sits directly on the
/// screen background. The left third moves to the previous word, the right third to
/// the next, and the middle flips. The zones are deliberately invisible; there's no
/// on-screen hint for them, matching the finalized mockup design.
struct FlipCardView: View {
    let word: Word
    let voiceLocale: String
    @Binding var isFlipped: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void

    var body: some View {
        ZStack {
            front.opacity(isFlipped ? 0 : 1)
            back
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.55), value: isFlipped)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { isFlipped.toggle() }
        .overlay(navigationZones)
        .onChange(of: word.id) { isFlipped = false }
    }

    private var front: some View {
        VStack(spacing: 14) {
            Text(word.character)
                .font(.system(size: 48))
            HStack(spacing: 8) {
                Text(word.pronunciation)
                    .font(.custom("IBMPlexMono-Italic", size: 16))
                    .foregroundStyle(Palette.indigoStrong)
                Button {
                    SpeechService.shared.speak(word.character, voiceLocale: voiceLocale)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.caption)
                        .foregroundStyle(Palette.indigoStrong)
                }
                .buttonStyle(.plain)
            }
        }
        .foregroundStyle(Palette.ink)
        .padding(.horizontal, 44)
    }

    private var back: some View {
        VStack(spacing: 14) {
            Text(word.meaning)
                .font(.fraunces(size: 30))
            HStack(spacing: 8) {
                Text(word.character)
                    .font(.system(size: 16))
                Text(word.pronunciation)
                    .font(.custom("IBMPlexMono-Italic", size: 13))
            }
            .foregroundStyle(Palette.inkSoft)
        }
        .foregroundStyle(Palette.ink)
        .padding(.horizontal, 44)
    }

    private var navigationZones: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: geo.size.width * 0.3)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onPrevious)
                Color.clear
                    .frame(width: geo.size.width * 0.4)
                    .allowsHitTesting(false)
                Color.clear
                    .frame(width: geo.size.width * 0.3)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onNext)
            }
        }
    }
}
