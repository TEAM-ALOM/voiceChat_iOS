//
//  MyAppDelegate.swift
//  AnitiatingApp
//
//  Created by 이창희 on 8/6/24.
//

import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn


class MyAppDelegate: UIResponder, UIApplicationDelegate {
    
    
    // ios SDK 초기화
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Kakao SDK 초기화
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        print("kakaoAppKey : \(kakaoAppKey)")
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
      
        // 구글
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
          if error != nil || user == nil {
            // Show the app's signed-out state.
          } else {
            // Show the app's signed-in state.
          }
        }
        
        return true
    }
    
    
    
    // 서비스 앱으로 돌아올 때 쓰일 커스텀 URL 스킴을 설정
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // 카카오
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
            
        // 구글
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        

            return false
    }
    
    // MyAppDelegate에서 MySceneDelegate 클래스를 사용하기 위해 configuration 설정 추가
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        
        // scene 세팅
        sceneConfiguration.delegateClass = MySceneDelegate.self
        
        return sceneConfiguration
    }
    
}
