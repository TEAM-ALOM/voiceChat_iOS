import ComposableArchitecture
import Combine
import Foundation


struct User : Equatable {
    var id: String
    var name: String
    // 다른 사용자 정보들을 추가로 정의할 수 있습니다.
}

private enum KakaoAuthKey: DependencyKey {
    static var liveValue = KakaoAuth()
}
private enum GoogleAuthKey: DependencyKey {
    static var liveValue = GoogleAuth()
}

extension DependencyValues {
    var kakaoAuth: KakaoAuth {
        get { self[KakaoAuthKey.self] }
        set { self[KakaoAuthKey.self] = newValue }
    }
    var googleAuth: GoogleAuth {
        get { self[GoogleAuthKey.self] }
        set { self[GoogleAuthKey.self] = newValue }
    }
}

@Reducer
struct LoginFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoggedIn: Bool = false
        var user: User?
        
        //var path = StackState<Path.State>()

//        var path = StackState<MypageFeature.State>()



    }
    
    enum Action {
        case kakaoLoginButtonTapped
        case googleLoginButtonTapped // 구글 로그인 버튼 액션 추가
        case loginSuccess(User)
        case loginFailure(Error)
        
        case logoutButtonTapped         // 로그아웃 버튼
        case logoutSuccess
        case logoutFailure(Error)
        
        
        case setIsLoggedIn(Bool)    // 바인딩 위한
        
        //case path(StackAction<Path.State, Path.Action>)
       // case path(StackAction<MypageFeature.State, MypageFeature.Action>)

    }
    
    @Dependency(\.kakaoAuth) var kakaoAuth   // 사용자 정의 모듈 kakaoAuth 의존성 주입
    @Dependency(\.googleAuth) var googleAuth // GoogleAuth 의존성 주입

    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
                
            case .kakaoLoginButtonTapped:
                return .run { send in
                    await kakaoAuth.handleKakaoLogin()
                    
                    print("카카오 로그인 상태: \(kakaoAuth.isLoggedIn)")
                    if kakaoAuth.isLoggedIn {
                        await kakaoAuth.handleUserInfo()
                        if let user = kakaoAuth.kakaoUser {
                            await send(.loginSuccess(user))
                        } else {
                            await send(.loginFailure(NSError(domain: "UserInfoError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user info"])))
                        }
                    } else {
                        await send(.loginFailure(NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Login failed"])))
                    }
                }
                
            case let .loginSuccess(user):
                state.isLoggedIn = true
                state.user = user
                return .none
                
            case .loginFailure:
                return .none
                
                
                
            case .logoutSuccess:
                state.isLoggedIn = false
                state.user = nil
                return .none
                
            case .logoutFailure:
                return .none
                
                
                // 구글 로그인 버튼이 탭 되었을 때의 로직
            case .googleLoginButtonTapped:
                return .run { send in
                    await googleAuth.googleLogin()
                    
                    print("구글 로그인 상태: \(googleAuth.isLoggedIn)")
                    if googleAuth.isLoggedIn {
                        if let user = googleAuth.googleUser {
                            await send(.loginSuccess(user))
                        } else {
                            await send(.loginFailure(NSError(domain: "UserInfoError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user info"])))
                        }
                    } else {
                        await send(.loginFailure(NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Login failed"])))
                    }
                }
                
                
                
                
            case .logoutButtonTapped:
                return .run { send in
                    await googleAuth.googleLogout()
                    if !googleAuth.isLoggedIn {
                        await send(.logoutSuccess)
                    } else {
                        await send(.logoutFailure(NSError(domain: "LogoutError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Logout failed"])))
                    }
                    await kakaoAuth.kakaoLogout()
                    if !kakaoAuth.isLoggedIn {
                        await send(.logoutSuccess)
                    }
                }
                
                
            case let .setIsLoggedIn(isLoggedIn):
                state.isLoggedIn = isLoggedIn
                return .none
                
                
            
//            case .path:
//                return .none
//                
            }
            
        }
//        .forEach(\.path, action: \.path) {
//            MypageFeature()
//        }
        
    }
        
    
}
//
//// 네비게이션 스택 path 관련... 안됨
//extension LoginFeature {
//    
//    @Reducer
//    struct Path {
//        @ObservableState
//        enum State: Equatable {
//            case mypageState(MypageFeature.State)
//            // case captureImageScene(CaptureMedicinesReducer.State = .init())
//            
//        }
//        
//        enum Action {
//            case mypageAction(MypageFeature.Action)
//            
//        }
//        
//        var body: some ReducerOf<Self> {
//            Scope(state: \.mypageState, action: \.mypageAction) {
//                MypageFeature()
//            }
//            
//        }
//    }
//}
