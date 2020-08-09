//
//  FontUtility.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 5/28/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

enum Roboto_FontStyle {
    case ThinItalic
    case Thin
    case Regular
    case MediumItalic
    case Medium
    case LightItalic
    case Light
    case Italic
    case BoldItalic
    case Bold
    case BlackItalic
    case Black
}

public enum AppIcons: String {
    case edit = "\u{e900}"
    
    case orders = "\u{e909}"
    case outlinePerson = "\u{e904}"
    case outlineInfo = "\u{e901}"
    case outlineAddCircle = "\u{e902}"
    case outlineHelp = "\u{e903}"
    
    case aim_location = "\u{e908}"
    case conatctCard = "\u{e905}"
    case calendar = "\u{e907}"
    case clock = "\u{e906}"
    
    case profile = "\u{e90a}"
    case location = "\u{e90c}"
    case statistic = "\u{e90b}"
    case refEarn = "\u{0b}"
    case logout = "\u{e90d}"
    
    case cross = "\u{e90e}"
    case bell = "\u{e910}"
    
    case radioSelected = "\u{e90f}"
    case radioUnSelected = "\u{e911}"
    
    case questionMark = "\u{e912}"
    
    case paperPad = "\u{e913}"
    case cards = "\u{e915}"
    case businessBriefcase = "\u{e914}"
}

class FontUtility {
    private init() {}
    
    static func roboto(style: Roboto_FontStyle, size: CGFloat) -> UIFont {
        let fontFamily = "Roboto"
        guard let customFont = UIFont(
            name: "\(fontFamily)-\(style)",
            size:  size)
            else {
                fatalError("Failed to load the font: \(fontFamily)-\(style)")
        }
        
        return customFont
    }
    
    static func niharExpress(size: CGFloat) -> UIFont {
        let fontFamily = "nihar_font"
        return UIFont(name: fontFamily, size: size)!
    }
    
    static func appImageIcon(code: String, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear) -> UIImage {
        
        var size = size
        if size.width <= 0 { size.width = 1 }
        if size.height <= 0 { size.height = 1 }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        let fontSize = min(size.width/FontAwesomeConfig.fontAspectRatio , size.height)
        
        
        let strokeWidth: CGFloat = fontSize == 0 ? 0 : (-100 * borderWidth / fontSize)
        
        let attributedString = NSAttributedString(string: code, attributes: [
            NSAttributedString.Key.font: self.niharExpress(size: size.height),
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.backgroundColor: backgroundColor,
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.strokeWidth: strokeWidth,
            NSAttributedString.Key.strokeColor: borderColor
            ])
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        attributedString.draw(in: CGRect(x: 0, y: 0, width: size.width, height:size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
