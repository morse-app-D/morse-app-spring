//
//  ContentView.swift
//  morse-app
//
//  Created by 大澤清乃 on 2024/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView(viewModel: .init(), setProfileViewModel: .init())
    }
}

#Preview {
    ContentView()
}

extension Color {
    static let backColor = Color("BackColor")
}
