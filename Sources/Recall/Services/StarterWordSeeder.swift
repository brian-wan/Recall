import Foundation
import SwiftData

/// Seeds the review deck with every bundled dictionary word, exactly once, on first
/// launch — the 100 most common words per language become your starting curriculum
/// instead of an empty deck. Guarded by a persisted flag (not "is the deck empty?"),
/// so deleting words later never silently triggers a reseed.
enum StarterWordSeeder {
    private static let seededKey = "com.brianwan.Recall.hasSeededStarterWords"

    @MainActor
    static func seedIfNeeded(context: ModelContext, defaults: UserDefaults = .standard) {
        guard !defaults.bool(forKey: seededKey) else { return }

        for language in LanguageCatalog.shared.languages {
            for entry in LanguageCatalog.shared.dictionary(for: language.code) {
                context.insert(
                    Word(
                        character: entry.character,
                        pronunciation: entry.pronunciation,
                        meaning: entry.meaning,
                        languageCode: language.code
                    )
                )
            }
        }

        defaults.set(true, forKey: seededKey)
    }
}
