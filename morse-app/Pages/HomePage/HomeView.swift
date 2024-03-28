import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack{
            Color.backColor
                .ignoresSafeArea()
            VStack {
                TopButton()
                Spacer()
            }
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(1..<10) { index in
                            Cassette()
                        }
                        .scrollTransition(axis: .horizontal) {
                            content,
                            phase in
                            content
                                .scaleEffect(1 - (phase.value < 0 ? -phase.value : phase.value))
                                .opacity(phase.isIdentity ? 1 : 0)
                        }
                    }
                    .padding(.leading, 0)
                }
            }
        }
    }
}

struct Cassette: View {
    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                print("button pressed")
            },label:  {
                Image("CassetteWidget")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 230, height: 230)
                    .clipShape(Rectangle())
                    .padding(.bottom, 40)
            })
            VStack {
                Text("本文")
                Text("by: \("名前")")
            }
            .frame(width: 230, height: 125)
            .background(.white)
            .cornerRadius(25)
        }
        .padding(.trailing)
    }
}

struct TopButton: View {
    @State private var toProfileView = false
    @State private var toSendView = false
    var body: some View {
        HStack {
            Button(action: {
                self.toProfileView = true
            }, label: {
                Image(systemName: "person.circle")
            })
            .font(.system(size: 40))
            .foregroundColor(.white)
            .sheet(isPresented: $toProfileView, content: {
                ProfileView()
            })
            Button(action: {
                self.toSendView = true
            }, label: {
                Image(systemName: "square.and.pencil.circle")
            })
            .font(.system(size: 40))
            .foregroundColor(.white)
            .padding(.leading, 240)
//            .sheet(isPresented: $toSendView, content: {
//                SendView()
//            })
        }
    }
}

#Preview {
    HomeView()
}
