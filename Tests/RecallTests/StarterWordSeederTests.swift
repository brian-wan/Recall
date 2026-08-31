import XCTest
import SwiftData
@testable import Recall

final class StarterWordSeederTests: XCTestCase {
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        return ModelContext(container)
    }

    /// A fresh, uniquely-named UserDefaults suite per test so seeding state never
    /// leaks between tests or across runs on the same simulator.
    private func makeIsolatedDefaults() -> UserDefaults {
        UserDefaults(suiteName: "StarterWordSeederTests.\(UUID().uuidString)")!
    }

    @MainActor
    func testFirstRunSeedsEveryBundledWordForEveryLanguage() throws {
        let context = try makeInMemoryContext()
        let defaults = makeIsolatedDefaults()

        StarterWordSeeder.seedIfNeeded(context: context, defaults: defaults)

        let words = try context.fetch(FetchDescriptor<Word>())
        let expectedCount = LanguageCatalog.shared.languages
            .map { LanguageCatalog.shared.dictionary(for: $0.code).count }
            .reduce(0, +)

        XCTAssertEqual(words.count, expectedCount)
        XCTAssertTrue(words.contains { $0.languageCode == "zh" })
        XCTAssertTrue(words.contains { $0.languageCode == "ko" })
    }

    @MainActor
    func testSecondCallDoesNotDuplicateWords() throws {
        let context = try makeInMemoryContext()
        let defaults = makeIsolatedDefaults()

        StarterWordSeeder.seedIfNeeded(context: context, defaults: defaults)
        let firstCount = try context.fetch(FetchDescriptor<Word>()).count

        StarterWordSeeder.seedIfNeeded(context: context, defaults: defaults)
        let secondCount = try context.fetch(FetchDescriptor<Word>()).count

        XCTAssertEqual(firstCount, secondCount)
    }

    @MainActor
    func testDeletingSeededWordsDoesNotTriggerAReseed() throws {
        // Seeding is gated on a persisted flag, not "is the deck empty?" — so a user
        // who clears their deck later doesn't have it silently repopulate.
        let context = try makeInMemoryContext()
        let defaults = makeIsolatedDefaults()

        StarterWordSeeder.seedIfNeeded(context: context, defaults: defaults)
        for word in try context.fetch(FetchDescriptor<Word>()) {
            context.delete(word)
        }

        StarterWordSeeder.seedIfNeeded(context: context, defaults: defaults)

        XCTAssertTrue(try context.fetch(FetchDescriptor<Word>()).isEmpty)
    }
}
