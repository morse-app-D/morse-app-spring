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
                                .padding(.leading, 50)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            
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
