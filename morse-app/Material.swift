//
//  Material.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/26.
//

import SwiftUI

let material = Material.shared

class Material {
    
    static var shared = Material()
    
    //使用可能文字: ひらがな、数字、長音、「、」（小さい「っ」などは入力はできるが、出力時に大きくなる）
    let morces = [MorceData(jpn: "い", mrc: [0,1]), MorceData(jpn: "ろ", mrc: [0,1,0,1]),  MorceData(jpn: "は", mrc: [1,0,0,0]), MorceData(jpn: "に", mrc: [1,0,1,0]),  MorceData(jpn: "ほ", mrc: [1,0,0]), MorceData(jpn: "へ", mrc: [0]), MorceData(jpn: "と", mrc: [0,0,2,0,0]), MorceData(jpn: "ち", mrc: [0,0,1,0]), MorceData(jpn: "り", mrc: [1,1,0]), MorceData(jpn: "ぬ", mrc: [0,0,0,0]), MorceData(jpn: "る", mrc: [1,0,1,1,0]), MorceData(jpn: "を", mrc: [0,1,1,1]), MorceData(jpn: "わ", mrc: [1,0,1]), MorceData(jpn: "か", mrc: [0,1,0,0]), MorceData(jpn: "よ", mrc: [1,1]), MorceData(jpn: "た", mrc: [1,0]), MorceData(jpn: "れ", mrc: [1,1,1]), MorceData(jpn: "そ", mrc: [1,1,1,0]), MorceData(jpn: "つ", mrc: [0,1,1,0]), MorceData(jpn: "ね", mrc: [1,1,0,1]), MorceData(jpn: "な", mrc: [0,1,0]), MorceData(jpn: "ら", mrc: [0,0,0]), MorceData(jpn: "む", mrc: [1]), MorceData(jpn: "う", mrc: [0,0,1]), MorceData(jpn: "の", mrc: [0,0,1,1]), MorceData(jpn: "お", mrc: [0,1,0,0,0]), MorceData(jpn: "く", mrc: [0,0,0,1]), MorceData(jpn: "や", mrc: [0,1,1]), MorceData(jpn: "ま", mrc: [1,0,0,1]), MorceData(jpn: "け", mrc: [1,0,1,1]), MorceData(jpn: "ふ", mrc: [1,1,0,0]), MorceData(jpn: "こ", mrc: [1,1,1,1]), MorceData(jpn: "え", mrc: [1,0,1,1,1]), MorceData(jpn: "て", mrc: [0,1,0,1,1]), MorceData(jpn: "あ", mrc: [1,1,0,1,1]), MorceData(jpn: "さ", mrc: [1,0,1,0,1]), MorceData(jpn: "き", mrc: [1,0,1,0,0]), MorceData(jpn: "ゆ", mrc: [1,0,0,1,1]), MorceData(jpn: "め", mrc: [1,0,0,0,1]), MorceData(jpn: "み", mrc: [0,0,1,0,1]), MorceData(jpn: "し", mrc: [1,1,0,1,0]), MorceData(jpn: "ひ", mrc: [1,1,0,0,1]), MorceData(jpn: "も", mrc: [1,0,0,1,0]), MorceData(jpn: "せ", mrc: [0,1,1,1,0]), MorceData(jpn: "す", mrc: [1,1,1,0,1]), MorceData(jpn: "ん", mrc: [0,1,0,1,0]), MorceData(jpn: "゛", mrc: [0,0]), MorceData(jpn: "゜", mrc: [0,0,1,1,0]), MorceData(jpn: "ー", mrc: [0,1,1,0,1]), MorceData(jpn: "、", mrc: [0,1,0,1,0,1]), MorceData(jpn: "0", mrc: [1,1,1,1,1]), MorceData(jpn: "1", mrc: [0,1,1,1,1]), MorceData(jpn: "2", mrc: [0,0,1,1,1]), MorceData(jpn: "3", mrc: [0,0,0,1,1]), MorceData(jpn: "4", mrc: [0,0,0,0,1]), MorceData(jpn: "5", mrc: [0,0,0,0,0]), MorceData(jpn: "6", mrc: [1,0,0,0,0]), MorceData(jpn: "7", mrc: [1,1,0,0,0]), MorceData(jpn: "8", mrc: [1,1,1,0,0]), MorceData(jpn: "9", mrc: [1,1,1,1,0])]
    
    
}
