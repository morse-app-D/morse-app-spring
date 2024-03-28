import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isShowSentView: Bool = false
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        ZStack {
            Color.backColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        // ボタンがタップされた時のアクション
                    }) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Done")
                                .font(.custom("851Gkktt", size: 16))
                                .foregroundColor(.white)
                                .padding()
                        })
                    }
                    .padding(.top)
                    .padding()
                    Spacer()
                }
                
                
                VStack(spacing: 20) {
                    Image(uiImage: urlToImage(viewModel.profile!.imageUrl!))
                    //                    プロフィール画像
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())

                    Text(viewModel.profile?.name ?? "") // ユーザー名
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
                            isShowSentView = true
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
                    .sheet(isPresented: $isShowSentView, content: {
                        SentView(viewModel: .init())
                    })
                }
                .background(Color.clear)
                .edgesIgnoringSafeArea(.all)
                Spacer()
            }
        }
        .onAppear {
            Task {
                try await viewModel.getProfile()
            }
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
