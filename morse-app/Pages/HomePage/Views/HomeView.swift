import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack{
            Color.backColor
                .ignoresSafeArea()
            VStack {
                TopButton()
                    .padding()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(1..<10) { index in
                            Cassette()
                        }
                        .scrollTransition(axis: .horizontal) { content, phase in
                            content
                                .scaleEffect(1 - (phase.value < 0 ? -phase.value : phase.value))
                                .opacity(phase.isIdentity ? 1 : 0)
                            
                        }
                    }
                }
            }
        }
    }
}

struct Cassette: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("CassetteWidget")
                .resizable()
                .scaledToFill()
                .frame(width: 290, height: 290)
                .clipShape(Rectangle())
                .padding(.bottom, 20)
            VStack {
                Text("本文")
                Text("by: \("名前")")
            }
            .frame(width: 300, height: 145)
            .background(.white)
            .cornerRadius(25)
        }
        .padding(.leading, 50)
    }
}

struct TopButton: View {
    var body: some View {
        HStack {
            Button(action: {
                print()
            }, label: {
                Image(systemName: "person.circle")
            })
            .font(.system(size: 32))
            .foregroundColor(.white)
            Button(action: {}, label: {
                Image(systemName: "plus")
            })
            .font(.system(size: 32))
            .foregroundColor(.white)
            .padding(.leading, 240)
        }
    }
}

#Preview {
    HomeView()
}
