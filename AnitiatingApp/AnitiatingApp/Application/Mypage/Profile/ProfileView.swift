import SwiftUI
import ComposableArchitecture
import URLImage

struct ProfileView: View {
    
    @Bindable var store: StoreOf<ProfileFeature>
    @State private var editToggle = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        VStack {
            if let profileImage = selectedImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(lineWidth: 0.5))
                    .onTapGesture {
                        if editToggle {
                            showImagePicker = true
                        }
                    }
            } else {
                URLImage(URL(string: store.user.profile)!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(lineWidth: 0.5))
                .onTapGesture {
                    if editToggle {
                        showImagePicker = true
                    }
                }
            }

            if editToggle {
                TextField("이름", text: $store.user.name.sending(\.setName))
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)

                TextField("한 마디", text: $store.user.coment.sending(\.setComent))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
            } else {
                Text("\(store.user.name)")
                    .font(.title)

                Text("\(store.user.coment)")
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if editToggle {
                    Button {
                        store.send(.cancelButtonTapped)
                        editToggle = false
                        selectedImage = nil
                    } label: {
                        Text("취소")
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if editToggle {
                    Button {
                        store.send(.saveButtonTapped)
                        editToggle = false
                    } label: {
                        Text("저장")
                    }
                } else {
                    Button {
                        store.send(.editButtonTapped)
                        editToggle = true
                    } label: {
                        Text("프로필 수정")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(editToggle)
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if let image = selectedImage {
                if let imageData = image.jpegData(compressionQuality: 0.8) {    // JPEG 데이터로 이미지 변환
                    let base64Image = imageData.base64EncodedString()   // Base64 문자열로 인코딩... 
                                
                    
                    //store.send(.setImage(base64Image))        // 프로필 사진 서버로 전송하기
                }
            }
        }) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(store: Store(initialState: ProfileFeature.State(user: User(id: "1231231", name: "이창희"))) {
            ProfileFeature()
            ._printChanges()
        })
    }
}
