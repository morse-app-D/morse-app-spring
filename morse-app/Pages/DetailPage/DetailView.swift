import SwiftUI
import AVFoundation

let cassetteOnData = NSDataAsset(name: "cassette-on")!.data
private var musicPlayer: AVAudioPlayer!

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
                RollCassette()
                    .padding(.bottom, 24)
                TextView(text: $morse, sender: $sender)
                    .padding(.bottom, 8)
                TextView(text: $message, sender: $sender)
                
            }
        }
        .task {
            
            self.morse = manager.toMorseMark(morse: datas)
            
            if let short = soundPlayer.createShort(), let long = soundPlayer.createLong() {
                soundPlayer.setup(morse: datas, shortSound: short, longSound: long) {_ in
                    Task {
                        await soundPlayer.playMorse()
                    }
                    Task {
                        await playText()
                    }
                }
            }
            
            
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

struct RollCassette: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Image("CassetteWidget")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
            HStack {
                Image("roll_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: 1.8).repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                    }
                Image("roll_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: 1.8).repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                    }
                    .padding(.leading, 64)
                
            }
            .padding(.top, 42)
        }
    }
}

struct TextView: View {
    
    @Binding var text: String
    @Binding var sender: String
    
    var body: some View {
        VStack {
            Text(text)
                .frame(width: 300, height: 120)
            HStack {
                Spacer()
                Text("by: かっつー")
                    .padding(.trailing, 24)
            }
        }
        .frame(width: 304, height: 162)
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.black, lineWidth: 2)
        )
        
    }
}

#Preview {
    DetailView(message: "あさになるまでかえりたくないのです", sender: "かっつー")
}
