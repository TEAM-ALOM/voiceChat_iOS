import ComposableArchitecture
import Combine
import Foundation
@Reducer
struct MainFeature {

    @ObservableState
    struct State: Equatable {
        var isLoggedIn: Bool
        var user: User?

        @Presents var mypage: MypageFeature.State?
    }

    enum Action {
        case mypageTabTapped
        case mypage(PresentationAction<MypageFeature.Action>)
        
        case chattingTabTapped
//        case mypage(PresentationAction<MypageFeature.Action>)
        
        case friendTabTapped
//        case mypage(PresentationAction<MypageFeature.Action>)
        
        
        case delegate(Delegate)

        enum Delegate {
            case confirmLogout
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .mypageTabTapped:
                
                // 1. 우선 다른 탭에서 썼던 자식 state 해제하기
                //state.friend = nil
                //state.chatting = nil
                
                
                // 마이페이지를 보여줄 때 mypage 상태를 설정
                state.mypage = MypageFeature.State(isLoggedIn: state.isLoggedIn, user: state.user)
                return .none

            case .mypage(.presented(.delegate(.dismissFormMainView))):
                // Mypage에서 로그아웃 성공 시 처리
                state.isLoggedIn = false
                state.user = nil
                return .run { send in
                    await send(.delegate(.confirmLogout))
                    await self.dismiss()
                }

            case .mypage:
                return .none

                
            case .chattingTabTapped:
                
                // 1. 우선 다른 탭에서 썼던 자식 state 해제하기
                state.mypage = nil
                //state.friend = nil

                return .none
                
            case .friendTabTapped:
                
                // 1. 우선 다른 탭에서 썼던 자식 state 해제하기
                state.mypage = nil
                //state.chatting = nil
                
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$mypage, action: \.mypage) {
            MypageFeature()
        }
    }
}
