//
//  Dictionary_Extension.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

extension Dictionary {
    /// Prints json formatted output on console
    /// Author: Swapnil Dhotre
    func printPrettyJSON() {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print("JSON:\n\(jsonString)")
            }
        } catch {
            print("Error in json conversion: \(error)")
        }
    }
}

// Used to fetching nesting dictionary -by Swapnil
extension Dictionary {
    subscript(keyPath keyPath: String) -> Any? {
        get {
            guard let keyPath = Dictionary.keyPathKeys(forKeyPath: keyPath)
                else { return nil }
            return getValue(forKeyPath: keyPath)
        }
        set {
            guard let keyPath = Dictionary.keyPathKeys(forKeyPath: keyPath),
                let newValue = newValue else { return }
            self.setValue(newValue, forKeyPath: keyPath)
        }
    }
    static private func keyPathKeys(forKeyPath: String) -> [Key]? {
        let keys = forKeyPath.components(separatedBy: ".")
            .reversed().compactMap({ $0 as? Key })
        return keys.isEmpty ? nil : keys
    }
    // recursively (attempt to) access queried subdictionaries
    // (keyPath will never be empty here; the explicit unwrapping is safe)
    private func getValue(forKeyPath keyPath: [Key]) -> Any? {
        guard let value = self[keyPath.last!] else { return nil }
        return keyPath.count == 1 ? value : (value as? [Key: Any])
            .flatMap { $0.getValue(forKeyPath: Array(keyPath.dropLast())) }
    }
    // recursively (attempt to) access the queried subdictionaries to
    // finally replace the "inner value", given that the key path is valid
    private mutating func setValue(_ value: Any, forKeyPath keyPath: [Key]) {
        guard self[keyPath.last!] != nil else { return }
        if keyPath.count == 1 {
            (value as? Value).map { self[keyPath.last!] = $0 }
        }
        else if var subDict = self[keyPath.last!] as? [Key: Value] {
            subDict.setValue(value, forKeyPath: Array(keyPath.dropLast()))
            (subDict as? Value).map { self[keyPath.last!] = $0 }
        }
    }
}
extension Sequence where Iterator.Element == [String: Any] {
    
    func printPrettyJSON() {
        var jsonObjArray: [String] = []
        forEach {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    jsonObjArray.append(jsonString)
                }
            } catch {
                print("Error in json conversion: \(error)")
            }
        }
        print("JSON:\n[ \(jsonObjArray.joined(separator: ",\n"))]")
    }
}

