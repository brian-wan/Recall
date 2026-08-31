import Foundation

/// One entry in the bundled language catalog. Adding a new language to Recall means
/// adding an entry here plus a matching dictionary file — no Swift code changes.
struct Language: Codable, Identifiable, Hashable {
    var code: String           // BCP-47, e.g. "zh", "ko" — also Word.languageCode's key
    var displayName: String    // "Mandarin Chinese"
    var nativeName: String     // "中文"
    var voiceLocale: String    // locale AVSpeechSynthesisVoice expects, e.g. "zh-CN"
    var dictionaryFile: String // filename under Resources/Dictionaries

    var id: String { code }
}
