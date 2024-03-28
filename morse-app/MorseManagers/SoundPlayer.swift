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
    
    var datas: [[AVAudioPlayer]] = []
    var morse: [[Int]] = []
    
//    func morsePlay(morse: [[Int]]) {
//        for mrc in morse {
//            
//            soundPlayer(mrc: mrc)
//            print("1文字")
//            Thread.sleep(forTimeInterval: 0.2)
//        }
//    }
//
//    //  音再生
//    func soundPlayer(mrc: [Int]){
//        
//        datas = []
//
//        for int in mrc {
//            var player: AVAudioPlayer
//            if int == 0 {
//                do {
//                    
//                    player = try AVAudioPlayer(data: short)
//                    datas.append(player)
//                } catch {
//                    print("Error play morse")
//                }
//            } else {
//                do {
//                    player = try AVAudioPlayer(data: long)
//                    datas.append(player)
//                } catch {
//                    print("Error play morse")
//                }
//            }
//        }
//        print("datasCount", datas.count)
//        for data in datas {
//            print("fast")
//            data.play()
//            Thread.sleep(forTimeInterval: 0.3)
//        }
//
//    }
    
    func createShort() -> AVAudioPlayer? {
        var sound: AVAudioPlayer
        
        do {
            sound = try AVAudioPlayer(data: short)
            return sound
        } catch {
            print("Error add short sound")
            return nil
        }
        
    }
    
    func createLong() -> AVAudioPlayer? {
        var sound: AVAudioPlayer
        
        do {
            sound = try AVAudioPlayer(data: long)
            return sound
        } catch {
            print("Error add short sound")
            return nil
        }
        
    }
    
    func setup(morse: [[Int]], shortSound: AVAudioPlayer, longSound: AVAudioPlayer, completion: @escaping (Any) -> Void) {
        
        self.morse = morse
        
        
        datas = []
        for mrs in morse {
            
            var data: [AVAudioPlayer] = []
            for int in mrs {
                if int == 0 {
                    data.append(shortSound)

                } else {
                    data.append(longSound)

                }
                print("1音")
            }
            print("1文字")
            datas.append(data)
            
        }
        
        completion(true)
    }
    
    
    func playMorse() async {
        for dataNum in 0..<datas.count {
            do {
                print("一文字")
                for index in 0..<datas[dataNum].count {
                    
                    datas[dataNum][index].play()
                    print("play")
                    
                    if morse[dataNum][index] == 0 {
                        try await Task.sleep(nanoseconds: 130_000_000)
                    } else {
                        try await Task.sleep(nanoseconds: 250_000_000)
                    }
                }
                try await Task.sleep(nanoseconds: 100_000_000)
            } catch {
                print("Error play sound")
            }
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
