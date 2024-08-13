//
//  GoogleTest.swift
//  AnitiatingApp
//
//  Created by 이창희 on 8/9/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


struct UserData {
    let url:URL?
    let name:String
    let email:String
    
    
    init(url: URL?, name: String, email: String) {
        self.url = url
        self.name = name
        self.email = email
    }
}

struct GoogleTest: View {
    // 로그인 상태
       @State private var isLogined = false
       // 유저 데이터
       @State private var userData: UserData
       // 팝업용
       @State private var isAlert = false
       
       public init(isLogined: Bool = false, userData: UserData) {
           _isLogined = State(initialValue: isLogined)
           _userData = State(initialValue: userData)
       }
       
       var body: some View {
           NavigationStack {
               ZStack {
                   GoogleSignInButton(
                       scheme: .light,
                       style: .wide,
                       action: {
                           googleLogin()
                       })
                   .frame(width: 300, height: 60, alignment: .center)
               }
               
           }
           .onAppear(perform: {
               // 로그인 상태 체크
               checkState()
           })
           .alert(LocalizedStringKey("로그인 실패"), isPresented: $isAlert) {
               Text("확인")
           } message: {
               Text("다시 시도해주세요")
           }
       }
       // 상태 체크
       func checkState() {
           GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
               if error != nil || user == nil {
                   // 로그아웃 상태
                   print("Not Sign In")
               } else {
                   // 로그인 상태
                   guard let profile = user?.profile else { return }
                   let data = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
                   userData = data
                   isLogined = true
                   print(isLogined)
               }
           }
       }
       // 구글 로그인
       func googleLogin() {
           // rootViewController
           guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
           // 로그인 진행
           GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
               guard let result = signInResult else {
                   isAlert = true
                   return
               } // 프로필 이미지, 이메일 이름 가져오기
               guard let profile = result.user.profile else { return }
               let data = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
               userData = data
               isLogined = true
               print(userData)
           }
       }
}

#Preview {
    GoogleTest(userData: UserData(url: nil, name: "", email: ""))
}
