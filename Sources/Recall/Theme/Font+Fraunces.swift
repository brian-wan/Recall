import SwiftUI

extension Font {
    /// The bundled Fraunces italic display font, semibold weight.
    ///
    /// Fraunces ships as a single variable font whose named instances are all fixed at
    /// its 9pt text optical size (its unnamed default is actually Black/900 weight) —
    /// reaching the larger "display" optical cut used in the original mockup means
    /// setting the `wght`/`opsz` variation axes directly via CoreText, which isn't safe
    /// to hand-write without being able to test-render it. `Fraunces-SemiBoldItalic` is
    /// the closest verified, reliably-addressable named instance to the mockup's weight.
    static func fraunces(size: CGFloat) -> Font {
        .custom("Fraunces-SemiBoldItalic", size: size)
    }
}
