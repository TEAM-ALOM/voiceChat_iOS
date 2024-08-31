import SwiftUI
import GoogleSignIn
import ComposableArchitecture
import GoogleSignInSwift


struct LoginView: View {
    
    @Bindable var store: StoreOf<LoginFeature>

//    init(store: StoreOf<LoginFeature>) {
//            self.store = store
//        }
    
    var body: some View {
        
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {

            VStack(spacing:20) {
                
                Text("로고")
                    .frame(width: 100, height: 100)
                    .background(.blue)
                    .padding(.top, 20)
                
                    
                VStack(spacing:0) {
                    Text("로그인")
                        .font(.title)
                        
                    Text("로그인 방식을 선택하세요.")
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                .padding(25)
                    
               

               
                // 카카오톡 로그인
                    Button {
                        store.send(.kakaoLoginButtonTapped)
                    } label: {
                        Image("kakaoLogin")
                            .resizable()
                            .frame(width: 300,height: 45)
                    }
                
                
                
                // 구글 로그인
                GoogleSignInButton(scheme: .light, style: .wide, action: { store.send(.googleLoginButtonTapped) })
                  .frame(width: 300, height: 60, alignment: .center)
                  .cornerRadius(6.0)
                
                
                    
                Button {
                   // 애플로그인
                } label: {
                    Text("애플 로그인 배포 직전 구현 예정")
                        .frame(width: 300,height: 45)
                        .foregroundColor(.white)
                        .background(.black)
                }
                
                
                
                Button("로그아웃", action: {store.send(.logoutButtonTapped)})
                
                Divider()
                    .padding()
                
                Text("로그인 구현")
                Text("\(store.isLoggedIn)")
                Text("\(store.user?.id ?? "유저 아이디")")
                Text("\(store.user?.name ?? "유저 닉네임")")
                
            }
            
   
            
        }
        
        destination: { store in
            
            switch store.state {
            case .mainScene:
                if let store = store.scope(state: \.mainScene, action: \.mainAction) {
                    MainView(store: store)
                }
                
            case .mypageScene:
                if let store = store.scope(state: \.mypageScene, action: \.mypageAction) {
                    MypageView(store: store)
                }
                
            case .userBlockScene:
                if let store = store.scope(state: \.userBlockScene, action: \.userBlockAction) {
                    UserBlockView(store: store)
                }
                
            case .profileScene:
                if let store = store.scope(state: \.profileScene, action: \.profileAction){
                    ProfileView(store: store)
                }
                
            }
        }
        
    }
    
    
}

#Preview {
    LoginView(store: Store(initialState: LoginFeature.State(isLoggedIn: false
                                                                )){
        LoginFeature()
            ._printChanges()
    })
    
}
