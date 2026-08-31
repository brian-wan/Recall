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

    func testFreshModelContextHasNoWords() throws {
        // A bare persistence layer starts empty — seeding, when it happens, is an
        // explicit act (see StarterWordSeederTests), not implicit SwiftData behavior.
        let context = try makeInMemoryContext()
        let fetched = try context.fetch(FetchDescriptor<Word>())
        XCTAssertTrue(fetched.isEmpty)
    }
}
