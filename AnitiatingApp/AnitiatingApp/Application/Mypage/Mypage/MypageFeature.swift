import ComposableArchitecture
import Combine
import Foundation

@Reducer
struct MypageFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var isLoggedIn: Bool
        var user: User?
        
        //@Presents var profile: ProfileFeature.State?  // 변경내용을 마이페이지 뷰에 보여주도록 하지 않고 변경내용을 단순하게 서버로 보내 DB를 update히고
                                            //마이페이지로 onAppear 때마다 API 통신을 통해 뷰에 보여지도록 만들기

    }
    
    
    enum Action {
        case logoutButtonTapped         // 로그아웃 버튼
        case logoutSuccess
        case logoutFailure(Error)
        
        case resignButtonTapped         // 탈퇴 버튼
        case resignSuccess
        
        case blockedUserButtonTapped     // 차단 유저 관리
        
        case profileButtonTapped
        
        case delegate(Delegate)
        enum Delegate {
            case dismissFormMainView
        }
        
        //case profile(PresentationAction<ProfileFeature.Action>)

        
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
          
                
            case .logoutFailure:
                return .none
    
            case .resignButtonTapped:
                return .run { send in
                    
                    // 추후 여기에 우리 서비스에 대한 탈퇴를 작성하기 (DB 삭제 요청 보내기 등...)
                    
                    await kakaoAuth.kakaoResign()
                    
                    await send(.resignSuccess)
                }
                
            
            case .resignSuccess:
                state.isLoggedIn = false
                state.user = nil
                return .send(.delegate(.dismissFormMainView))
                    
           
            
            case .blockedUserButtonTapped:
                return .none
                
            case .profileButtonTapped:
                // 초기화
                //state.profile = ProfileFeature.State(user: state.user!)
                return .none
                
    
                
//            case .profile(.presented(.delegate(.cancel))):
//                state.profile = nil // 자식 해제
//                return .none
//                
//            case let .profile(.presented(.delegate(.saveEdit(user)))):
//                
//                print("!@#!@#!@#")
//                print("!@#!@#!@#")
//                
//                state.user = user
//                state.profile = nil
//                return .none
//                
//            case .profile:
//                return .none
            
            case .delegate:
                return .none
            }
            
        }
//        .ifLet(\.$profile, action: \.profile) {
//            ProfileFeature()
//        }
        
        
    }
    
}
