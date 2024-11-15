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
            UIColor.colorSelection1.codedString, UIColor.colorSelection2.codedString, UIColor.colorSelection3.codedString,
            UIColor.colorSelection4.codedString, UIColor.colorSelection5.codedString, UIColor.colorSelection6.codedString,
            UIColor.colorSelection7.codedString, UIColor.colorSelection8.codedString, UIColor.colorSelection9.codedString,
            UIColor.colorSelection10.codedString, UIColor.colorSelection11.codedString, UIColor.colorSelection12.codedString,
            UIColor.colorSelection13.codedString, UIColor.colorSelection14.codedString, UIColor.colorSelection15.codedString,
            UIColor.colorSelection16.codedString, UIColor.colorSelection17.codedString, UIColor.colorSelection18.codedString,
        ])
}
