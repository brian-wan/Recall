import SwiftUI
import SwiftData

/// Every word saved for one language — reached from the review screen's list icon.
struct WordListView: View {
    let languageCode: String
    let languageName: String

    @Query private var allWords: [Word]

    private var words: [Word] {
        let matching = allWords.filter { $0.languageCode == languageCode }
        return matching.sorted { $0.dateAdded < $1.dateAdded }
    }

    var body: some View {
        List {
            if words.isEmpty {
                Text("No words yet — add one from the review screen.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(words, id: \.id) { word in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(word.character)
                            Text(word.pronunciation)
                                .font(.custom("IBMPlexMono-Italic", size: 12))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(word.meaning)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(languageName)
    }
}
