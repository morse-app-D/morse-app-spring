//
//  DetailView].swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/28.
//

import SwiftUI

struct DetailView: View {
    
    @State private var morse: String = ""
    @State private var message: String = ""
    @State private var sender: String = ""
    
    
    
    var originalMessage = ""
    var datas: [[Int]] = []
//    var viewModel: DetailViewModel
    
    
    init(message: String, sender: String) {
        
        self.originalMessage = message
        self.sender = sender
        self.datas = manager.stringToMorce(string: originalMessage) ?? []
        
        
    }
    
    var body: some View {
        ZStack {
            Color.backColor
                .ignoresSafeArea()
            VStack {
                Image("CassetteWidget")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 230, height: 230)
                    .clipShape(Rectangle())
                    .padding(60)
                
                TextView(text: $morse, sender: $sender)
                
                TextView(text: $message, sender: $sender)
                
            }
        }
        .task {
            soundPlayer.setup(morse: datas) {_ in
                Task {
                    await soundPlayer.playMorse()
                }
                Task {
                    await playText()
                }
            }
            
            self.morse = manager.toMorseMark(morse: datas)
        }
    }
    
    func playText() async {
        
        for index in 0..<datas.count {
            do {
                
                message = String(originalMessage.prefix(index + 1))
                
                let shortCnt = datas[index].filter({ $0 == 0 }).count
                let longCnt = datas[index].filter({ $0 == 1 }).count
                var time = UInt64(shortCnt) * 130_000_000
                time += UInt64(longCnt) * 250_000_000
                
                time += 200_000_000
                
                try await Task.sleep(nanoseconds: time)
                
            } catch {
                print("Error play text")
            }
        }
    }
    
}

struct TextView: View {
    
    @Binding var text: String
    @Binding var sender: String
    
    var body: some View {
        VStack {
            Text(text)
            Text("by: \(sender)")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(width: 230, height: 125)
        .background(.white)
        .cornerRadius(25)
        
    }
}

#Preview {
    DetailView(message: "いつかどんなときだってあそびたいんだーー", sender: "ひかる")
}
