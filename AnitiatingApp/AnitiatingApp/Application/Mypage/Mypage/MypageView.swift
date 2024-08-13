import SwiftUI
import ComposableArchitecture

struct MypageView: View {
    
    let store: StoreOf<MypageFeature>
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            Text("로그인 성공")
            
            
            Text("\(store.isLoggedIn)")
            Text("\(store.user?.id)")
            Text("\(store.user?.name)")
            
        }
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
