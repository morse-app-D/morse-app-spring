
import SwiftUI

struct SentView: View {
    @ObservedObject var viewModel: SentViewModel
    var body: some View {
        ZStack {
            Color.backColor
                .ignoresSafeArea()
                VStack {
                    TopBar()
                        .padding()
                    ListView(viewModel: viewModel)
                    Spacer()
                }
                .onAppear {
                    Task {
                    viewModel.getSentMessage
                    }
                }
        }
    }
}

struct TopBar: View {
    var body: some View {
        HStack {
            Spacer().overlay(
                HStack {
                    Button(action: {
                        print()
                    }, label: {
                        Text("Done")
                            .font(.custom("851Gkktt", size: 18))
                            .foregroundStyle(.white)
                    })
                    Spacer()
                }
            )
            Text("送信済")
                .font(.custom("851Gkktt", size: 20))
            Spacer()
        }
    }
}

struct ListView: View {
    @ObservedObject var viewModel: SentViewModel
    var body: some View {
        //["",""]
        List(viewModel.sentMessages)  { messages in
            VStack {
                HStack {
                    Image("CassetteWidget")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                    VStack {
                        Text(messages.body)
                            .font(.custom("851Gkktt", size: 18))
                        Text("yyyy/MM/dd")
                            .font(.custom("851Gkktt", size: 18))
                    }
                    .padding(.leading, 8)
                }
            }
            .frame(width: 340, height: 173)
            .background(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.black, lineWidth: 2)
            )
            .listRowBackground(Color.clear)
            .frame(width: 340, height: 173)
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
    }
}


