import Foundation
import SwiftData

/// A word the user has chosen to learn. Only ever created through an explicit Save —
/// the bundled dictionary is a suggestion source, never inserted here automatically.
/// If a word shows up in review, you already decided to learn it.
///
/// Shaped to be CloudKit-sync-safe (every stored property has a default, no unique
/// constraints) even though sync isn't turned on yet, so enabling it later — e.g. once
/// this needs to support more than one person, each with their own private list — is a
/// `ModelConfiguration` change, not a schema migration.
@Model
final class Word {
    var id: UUID = UUID()
    var character: String = ""
    var pronunciation: String = ""
    var meaning: String = ""
    var languageCode: String = ""
    var dateAdded: Date = Date()

    init(character: String, pronunciation: String, meaning: String, languageCode: String) {
        self.character = character
        self.pronunciation = pronunciation
        self.meaning = meaning
        self.languageCode = languageCode
        self.dateAdded = Date()
    }
}
