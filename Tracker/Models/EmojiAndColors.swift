//
//  EmojiAndColors.swift
//  Tracker
//
//  Created by Денис Максимов on 07.10.2024.
//

import UIKit

struct EmojiAndColors {
    static let emojiCategory = EmojiGategory(
        title: "Emoji",
        emoji: [
            "🙂", "😻", "🌺", "🐶", "❤️", "😱",
            "😇", "😡", "🥶", "🤔", "🙌", "🍔",
            "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
        ])
    static let colorsCategory = ColorsGategory(
        title: "Цвет",
        colors: [
            .colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6,
            .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12,
            .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18
        ])
}
