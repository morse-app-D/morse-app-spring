//
//  ContentView.swift
//  morse-app
//
//  Created by 大澤清乃 on 2024/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {

            
            
            Button(action: {
                print(manager.stringToMorce(string: "いつか"))
            }, label: {
                Text("to morse")
            })
            
            Button(action: {
                soundPlayer.morsePlay(morse: [[0,1], [0,1,1,0], [0,1,0,0]])
//                soundPlayer.morsePlay(morse: [[0]])
            }, label: {
                Text("play morse")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
