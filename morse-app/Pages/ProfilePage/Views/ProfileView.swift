import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
//            Color(#colorLiteral(red: 0.8823529481887817, green: 0.8392156958580017, blue: 0.7882353067398071, alpha: 1)).edgesIgnoringSafeArea(.all)
            Color.backColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        // ボタンがタップされた時のアクション
                    }) {
                        Text("Done")
                            .font(.custom("851Gkktt", size: 16))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding(.top)
                    .padding()
                    Spacer()
                }
                
                
                VStack(spacing: 20) {
                    Image("CassetteWidget") // プロフィール画像
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                    
                    Text("Name") // ユーザー名
                        .font(.custom("851Gkktt", size: 32))
                    Text("User10") // id
                        .font(.custom("851Gkktt", size: 20))
                    
                    
                    
                    HStack{
                        Button(action: {
                            // ボタンがタップされた時のアクション
                        }) {
                            Image(systemName: "person.2")
                                .resizable()
                                .frame(width: 26, height: 18)
                                .foregroundColor(.black)
                                .padding()
                            Text("友達一覧") // ボタンのテキスト
                                .font(.custom("851Gkktt", size: 18))
                                .foregroundColor(.black)
                                .padding()
                            
                            Spacer()
                        }
                        .background(Color.white) // 背景色を白に設定
                        .cornerRadius(12) // 角丸を追加
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2)) // 枠線を追加
                    }
                    .frame(width: 340, height: 64)
                    
                    
                    HStack{
                        Button(action: {
                            // ボタンがタップされた時のアクション
                        }) {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .frame(width: 24.75, height: 18)
                                .foregroundColor(.black)
                                .padding()
                            Text("送信済一覧") // ボタンのテキスト
                                .font(.custom("851Gkktt", size: 18))
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                        }
                        .background(Color.white) // 背景色を白に設定
                        .cornerRadius(12) // 角丸を追加
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2)) // 枠線を追加
                    }
                    .frame(width: 340, height: 64)
                }
                .background(Color.clear)
                .edgesIgnoringSafeArea(.all)
                Spacer()
            }
        }
    }
}
