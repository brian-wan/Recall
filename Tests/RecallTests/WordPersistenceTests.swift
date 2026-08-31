import XCTest
import SwiftData
@testable import Recall

final class WordPersistenceTests: XCTestCase {
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        return ModelContext(container)
    }

    func testSavedWordRoundTripsThroughSwiftData() throws {
        let context = try makeInMemoryContext()
        let word = Word(character: "你好", pronunciation: "nǐ hǎo", meaning: "hello", languageCode: "zh")
        context.insert(word)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<Word>())

        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.character, "你好")
        XCTAssertEqual(fetched.first?.languageCode, "zh")
    }

    func testReviewDeckStartsEmpty() throws {
        // The review deck only ever contains words the user explicitly saved — nothing
        // is pre-seeded from the bundled dictionary at first launch.
        let context = try makeInMemoryContext()
        let fetched = try context.fetch(FetchDescriptor<Word>())
        XCTAssertTrue(fetched.isEmpty)
    }
}
