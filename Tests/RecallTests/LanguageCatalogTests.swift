import XCTest
@testable import Recall

final class LanguageCatalogTests: XCTestCase {
    func testCatalogLoadsBundledLanguages() {
        let catalog = LanguageCatalog.shared
        let codes = Set(catalog.languages.map(\.code))
        XCTAssertEqual(codes, ["zh", "ko"])
    }

    func testEachLanguageHasANonEmptyDictionary() {
        let catalog = LanguageCatalog.shared
        for language in catalog.languages {
            XCTAssertFalse(
                catalog.dictionary(for: language.code).isEmpty,
                "\(language.code) should have bundled starter words"
            )
        }
    }

    func testVoiceLocalesAreLanguageSpecific() {
        let catalog = LanguageCatalog.shared
        XCTAssertEqual(catalog.languages.first { $0.code == "zh" }?.voiceLocale, "zh-CN")
        XCTAssertEqual(catalog.languages.first { $0.code == "ko" }?.voiceLocale, "ko-KR")
    }
}
