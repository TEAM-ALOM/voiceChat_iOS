import ComposableArchitecture
import Combine
import Foundation

@Reducer
struct MypageFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var isLoggedIn: Bool
        var user: User?
        
        
    }
    
    
    enum Action {
        case logoutButtonTapped         // 로그아웃 버튼
        case logoutSuccess
        case logoutFailure(Error)
        
        case delegate(Delegate)
        enum Delegate {
            case dismissFormMainView
        }
        
    }
    
    @Dependency(\.kakaoAuth) var kakaoAuth   // 사용자 정의 모듈 kakaoAuth 의존성 주입
    @Dependency(\.googleAuth) var googleAuth // GoogleAuth 의존성 주입
    
    var body: some ReducerOf<Self> {
        
        Reduce {state, action in
            
            switch action {
                
                
            case .logoutButtonTapped:
                return .run { send in
                    
                    await kakaoAuth.kakaoLogout()
                    await googleAuth.googleLogout()
                    await send(.logoutSuccess)
                    
                }
                
            
            case .logoutSuccess:
                state.isLoggedIn = false
                state.user = nil
                return .send(.delegate(.dismissFormMainView))
                    
//                    .run { send in
//                    await send(.delegate(.confirmLogout))
//                    await self.dismiss()
//                    await send(.delegate(.dismissFormMainView))
//                  }
                
            case .logoutFailure:
                return .none
    
            case .delegate:
                return .none
            }
            
        }
    }
    
}
