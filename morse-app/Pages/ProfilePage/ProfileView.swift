import SwiftUI
import FirebaseAuth
import Kingfisher

struct ProfileView: View, SendProfileOKDelegate {
    
    @Environment(\.dismiss) private var dismiss
    @State var isShowSentView: Bool = false
    @State var showEditorView: Bool = false
    @State private var image: UIImage?
    @State var showImagePickerView: Bool = false
    @State var showAllUserList: Bool = false
    @StateObject var viewModel: ProfileViewModel
    @State var name: String = ""
    var width: CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    
    var body: some View {
        ZStack {
            Color.backColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Done")
                            .font(.custom("851Gkktt", size: 16))
                            .foregroundColor(.white)
                            .padding()
                    })
                    .padding()
                    Spacer()
                    
                    Button(action: {
                        showEditorView.toggle()
                    }, label: {
                        Text("編集")
                            .font(.custom("851Gkktt", size: 16))
                            .foregroundColor(.white)
                            .padding()
                    })
                    .padding()
                }
                .sheet(isPresented: $showEditorView) {
                    ZStack {
                        
                        Color.backColor
                            .ignoresSafeArea()
                        VStack(spacing: 50) {
                            if let image = image {
                                
                                if viewModel.imageUrl == URL(string: "") {
                                    
                                    Button {
                                        showImagePickerView.toggle()
                                    } label: {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: width - 100, height: width - 100)
                                            .background(Color.gray)
                                            .clipShape(Circle())
                                            .shadow(color: Color(.white), radius: 10)
                                            .shadow(color: Color(.white.withAlphaComponent(0.3)), radius: 10)
                                    }
                                    
                                } else {
                                    
                                    Button {
                                        showImagePickerView.toggle()
                                    } label: {
                                        KFImage(viewModel.imageUrl)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: width - 100 /*130*/, height: width - 100 /*130*/)
                                            .background(Color.gray)
                                            .clipShape(Circle())
                                            .shadow(color: Color(.white), radius: 10)
                                            .shadow(color: Color(.white.withAlphaComponent(0.3)), radius: 10)
                                    }
                                    
                                }
                                
                            } else {
                                
                                Button {
                                    showImagePickerView.toggle()
                                } label: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: width - 100, height: width - 100)
                                        .background(Color.gray)
                                        .clipShape(Circle())
                                        .shadow(color: Color(.white), radius: 10)
                                        .shadow(color: Color(.white.withAlphaComponent(0.3)), radius: 10)
                                }
                                
                            }
                            
                            TextField("Name", text: $name)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 1)
                                )
                                .padding(.horizontal, 20)
                                .font(.system(size: 24))
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(TextAlignment.center)
                                .frame(width: 380)
                            
                            
                            Button(action: {
                                Task {
                                    let profileData = friendDatas(name: name, imageUrl: viewModel.imageUrl)
                                    try await FirebaseClient.settingProfile(data:profileData, uid: Auth.auth().currentUser!.uid)
                                    showEditorView.toggle()
                                }
                            }, label: {
                                Text("保存")
                                    .font(.custom("851Gkktt", size: 30))
                                    .foregroundColor(.white)
                                    .padding()
                            })
                            
                        }
                        
                        .sheet(isPresented: $showImagePickerView) {
                            ImagePickerView(image: $image, sourceType: .library, allowsEditing: true)
                                .ignoresSafeArea(.all)
                        }
                        .onAppear {
                            
                            let checkModel = CheckPermission()
                            checkModel.showCheckPerission()
                            viewModel.sendToDBModel.sendProfileOKelegate = self
                            Task {
                                do {
                                    let userData = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
                                    viewModel.imageUrl = userData.imageUrl
                                } catch {
                                    print("プロフィールデータの取得の失敗",error.localizedDescription)
                                }
                            }
                            
                        }
                        .aspectRatio(contentMode: .fill)
                        .onChange(of: image) {
                            Task {
                                
                                try await viewModel.changeImages(image: image!)
                                
                            }
                        }
                        
                        VStack {
                            HStack {
                                Button(action: {
                                    showEditorView.toggle()
                                }, label: {
                                    Text("Done")
                                        .font(.custom("851Gkktt", size: 16))
                                        .foregroundColor(.white)
                                        .padding()
                                })
                                .padding()
                                Spacer()
                            }
                            Spacer()
                        }
                        
                    }
                }
                
                
                VStack(spacing: 20) {
                    KFImage(viewModel.getProfile?.imageUrl) // プロフィール画像
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                    
                    Text(viewModel.getProfile?.name ?? "User Name") // ユーザー名
                        .font(.custom("851Gkktt", size: 32))
                    
                    
                    HStack{
                        Button(action: {
                            showAllUserList.toggle()
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
                        .sheet(isPresented: $showAllUserList, content: {
                            FriendListView(viewModel: .init())
                        })
                        .background(Color.white) // 背景色を白に設定
                        .cornerRadius(12) // 角丸を追加
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2)) // 枠線を追加
                    }
                    .frame(width: 340, height: 64)
                    
                    
                    HStack{
                        Button(action: {
                            isShowSentView = true
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
                .onAppear(perform: {
                    Task {
                        viewModel.getProfile = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
                    }
                })
                .onChange(of: showEditorView) {
                    Task {
                        viewModel.getProfile = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
                    }
                }
                .background(Color.clear)
                .edgesIgnoringSafeArea(.all)
                Spacer()
            }
        }
    }
    func sendProfileOKDelegate(url: String) {
        
        viewModel.imageUrl = URL(string: url)
        if viewModel.imageUrl == nil {
            print("enpty")
        }
    }
}

