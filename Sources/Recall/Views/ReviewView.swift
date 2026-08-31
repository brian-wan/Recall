import SwiftUI
import SwiftData

/// The one main screen: a language picker, the flip card showing where you are in
/// review, and an add button. Everything else (the full word list) is one tap away.
struct ReviewView: View {
    @Query(sort: \Word.dateAdded) private var allWords: [Word]
    @State private var selectedLanguageCode: String
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var showingAddSheet = false

    private let catalog = LanguageCatalog.shared

    init() {
        _selectedLanguageCode = State(initialValue: LanguageCatalog.shared.languages.first?.code ?? "")
    }

    private var currentLanguage: Language? {
        catalog.languages.first { $0.code == selectedLanguageCode }
    }

    private var words: [Word] {
        allWords.filter { $0.languageCode == selectedLanguageCode }
    }

    private var currentWord: Word? {
        guard !words.isEmpty else { return nil }
        return words[min(currentIndex, words.count - 1)]
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if let word = currentWord, let language = currentLanguage {
                    FlipCardView(
                        word: word,
                        voiceLocale: language.voiceLocale,
                        isFlipped: $isFlipped,
                        onPrevious: goPrevious,
                        onNext: goNext
                    )
                } else {
                    emptyState
                }
                Spacer()
                addButton
                    .padding(.bottom, 18)
            }
            .padding(.horizontal, 18)
            .background(Palette.bg)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { languageMenu }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        WordListView(languageCode: selectedLanguageCode, languageName: currentLanguage?.nativeName ?? "")
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddWordSheet(languageCode: selectedLanguageCode, languageName: currentLanguage?.nativeName ?? "")
            }
            .onChange(of: selectedLanguageCode) {
                currentIndex = 0
                isFlipped = false
            }
        }
    }

    private var languageMenu: some View {
        Menu {
            ForEach(catalog.languages) { language in
                Button(language.nativeName) { selectedLanguageCode = language.code }
            }
        } label: {
            HStack(spacing: 4) {
                Text(currentLanguage?.nativeName ?? "")
                Image(systemName: "chevron.down").font(.caption2)
            }
            .foregroundStyle(Palette.ink)
        }
    }

    private var addButton: some View {
        Button {
            showingAddSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 54, height: 54)
                .background(
                    LinearGradient(
                        colors: [Palette.indigo, Palette.indigoStrong],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                .shadow(color: Palette.indigo.opacity(0.45), radius: 14, y: 8)
        }
        .buttonStyle(SquishButtonStyle())
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Text("No words yet")
                .font(.fraunces(size: 22))
                .foregroundStyle(Palette.ink)
            Text("Tap + to add your first word.")
                .foregroundStyle(Palette.inkSoft)
        }
    }

    private func goPrevious() {
        guard !words.isEmpty else { return }
        currentIndex = (currentIndex - 1 + words.count) % words.count
        isFlipped = false
    }

    private func goNext() {
        guard !words.isEmpty else { return }
        currentIndex = (currentIndex + 1) % words.count
        isFlipped = false
    }
}

private struct SquishButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
