import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseFirestoreSwift

struct Friend: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
}

struct FriendListView: View {
    @ObservedObject var viewModel: FriendListViewModel
    
    //テスト用
//    let friendList: [friendDatas] = [friendDatas(uid: "vblahhbv", name: "name", image: URL(string: "data:image/jpeg;base64,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"))]

    
    var body: some View {
        ZStack {
            Color.backColor
                .ignoresSafeArea()
            VStack {
                TopBarView()
                    .padding()
                ForEach(viewModel.friendList, id: \.uid) { friend in
                    VStack{ // セルごとの間隔を設定
                        HStack {
                            Image(uiImage: urlToImage(friend.image!)) //imageはURLだから変換する必要がある
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
                        .border(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(lineWidth: 2)
                        )
                    }
                    .padding(.bottom, 16)
                }
            }
            .padding(.top, -300)
        }
    }
    
    func urlToImage(_ url: URL) -> UIImage {
//        let url = URL(string: string)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)!
        } catch {
            print("Error url to image")
        }
        
        return UIImage()
    }
}




struct TopBarView: View {
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
            Text("友達リスト")
                .font(.custom("851Gkktt", size: 20))
            Spacer()
        }
    }
}

#Preview {
    FriendListView(viewModel: FriendListViewModel())
}
