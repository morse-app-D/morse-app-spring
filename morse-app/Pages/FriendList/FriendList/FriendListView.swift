import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseFirestoreSwift
import Kingfisher

struct Friend: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
}

struct FriendListView: View {
    @ObservedObject var viewModel: FriendListViewModel
    
    var body: some View {
        ZStack {
            Color.backColor
                .ignoresSafeArea()
            VStack {
                ToolBar()
                    .padding()
                ScrollView {
                    ForEach(viewModel.friendList, id: \.uid) { friend in
                        if friend.name != "", friend.imageUrl != nil {
                            VStack{ // セルごとの間隔を設定
                                HStack {
                                    KFImage(friend.imageUrl)
                                        .resizable() //動的にサイズ変更
                                        .frame(width: 56, height: 56)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                        .padding(.leading, 25)
                                    
                                    Text(friend.name)
                                        .font(.custom("851Gkktt", size: 20))
                                        .padding(.leading, 10)
                                    Spacer()
                                }
                                .frame(width: 340, height: 100)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 2)
                                )
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await viewModel.getFriendList()
            }
        }
    }
}

struct ToolBar: View {
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
