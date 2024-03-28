import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
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
                    if let receivedDatas = viewModel.receivedDatas {
                        HStack {
                            ForEach(receivedDatas, id: \.time) { index in
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
            }
            .onAppear() {
                Task {
                    viewModel.receivedDatas = try await viewModel.getMessages()
                }
            }
            .onChange(of: TopButton().showModal) {
                Task {
                    viewModel.receivedDatas = try await viewModel.getMessages()
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
                print("button pressed")
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
                                    if list.name != "", list.imageUrl != nil {
                                        GeometryReader{item in
                                            SelectUserSheetCell(name: list.name, imageUrl: list.imageUrl ?? URL(string: viewModel.defaltImageUrl)!)
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
                    viewModel.sendMessage(text: editorText, toId: viewModel.uid)
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
                    
                    Text(name)
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

