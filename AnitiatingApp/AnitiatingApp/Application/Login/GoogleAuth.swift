//
//  GoogleAuth.swift
//  AnitiatingApp
//
//  Created by 이창희 on 8/6/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

class GoogleAuth: ObservableObject {
    
//    @Published var isLoggedIn: Bool =
    @Published var isLoggedIn: Bool = false
    var googleUser: User?
   
    
    @MainActor
    func googleLogin() async {
        
            isLoggedIn = await handleGoogleLogin()
    }
    
    @MainActor
    func googleLogout() async {
        
            // 로그아웃 성공
            if await handleGoogleLogout() == true {
                isLoggedIn = false
            }
            else {
                isLoggedIn = true
            }
        
    }
    
    @MainActor
    func checkState() async {
        
            if await handleCheckState() == true {
                isLoggedIn = true
                print("구글 로그인 상태")
            }
            else {
                isLoggedIn = true
                print("구글 로그아웃 상태")
            }
        
    }
    
    // 구글 로그인
    func handleGoogleLogin() async -> Bool {
        
        await withCheckedContinuation { continuation in
            // rootViewController
            guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { isLoggedIn = false; return }
            
            // 로그인 진행
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
                
                // 에러
                guard let result = signInResult else {
                    print("구글 로그인 실패")
                    self.isLoggedIn = false
                    continuation.resume(returning: false)
                    return
                }
                // 성공: 프로필 이미지, 이메일 이름 가져오기
                print("구글 로그인 성공")
                guard let profile = result.user.profile else { return }
                let data = User(id: profile.email, name: profile.name)
                //let data = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
                self.googleUser = data
                print(self.googleUser ?? "정보가져오기 실패")
                continuation.resume(returning: true)
            }
        }
    }
    
    
    // 로그아웃 처리
    func handleGoogleLogout() async -> Bool {
        await withCheckedContinuation { continuation in
            GIDSignIn.sharedInstance.signOut()
            print("구글 로그아웃 성공")
            continuation.resume(returning: true)
        }
    }
    
    // 상태 체크
    func handleCheckState() async -> Bool {
        
        await withCheckedContinuation { continuation in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error != nil || user == nil {
                    // 로그아웃 상태
                    
                    print("구글 로그아웃 상태")
                    continuation.resume(returning: false)

                } else {
                    // 로그인 상태
                    guard let profile = user?.profile else { return }
                    let data = User(id: profile.email, name: profile.name)
                    self.googleUser = data
                    print("구글 로그인 상태")
                    continuation.resume(returning: true)

                }
            }
        }
    }
    
    
}

//
//struct GoogleAuthView: View {
//    // 로그인 상태
//    @StateObject var googleAuth : GoogleAuth = GoogleAuth()
//    
//    let loginStateInfo : (Bool) -> String = { isLoggedIn in
//        return isLoggedIn ? "로그인 상태" : "로그아웃 상태"
//    }
//       
//    var body: some View {
//        VStack {
//            
//            Text(loginStateInfo(googleAuth.isLoggedIn))
//                .padding()
//            
//            GoogleSignInButton(
//                scheme: .light,
//                style: .wide,
//                action: {
//                    googleAuth.googleLogin()
//                })
//            .frame(width: 300, height: 60, alignment: .center)
//            
//            Button {
//                googleAuth.googleLogout()
//            } label: {
//                Text("로그아웃 버튼")
//            }
//
//        }
//        
//    }
//}
