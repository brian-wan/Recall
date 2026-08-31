import Foundation

/// A word from the bundled starter dictionary — a suggestion source only. Filling the
/// add-word form from here doesn't create a `Word`; only Save does that.
struct DictionaryEntry: Codable, Hashable {
    var character: String
    var pronunciation: String
    var meaning: String
}

/// Loads the bundled language catalog and per-language starter dictionaries.
/// Everything here is static app-bundle content — nothing user-editable lives in this type.
@Observable
final class LanguageCatalog {
    static let shared = LanguageCatalog()

    let languages: [Language]
    private var dictionaries: [String: [DictionaryEntry]] = [:]

    private init() {
        languages = Self.loadLanguages()
        for language in languages {
            dictionaries[language.code] = Self.loadDictionary(named: language.dictionaryFile)
        }
    }

    func dictionary(for languageCode: String) -> [DictionaryEntry] {
        dictionaries[languageCode] ?? []
    }

    /// A random dictionary entry not already present in `knownWords`, or nil once every
    /// bundled word for this language has already been added.
    func suggestion(for languageCode: String, excluding knownWords: [Word]) -> DictionaryEntry? {
        let known = Set(
            knownWords
                .filter { $0.languageCode == languageCode }
                .map(\.character)
        )
        return dictionary(for: languageCode)
            .filter { !known.contains($0.character) }
            .randomElement()
    }

    private static func loadLanguages() -> [Language] {
        guard let url = Bundle.main.url(forResource: "Languages", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let languages = try? JSONDecoder().decode([Language].self, from: data)
        else {
            assertionFailure("Languages.json is missing or malformed")
            return []
        }
        return languages
    }

    private static func loadDictionary(named filename: String) -> [DictionaryEntry] {
        let name = (filename as NSString).deletingPathExtension
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([DictionaryEntry].self, from: data)
        else {
            assertionFailure("Dictionary file \(filename) is missing or malformed")
            return []
        }
        return entries
    }
}
