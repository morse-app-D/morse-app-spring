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
    var body: some View {
        HStack {
            Button(action: {

            }, label: {
                Image(systemName: "person.circle")
            })
            .font(.system(size: 32))
            .foregroundColor(.white)
            Button(action: {

            }, label: {
                Image(systemName: "paperplane.circle")
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
