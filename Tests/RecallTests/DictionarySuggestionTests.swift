import XCTest
@testable import Recall

final class DictionarySuggestionTests: XCTestCase {
    func testSuggestionExcludesAlreadyKnownWords() {
        let catalog = LanguageCatalog.shared
        let allZh = catalog.dictionary(for: "zh")
        let known = allZh.dropLast().map {
            Word(character: $0.character, pronunciation: $0.pronunciation, meaning: $0.meaning, languageCode: "zh")
        }

        let suggestion = catalog.suggestion(for: "zh", excluding: known)

        XCTAssertNotNil(suggestion)
        XCTAssertEqual(suggestion?.character, allZh.last?.character)
    }

    func testSuggestionReturnsNilWhenEveryWordIsAlreadyKnown() {
        let catalog = LanguageCatalog.shared
        let allZh = catalog.dictionary(for: "zh")
        let known = allZh.map {
            Word(character: $0.character, pronunciation: $0.pronunciation, meaning: $0.meaning, languageCode: "zh")
        }

        XCTAssertNil(catalog.suggestion(for: "zh", excluding: known))
    }

    func testSuggestionIgnoresKnownWordsFromOtherLanguages() {
        let catalog = LanguageCatalog.shared
        let koreanKnown = catalog.dictionary(for: "ko").map {
            Word(character: $0.character, pronunciation: $0.pronunciation, meaning: $0.meaning, languageCode: "ko")
        }

        XCTAssertNotNil(catalog.suggestion(for: "zh", excluding: koreanKnown))
    }
}
