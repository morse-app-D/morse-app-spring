
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

struct SentView: View {
    @StateObject var viewModel: SentViewModel
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
                     try await viewModel.getSentMessage()
                        print(viewModel.sentMessages, Auth.auth().currentUser!.uid)
                    }
                }
        }
    }
}

struct TopBar: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        HStack {
            Spacer().overlay(
                HStack {
                    Button(action: {
                        dismiss()
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
    @StateObject var viewModel: SentViewModel
    var body: some View {
        List(viewModel.sentMessages, id: \.id) { message in
            VStack {
                HStack {
                    Image("CassetteWidget")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                    VStack {
                        Text(message.body!)
                            .font(.custom("851Gkktt", size: 18))
                        Text("\(message.time!.dateValue().formatted())")
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


