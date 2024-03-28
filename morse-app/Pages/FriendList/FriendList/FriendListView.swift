import SwiftUI

struct Friend: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
}

struct FriendListView: View {
    let friends = [
        Friend(name: "友達1", imageName: "friend1_image"),
        Friend(name: "友達2", imageName: "friend2_image"),
        Friend(name: "友達3", imageName: "friend3_image")
    ]
    
    var body: some View {
        ZStack {
            Color.backColor
                .ignoresSafeArea()
            
            VStack {
                TopBarView()
                    .padding()
                ForEach(friends) { friend in
                    VStack{ // セルごとの間隔を設定
                        HStack {
                            Image(friend.imageName)
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
    FriendListView()
}
