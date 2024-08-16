import SwiftUI
import ComposableArchitecture

struct MypageView: View {
    
    let store: StoreOf<MypageFeature>
    
    var body: some View {
        VStack {
            
            HStack {
                Text("로그인 성공")
                Text(store.state.isLoggedIn ? "Logged In" : "Logged Out")
                if let user = store.state.user {
                    Text(user.id)
                    Text(user.name)
                }
            }
            
            List{
                Text("프로필 변경하기")
                Text("알림 설정")
                Text("차단유저 관리")
                
                
                Button {
                    store.send(.logoutButtonTapped)
                } label: {
                    Text("로그아웃")
                }
            }
            
            

            
        }
        .navigationTitle(store.user?.name ?? "???")
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
