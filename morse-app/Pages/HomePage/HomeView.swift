import SwiftUI
import AVFAudio
import Kingfisher
import FirebaseAuth

struct HomeView: View, SendProfileOKDelegate {
    
    func sendProfileOKDelegate(url: String) {
        
        setProfileViewModel.imageUrl = URL(string: url)
        if setProfileViewModel.imageUrl == nil {
            print("enpty")
        }
    }
    
    @StateObject var viewModel: HomeViewModel
    @StateObject var setProfileViewModel: ProfileViewModel
    @State var showHurrySetUpView: Bool = false
    @State private var image: UIImage?
    @State var showImagePickerView: Bool = false
    @State var name: String = ""
    var width: CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
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
                        ForEach(viewModel.messageDatas, id: \.time) { index in
                            Cassette(text: index.body!, sender: index.name)
                        }
                        .scrollTransition(axis: .horizontal) {
                            content,
                            phase in
                            content
                                .scaleEffect(1 - (phase.value < 0 ? -phase.value : phase.value))
                                .opacity(phase.isIdentity ? 1 : 0)
                        }
                    }
                    .padding(.horizontal, 60)
                }
            }
            .onAppear() {
                Task {
                    viewModel.startListening()
                    viewModel.receivedDatas = try await viewModel.getMessages()
                    let myUserData = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
                    if myUserData.name == "" || myUserData.imageUrl == URL(string: "") || myUserData.imageUrl == nil {
                        showHurrySetUpView.toggle()
                    }
                }
            }
            .onChange(of: TopButton().showModal) {
                Task {
                    viewModel.receivedDatas = try await viewModel.getMessages()
                }
            }
            .sheet(isPresented: $showHurrySetUpView) {
                ZStack {
                    Color.backColor
                        .ignoresSafeArea()
                    VStack(spacing: 50) {
                        if let image = image {
                            
                            if setProfileViewModel.imageUrl == URL(string: "") {
                                
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
                                    KFImage(setProfileViewModel.imageUrl)
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
                                let profileData = friendDatas(name: name, imageUrl: setProfileViewModel.imageUrl)
                                try await FirebaseClient.settingProfile(data:profileData, uid: Auth.auth().currentUser!.uid)
                                showHurrySetUpView.toggle()
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
                        UITextField.appearance().returnKeyType = .done
                        let checkModel = CheckPermission()
                        checkModel.showCheckPerission()
                        setProfileViewModel.sendToDBModel.sendProfileOKelegate = self
                        Task {
                            do {
                                let userData = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
                                setProfileViewModel.imageUrl = userData.imageUrl
                            } catch {
                                print("プロフィールデータの取得の失敗",error.localizedDescription)
                            }
                        }
                        
                    }
                    .aspectRatio(contentMode: .fill)
                    .onChange(of: image) {
                        Task {
                            
                            try await setProfileViewModel.changeImages(image: image!)
                            
                        }
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Text("profileを設定しよう！")
                                .font(.custom("851Gkktt", size: 20))
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                    
                }
            }
        }
    }
    
    struct Cassette: View {
        @State var text: String
        @State var sender: String
        var body: some View {
            VStack(alignment: .center) {
                Button(action: {
                    var trimNewline = text.trimmingCharacters(in: .newlines)
                    let morse = Manager.shared.stringToMorce(string: trimNewline)
                    let mark = Manager.shared.toMorseMark(morse: morse!)
//                    SoundPlayer.shared.setup(morse: morse!, shortSound: <#T##AVAudioPlayer#>, longSound: <#T##AVAudioPlayer#>, completion: <#T##(Any) -> Void#>)
                    print(mark)
                },label:  {
                    Image("CassetteWidget")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 230, height: 230)
                        .clipShape(Rectangle())
                        .padding(.bottom, 40)
                })
                VStack {
                    Text(text)
                    Text("by: \(sender)")
                }
                .frame(width: 230, height: 125)
                .background(.white)
                .cornerRadius(25)
            }
            .padding(.trailing)
        }
    }
    
    struct ModalView: View {
        
        @Environment(\.dismiss) private var dismiss
        @State var name: String = ""
        @State var editorText: String = ""
        @State var isShowUserPickerView = false
        @Binding var isPresented: Bool
        @StateObject var viewModel: HomeViewModel
        
        let characterLimit = 30
        
        var body: some View {
            
            ZStack {
                
                VStack {
                    
                    Button {
                        Task {
                            let allUserData = try await FirebaseClient.getAllUsers()
                            viewModel.allUserDatas = allUserData
                            print(allUserData)
                            isShowUserPickerView.toggle()
                        }
                    } label: {
                        TextField("送り先を選ぶ", text: $name)
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
                            .disabled(true)
                    }
                    
                    .sheet(isPresented: $isShowUserPickerView) {
                        
                        GeometryReader { mainView in
                            
                            ScrollView {
                                
                                VStack() {
                                    ForEach(viewModel.allUserDatas!,id: \.uid) { list in
                                        if list.name != "", list.imageUrl != nil{
                                            GeometryReader{item in
                                                SelectUserSheetCell(uid: list.uid!, name: list.name, imageUrl: list.imageUrl ?? URL(string: viewModel.defaltImageUrl)!)
                                                    .scaleEffect(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY + 25),anchor: .bottom)
                                                    .opacity(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY + 25))
                                            }
                                            .frame(height: 90)
                                            .padding(.horizontal)
                                            .onTapGesture {
                                                name = list.name
                                                viewModel.uid = list.uid!
                                                isShowUserPickerView.toggle()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("メッセージをひらがなで入力しよう！")
                        .padding(.top, 30)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    TextEditor(text: $editorText)
                        .frame(width: 340, height: 200)
                        .scrollContentBackground(.hidden)
                        .background(.white, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(lineWidth: 1)
                        )
                    
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: editorText) { newValue in
                            if newValue.count > characterLimit {
                                editorText = String(newValue.prefix(characterLimit))
                            }
                        }
                    
                    
                    
                    
                    
                    
                    
                    Button("送信") {
                        var trimNewline = editorText.trimmingCharacters(in: .newlines)
                        viewModel.sendMessage(text: trimNewline, toId: viewModel.uid)
                        viewModel.saveSentMessage(text: editorText, toId: viewModel.uid)
                        isPresented = false
                    }
                    .font(.system(size: 30))
                    .padding()
                    .foregroundColor(.white)
                    .disabled(viewModel.uid == "")
                    .disabled(editorText == "")
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.88, green: 0.84, blue: 0.79))
                .ignoresSafeArea(.keyboard)
                
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Done")
                                .font(.custom("851Gkktt", size: 16))
                                .foregroundColor(.white)
                                .padding()
                        })
                        .padding(.top)
                        .padding()
                        Spacer()
                    }
                    Spacer()
                }
                
            }
        }
        
        func scaleValue(mainFrame: CGFloat, minY: CGFloat)-> CGFloat {
            let scale = minY / mainFrame
            return scale > 1 ? 1 : scale
        }
    }
    
    struct SelectUserSheetCell: View {
        @State var uid: String
        @State var name: String = ""
        @State var imageUrl: URL = URL(string: "")!
        var body: some View {
            VStack(alignment: .leading) {
                
                HStack(spacing: 0) {
                    KFImage(imageUrl)
                        .resizable()
                        .cornerRadius(16)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("name")
                            .font(.system(size: 18))
                            .lineLimit(nil)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .minimumScaleFactor(0.1)
                        
                        Text(uid == Auth.auth().currentUser!.uid ? "You" : name)
                            .font(.system(size: 21))
                            .foregroundColor(.black)
                    } .padding(10)
                    
                    Spacer()
                    
                }
                .padding(8)
            }
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .padding(.top, 15)
        }
    }
    
    struct TopButton: View {
        @State var showModal = false
        @State var toProfileView = false
        @State var toSendView = false
        var body: some View {
            HStack {
                Button(action: {
                    self.toProfileView = true
                }, label: {
                    Image(systemName: "person.circle")
                })
                .font(.system(size: 40))
                .foregroundColor(.white)
                .fullScreenCover(isPresented: $toProfileView, content: {
                    ProfileView(viewModel: .init())
                })
                Button(action: {
                    self.toSendView = true
                    showModal.toggle()
                }, label: {
                    Image(systemName: "square.and.pencil.circle")
                })
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding(.leading, 240)
                .fullScreenCover(isPresented: $showModal) {
                    ModalView(isPresented: $showModal, viewModel: .init())
                }
                //            .sheet(isPresented: $toSendView, content: {
                //                SendView()
                //            })
            }
        }
    }
}
