import SwiftUI
import ComposableArchitecture
import URLImage     // url로 넘어오는 이미지 처리

struct MypageView: View {
    
    let store: StoreOf<MypageFeature>
    
    
    
    var body: some View {
        VStack {
            
            if let user = store.state.user {
                
                HStack{
                    URLImage(URL(string: user.profile)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(lineWidth: 0.5))
                        
                    VStack(alignment:.leading) {
                        Text("\(user.name)")
                            .font(.title)
                            .bold()
                            .lineLimit(1)
                        
                        Text("\(user.coment)")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                    }
                }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: 100, alignment: .leading)
                    .padding()
            }
                //.onAppear()    // 유저 정보 API 통신 
            
            
            List{
                
                NavigationLink(state: LoginFeature.Path.State.profileScene(ProfileFeature.State(user: store.user!))){
                    //NavigationLink(state: self.store.scope(state: \.$profile, action: MypageFeature.Action.profile)){
                    
                   
                    
                    Button {
                        store.send(.profileButtonTapped)
                    } label: {
                        Text("프로필 변경하기")
                    }
                }
               
                
                Text("알림 설정")
                
                // 리스트로 가기 
                NavigationLink(state: LoginFeature.Path.State.userBlockScene(UserBlockFeature.State())){
                
                    Button {
                        store.send(.blockedUserButtonTapped)
                    } label: {
                        Text("차단유저 관리")
                    }
                }

                
                
                Button {
                    store.send(.logoutButtonTapped)
                } label: {
                    Text("로그아웃")
                }
                
                Button {
                    store.send(.resignButtonTapped)
                } label: {
                    Text("회원탈퇴")
                        .foregroundColor(.red)
                }
                
            }
            
            
            HStack {
                Text("로그인 성공")
                Text(store.state.isLoggedIn ? "Logged In" : "Logged Out")
                if let user = store.state.user {
                    Text(user.id)
                    Text(user.name)
                }
            }

            
        }
        //.navigationTitle(store.user?.name ?? "???")
    }
}


#Preview {
    
    NavigationStack {
        MypageView(store: Store(initialState: MypageFeature.State(isLoggedIn: true, user: User(id: "1231231", name: "이창희")
                                                                )){
            MypageFeature()
            ._printChanges()
    })
        
    }
    
    
}
