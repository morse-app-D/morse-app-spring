import SwiftUI

struct HomeView: View {
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
                        ForEach(1..<10) { index in
                            Cassette()
                        }
                        .scrollTransition(axis: .horizontal) {
                            content,
                            phase in
                            content
                                .scaleEffect(1 - (phase.value < 0 ? -phase.value : phase.value))
                                .opacity(phase.isIdentity ? 1 : 0)
                        }
                    }
                    .padding(.leading, 0)
                }
            }
        }
    }
}

struct Cassette: View {
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
                Text("本文")
                Text("by: \("名前")")
            }
            .frame(width: 230, height: 125)
            .background(.white)
            .cornerRadius(25)
        }
        .padding(.trailing)
    }
}

struct ModalView: View {

    @State var name: String = ""
    @State var editorText: String = ""

    @Binding var isPresented: Bool

    let characterLimit = 30

    var body: some View {
        VStack {
            TextField("送り先を入力", text: $name)
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

            Button("Done") {
                isPresented = false
            }
            .font(.system(size: 30))
            .padding()
            .foregroundColor(.white)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.88, green: 0.84, blue: 0.79))
    }
}

struct TopButton: View {
    @State private var showModal = false
    @State private var toProfileView = false
    @State private var toSendView = false
    var body: some View {
        HStack {
            Button(action: {
                self.toProfileView = true
            }, label: {
                Image(systemName: "person.circle")
            })
            .font(.system(size: 40))
            .foregroundColor(.white)
            .sheet(isPresented: $toProfileView, content: {
                ProfileView()
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
            .sheet(isPresented: $showModal) {
                ModalView(isPresented: $showModal)
            }
//            .sheet(isPresented: $toSendView, content: {
//                SendView()
//            })
        }
    }
}

#Preview {
    HomeView()
}
