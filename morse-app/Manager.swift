//
//  Manager.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/26.
//

import SwiftUI

let manager = Manager.shared

class Manager {
    
    static var shared = Manager()
    
    let morces = material.morces
    
    func stringToMorce(string: String) -> [[Int]]? {
        var result: [[Int]] = []
        //文字列を1文字ずつに分割
        let array = Array(string)
        //String.ElementをStringに直す
        var strArray: [String] = []
        
        for arr in array {
            strArray += checkIrregular(string: String(arr))
        }
        
        for s in strArray {
            if let morce = morces.first(where: { $0.jpn == s }) {
                result.append(morce.mrc)
            } else {
                print("Error translate from string to morce: \(s)")
                return nil
            }
        }
        
        return result
        
    }
    
    func morceToString(morce: [[Int]]) -> String? {
        
        var string = ""
        
        for m in morce {
            if let s = morces.first(where: { $0.mrc == m }) {
                string += s.jpn
            } else {
                print("Error translate from morce to string: \(m)")
                return nil
            }
        }
        
        return string
        
    }
    
    func toMorceMark(morce: [[Int]]) -> String {
        var string: String = ""
        
        for m in morce {
            for int in m {
                string += toMark(num: int)
            }
            string += " "
        }
        
        
        return string
    }
    
    func toMark(num: Int) -> String {
        if num == 0 {
            return "・"
        } else {
            return "ー"
        }
    }
    
    func checkIrregular(string: String) -> [String] {
        switch string {
        case"が":
            return ["か", "゛"]
        case "ぎ":
            return ["き", "゛"]
        case "ぐ":
            return ["く", "゛"]
        case "げ":
            return ["け", "゛"]
        case "ご":
            return ["こ", "゛"]
        case "ざ":
            return ["さ", "゛"]
        case "じ":
            return ["し", "゛"]
        case "ず":
            return ["す", "゛"]
        case "ぜ":
            return ["せ", "゛"]
        case "ぞ":
            return ["そ", "゛"]
        case "だ":
            return ["た", "゛"]
        case "ぢ":
            return ["ち", "゛"]
        case "づ":
            return ["つ", "゛"]
        case "で":
            return ["て", "゛"]
        case "ど":
            return ["と", "゛"]
        case "ば":
            return ["は", "゛"]
        case "び":
            return ["ひ", "゛"]
        case "ぶ":
            return ["ふ", "゛"]
        case "べ":
            return ["へ", "゛"]
        case "ぼ":
            return ["ほ", "゛"]
        case "ぱ":
            return ["は", "゜"]
        case "ぴ":
            return ["ひ", "゜"]
        case "ぷ":
            return ["ふ", "゜"]
        case "ぺ":
            return ["へ", "゜"]
        case "ぽ":
            return ["ほ", "゜"]
        case "ぁ":
            return ["あ"]
        case "ぃ":
            return ["い"]
        case "ぅ":
            return ["う"]
        case "ぇ":
            return ["え"]
        case "ぉ":
            return ["お"]
        case "っ":
            return ["つ"]
        case "ゃ":
            return ["や"]
        case "ゅ":
            return ["ゆ"]
        case "ょ":
            return ["よ"]
        default:
            return [string]
            
        }
    }
    
}

