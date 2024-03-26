//
//  SoundPlayer.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/26.
//

import AVFoundation
import UIKit

let soundPlayer = SoundPlayer.shared

class SoundPlayer: NSObject {
    
    static var shared = SoundPlayer()
    
    let long = NSDataAsset(name: MorseSound.long.rawValue)!.data
    let short = NSDataAsset(name: MorseSound.short.rawValue)!.data
    var musicPlayer: AVAudioPlayer!
    
    var datas: [AVAudioPlayer] = []
    
    func morsePlay(morse: [[Int]]) {
        for mrc in morse {
            
            soundPlayer(mrc: mrc)
            print("1文字")
            Thread.sleep(forTimeInterval: 0.2)
        }
    }

    //  1音再生
    func soundPlayer(mrc: [Int]){
        
        datas = []

        for int in mrc {
            var player: AVAudioPlayer
            if int == 0 {
                do {
                    
                    player = try AVAudioPlayer(data: short)
                    datas.append(player)
                } catch {
                    print("Error play morse")
                }
            } else {
                do {
                    player = try AVAudioPlayer(data: long)
                    datas.append(player)
                } catch {
                    print("Error play morse")
                }
            }
        }
        print("datasCount", datas.count)
        for data in datas {
            print("fast")
            data.play()
            Thread.sleep(forTimeInterval: 0.3)
        }

    }

    // 音楽を停止
    func stopAllMusic (){
        musicPlayer?.stop()
    }
    
}

enum MorseSound: String {
    case short = "morse_short"
    case long = "morse_long"
}
