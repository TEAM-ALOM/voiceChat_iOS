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
        
        //NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        NavigationStack() {

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
                    
               
                //NavigationLink(state: LoginFeature.Path.State.mypageState(MypageFeature.State(isLoggedIn: store.isLoggedIn ,user: User(id: store.user?.id ?? "유저 아이디", name: store.user?.name ?? "유저 닉네임")))) {
                  
//                NavigationLink(state: MypageFeature.State(isLoggedIn: store.isLoggedIn, user: store.user)){
//                
//                }
//                
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
//        destination: { store in
//            MypageView(store: store)
//        }
        
//
//           .navigationDestination(isPresented: $store.isLoggedIn.sending(\.setIsLoggedIn)) {
//               //MainView()
//               MypageView(store: Store(initialState: MypageFeature.State(isLoggedIn: true, user: User(id: store.user?.id ?? "유저 아이디", name: store.user?.name ?? "유저 닉네임")
//                                                                       )){
//                   MypageFeature()
//
//           })
//           }
        
    }
    
    
}

#Preview {
    LoginView(store: Store(initialState: LoginFeature.State(isLoggedIn: false
                                                                )){
        LoginFeature()
            ._printChanges()
    })
    
}
