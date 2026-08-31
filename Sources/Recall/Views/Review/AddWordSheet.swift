import SwiftUI
import SwiftData

/// Bottom sheet for adding a word to the review deck. "Suggest a word" pre-fills the
/// fields from the bundled dictionary; either path only ever creates a `Word` on Save.
struct AddWordSheet: View {
    let languageCode: String
    let languageName: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var allWords: [Word]

    @State private var character = ""
    @State private var pronunciation = ""
    @State private var meaning = ""

    private let catalog = LanguageCatalog.shared

    var body: some View {
        NavigationStack {
            Form {
                Button(action: suggest) {
                    Label("Suggest a word", systemImage: "sparkle")
                }

                Section {
                    TextField("Character", text: $character)
                    TextField("Pronunciation", text: $pronunciation)
                    TextField("Meaning", text: $meaning)
                }
            }
            .navigationTitle("Add to \(languageName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(character.isEmpty || pronunciation.isEmpty || meaning.isEmpty)
                }
            }
        }
    }

    private func suggest() {
        guard let entry = catalog.suggestion(for: languageCode, excluding: allWords) else { return }
        character = entry.character
        pronunciation = entry.pronunciation
        meaning = entry.meaning
    }

    private func save() {
        let word = Word(character: character, pronunciation: pronunciation, meaning: meaning, languageCode: languageCode)
        modelContext.insert(word)
        dismiss()
    }
}
