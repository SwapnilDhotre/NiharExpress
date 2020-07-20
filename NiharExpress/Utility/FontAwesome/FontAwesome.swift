
import UIKit
import CoreText

public struct FontAwesomeConfig {

    private init() { }

    public static let fontAspectRatio: CGFloat = 1.28571429
}

public enum FontAwesomeStyle: String {
    case solid
    case regular
    case brands
    case light
    
    func fontName() -> String {
        switch self {
        case .solid:
            return "FontAwesome5ProSolid"
        case .regular:
            return "FontAwesome5ProRegular"
        case .brands:
            return "FontAwesome5BrandsRegular"
        case .light:
            return "FontAwesome5ProLight"
        }
    }

    func fontFilename() -> String {
        switch self {
        case .solid:
            return "fa-solid-900"
        case .regular:
            return "fa-regular-400"
        case .brands:
            return "fa-brands-400"
        case .light:
            return "fa-light-300"
        }
    }

    func fontFamilyName() -> String {
        switch self {
        case .brands:
            return "Font Awesome 5 Brands"
        case .regular,
             .solid,
             .light:
            return "Font Awesome 5 Pro"
        }
    }
}


public extension UIFont {

    class func fontAwesome(ofSize fontSize: CGFloat, style: FontAwesomeStyle) -> UIFont {
        
        //loadFontAwesome(ofStyle: style)
        return UIFont(name: style.fontName(), size: fontSize)!
    }

    class func loadFontAwesome(ofStyle style: FontAwesomeStyle) {
        if UIFont.fontNames(forFamilyName: style.fontFamilyName()).contains(style.fontName()) {
            return
        }
        
        FontLoader.loadFont(style.fontFilename())
    }
}


public extension String {

    static func fontAwesomeIcon(fontAwesome: FontAwesome) -> String {
        let toIndex = fontAwesome.rawValue.index(fontAwesome.rawValue.startIndex, offsetBy: 1)
        return String(fontAwesome.rawValue[fontAwesome.rawValue.startIndex..<toIndex])
    }
    
    static func fontAwesomeIcon(name: String) -> String? {
        guard let  fontAwesome = self.fontAwesome(name: name) else {
            return nil
        }
        return self.fontAwesomeIcon(fontAwesome: fontAwesome)
    }
    
    static func fontAwesome(name: String) -> FontAwesome? {
        guard let raw = FontAwesomeIcons[name] else {
            return nil
        }
        return FontAwesome(rawValue: raw)
    }
    
    //NEWIOSCOMM-621
    func parseStyleWithName() -> (style: FontAwesomeStyle, name: String) {
        var tuple = (style:FontAwesomeStyle.light,name:"")
        if Array(self).count>3{
            let index = self.index(self.startIndex, offsetBy: 3)
            let indexWithSpace = self.index(self.startIndex, offsetBy: 4)
            let mySubstring = self.prefix(upTo:index)
            tuple.name = String(self[indexWithSpace...])
            switch mySubstring {
            case "fab":
                 tuple.style = .brands
            case "far":
                tuple.style = .regular
            case "fal":
                tuple.style = .light
            case "fas":
                tuple.style = .solid
            default:
                break
            }
        }
        return tuple
    }
}

public extension UIImage {

    static func fontAwesomeIcon(fontAwesome: FontAwesome, style: FontAwesomeStyle, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear) -> UIImage {

     
        var size = size
        if size.width <= 0 { size.width = 1 }
        if size.height <= 0 { size.height = 1 }

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center

        let fontSize = min(size.width-5, size.height-5)

    
        let strokeWidth: CGFloat = fontSize == 0 ? 0 : (-100 * borderWidth / fontSize)

        let attributedString = NSAttributedString(string: String.fontAwesomeIcon(fontAwesome: fontAwesome), attributes: [
            NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: fontSize, style: style),
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.backgroundColor: backgroundColor,
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.strokeWidth: strokeWidth,
            NSAttributedString.Key.strokeColor: borderColor
            ])

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        attributedString.draw(in: CGRect(x: 0, y: 0, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    static func fontAwesomeIcon(name: String, style: FontAwesomeStyle, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear) -> UIImage? {
        guard let raw = FontAwesomeIcons[name] else {
            return nil
        }
        return fontAwesomeIcon(code:raw, style: style, textColor: textColor, size: size, backgroundColor: backgroundColor, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    static func fontAwesomeIcon(code: String, style: FontAwesomeStyle, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear) -> UIImage {
        
        
        var size = size
        if size.width <= 0 { size.width = 1 }
        if size.height <= 0 { size.height = 1 }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        let fontSize = min(size.width/FontAwesomeConfig.fontAspectRatio , size.height)
        
        
        let strokeWidth: CGFloat = fontSize == 0 ? 0 : (-100 * borderWidth / fontSize)
        
        let attributedString = NSAttributedString(string: code, attributes: [
            NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: fontSize, style: style),
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


private class FontLoader {
    class func loadFont(_ name: String) {
        guard
            let fontURL = URL.fontURL(for: name),
               let data = try? Data(contentsOf: fontURL),
            let provider = CGDataProvider(data: data as CFData),
            let font = CGFont(provider)
            else { return }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            guard let nsError = error?.takeUnretainedValue() as AnyObject as? NSError else { return }
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }
}

extension URL {
    static func fontURL(for fontName: String) -> URL? {
        let bundle = Bundle(for: FontLoader.self)

        if let fontURL = bundle.url(forResource: fontName, withExtension: "ttf") {
            return fontURL
        }
        return nil
    }
}
