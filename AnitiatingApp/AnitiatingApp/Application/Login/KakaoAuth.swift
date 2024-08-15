//
//  KakaoAuth.swift
//  AnitiatingApp
//
//  Created by 이창희 on 8/6/24.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon


class KakaoAuth: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    var kakaoUser: User?
    
    // 로그인 호출
    @MainActor
    func handleKakaoLogin() async {
        if (UserApi.isKakaoTalkLoginAvailable()) {  // 설치 되어 있을 때
            isLoggedIn = await handleLoginWithKakaoTalkApp()
        } else {                                    // 설치 안되어 있을 때
            isLoggedIn = await handleLoginWithKakaoAccount()
        }
    }
    
    // 로그아웃 호출
    @MainActor
    func kakaoLogout() async {
        if await handleKakaoLogout() {
            isLoggedIn = false
        }
    }
    
    // 카카오 앱을 통해 로그인
    func handleLoginWithKakaoTalkApp() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    print("카카오톡으로 로그인 성공")
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // 카카오 계정을 직접 입력해서 로그인
    func handleLoginWithKakaoAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    print("카카오게정으로 로그인 성공")
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // 로그아웃 처리
    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.logout { (error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    print("kakao 로그아웃 성공")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // 회원정보 가져오기
    func handleUserInfo() async {
        await withCheckedContinuation { continuation in
            UserApi.shared.me { (user, error) in
                if let error = error {
                    print(error)
                    print("사용자 정보 가져오기 실패")
                    continuation.resume()
                } else {
                    print("사용자 정보 가져오기 성공")
                    guard let id = user?.id, let name = user?.kakaoAccount?.profile?.nickname else {
                        continuation.resume()
                        return
                    }
                    //do something
                    
                    self.kakaoUser = User(id: String(id), name: name)
                    
                    _ = user
                    continuation.resume()
                }
            }
        }
    }
}
