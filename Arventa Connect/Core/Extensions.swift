//
//  Extensions.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit
import SwiftyJSON
import SAMKeychain

//String Extension
extension String{
    /**
     Returns trimmed version of the string
     - returns: Optional Date
     */
    var trimmed: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var nullableTrimmed: String?{
        return self.trimmed != "" ? self.trimmed : nil
    }
    
    /**
     Attempts to convert this string to date using a format
     - parameters:
        - format: Date format (refer to https://stackoverflow.com/questions/35700281/date-format-in-swift)
     - returns: Optional Date
     */
    func toDate(withFormat format: String = "MMM dd,yyyy") -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")

    public func convertedToSlug() -> String? {
        if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
            let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
            let result = urlComponents.filter { $0 != "" }.joined(separator: "-")

            if result.count > 0 {
                return result
            }
        }

        return nil
    }
    
    public func defaultTextIfBlank(_ text: String = "N/A") -> String{
        nullableTrimmed ?? text
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

//Date Extension
extension Date{
    /**
     Convert this date to specified format
     - parameters:
        - format: Date format (refer to https://stackoverflow.com/questions/35700281/date-format-in-swift)
     - returns: String
     */
    func toString(withFormat format: String = "MMM dd, yyyy") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func startOfDay() -> Date{
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay() -> Date{
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let to = calendar.date(byAdding: .day,
                               value: 1,
                               to: self.startOfDay())
        return to!
    }
}

//UITextField Extension
extension UITextField{
    var trimmedText: String{
        return (self.text ?? "").trimmed
    }
    
    var nullableTrimmmedText: String?{
        return self.trimmedText != "" ? self.trimmedText : nil
    }
    
    var parsedInteger: Int?{
        return Int(self.trimmedText)
    }
}

extension UIAlertAction{
    static func cancelButton(with text: String = "Cancel", handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction{
        return UIAlertAction(title: text,
                             style: .cancel,
                             handler: handler)
    }
}

//Dictionary Extension
extension Dictionary{
    func toJSONString() -> String{
        if let jsonString = JSON(self).rawString(){
            return jsonString
        }else{
            return "{}"
        }
    }
}

// Attributed String Extension
extension NSMutableAttributedString {
    
    class func getAttributedString(fromString string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], subString: String)  {
        if let range = self.string.range(of: subString) {
            self.apply(attribute: attribute, onRange: NSRange(range, in: self.string))
        }
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], onRange range: NSRange) {
        if range.location != NSNotFound {
            self.setAttributes(attribute, range: range)
        }
    }
    
    
    /********************* Color Attribute *********************/
    // Apply color on substring
    func apply(color: UIColor, subString: String) {
        
        if let range = self.string.range(of: subString) {
            self.apply(color: color, onRange: NSRange(range, in:self.string))
        }
    }
    
    // Apply color on given range
    func apply(color: UIColor, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.foregroundColor: color],
                           range: onRange)
    }
    
    
    
    /********************* Font Attribute *********************/
    // Apply font on substring
    func apply(font: UIFont, subString: String)  {
        
        if let range = self.string.range(of: subString) {
            self.apply(font: font, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply font on given range
    func apply(font: UIFont, onRange: NSRange) {
        
        self.addAttributes([NSAttributedString.Key.font: font], range: onRange)
    }
    
    
    
    /********************* Background Color Attribute *********************/
    // Apply background color on substring
    func apply(backgroundColor: UIColor, subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(backgroundColor: backgroundColor, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply background color on given range
    func apply(backgroundColor: UIColor, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.backgroundColor: backgroundColor],
                           range: onRange)
    }
    
    
    
    /********************* Underline Attribute *********************/
    // Underline string
    func underLine(subString: String) {
        if let range = self.string.range(of: subString) {
            self.underLine(onRange: NSRange(range, in: self.string))
        }
    }
    
    // Underline string on given range
    func underLine(onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue],
                           range: onRange)
    }
    
    
    
    /********************* Strikethrough Attribute *********************/
    // Apply Strikethrough on substring
    func strikeThrough(thickness: Int, subString: String)  {
        if let range = self.string.range(of: subString) {
            self.strikeThrough(thickness: thickness, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply Strikethrough on given range
    func strikeThrough(thickness: Int, onRange: NSRange)  {
        
        self.addAttributes([NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.thick.rawValue],
                           range: onRange)
    }
    
    
    
    /********************* Stroke Attribute *********************/
    // Apply stroke on substring
    func applyStroke(color: UIColor, thickness: Int, subString: String) {
        if let range = self.string.range(of: subString) {
            self.applyStroke(color: color, thickness: thickness, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply stroke on give range
    func applyStroke(color: UIColor, thickness: Int, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.strokeColor : color],
                           range: onRange)
        self.addAttributes([NSAttributedString.Key.strokeWidth : thickness],
                           range: onRange)
    }
    
    
    
    /********************* Shadow Color Attribute *********************/
    // Apply shadow color on substring
    func applyShadow(shadowColor: UIColor, shadowWidth: CGFloat, shadowHeigt: CGFloat, shadowRadius: CGFloat, subString: String) {
        if let range = self.string.range(of: subString) {
            self.applyShadow(shadowColor: shadowColor, shadowWidth: shadowWidth, shadowHeigt: shadowHeigt, shadowRadius: shadowRadius, onRange: NSRange(range, in: self.string))
            
        }
    }
    
    // Apply shadow color on given range
    func applyShadow(shadowColor: UIColor, shadowWidth: CGFloat, shadowHeigt: CGFloat, shadowRadius: CGFloat, onRange: NSRange) {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: shadowWidth, height: shadowHeigt)
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = shadowRadius
        self.addAttributes([NSAttributedString.Key.shadow : shadow], range: onRange)
    }
    
    
    
    /********************* Paragraph Style  Attribute *********************/
    // Apply paragraph style on substring
    func alignment(alignment: NSTextAlignment, subString: String) {
        if let range = self.string.range(of: subString) {
            self.alignment(alignment: alignment, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply paragraph style on give range
    func alignment(alignment: NSTextAlignment, onRange: NSRange) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        self.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: onRange)
    }
    
    
}

extension UIStackView{
    func removeAllSubviews(permanently: Bool = true){
        arrangedSubviews.forEach { (view) in
            removeArrangedSubview(view)
        }
        
        if permanently{
            subviews.forEach { (view) in
                view.removeFromSuperview()
            }
        }
    }
}

extension UIView {
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

//Bundle Extension
extension Bundle{
    //Returns default bundle identifier
    static var bundleID: String{
        return Bundle.main.bundleIdentifier ?? "com.arventa.connect"
    }
}

//UUID Extension
extension UUID{
    static var deviceUUID: String{
        var finalUUID = ""
        if let uuid = SAMKeychain.password(forService: Bundle.bundleID, account: Bundle.bundleID){
            finalUUID = uuid
        }else{
            let uuid = UUID().uuidString
            SAMKeychain.setPassword(uuid, forService: Bundle.bundleID, account: Bundle.bundleID)
            finalUUID = uuid
        }
        return finalUUID
    }
}
