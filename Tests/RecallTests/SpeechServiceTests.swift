import XCTest
import AVFoundation
@testable import Recall

final class SpeechServiceTests: XCTestCase {
    func testMandarinVoiceResolves() {
        XCTAssertNotNil(AVSpeechSynthesisVoice(language: "zh-CN"))
    }

    func testKoreanVoiceResolves() {
        XCTAssertNotNil(AVSpeechSynthesisVoice(language: "ko-KR"))
    }
}
