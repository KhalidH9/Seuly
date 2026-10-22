import SwiftUI

enum SaudiRiyalSymbolScale {
    case caption2
    case caption
    case subheadline
    case body
    case headline
    case title3
    case title2
    case title
    case largeTitle

    var baseHeight: CGFloat {
        switch self {
        case .caption2: 8
        case .caption: 8.5
        case .subheadline: 10.8
        case .body, .headline: 12.2
        case .title3: 14.5
        case .title2: 16
        case .title: 20
        case .largeTitle: 24.5
        }
    }

    var relativeTextStyle: Font.TextStyle {
        switch self {
        case .caption2: .caption2
        case .caption: .caption
        case .subheadline: .subheadline
        case .body: .body
        case .headline: .headline
        case .title3: .title3
        case .title2: .title2
        case .title: .title
        case .largeTitle: .largeTitle
        }
    }
}
