//
//  MySceneDelegate.swift
//  AnitiatingApp
//
//  Created by 이창희 on 8/6/24.
//

import Foundation
import UIKit
import KakaoSDKAuth


class MySceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    

    class SceneDelegate: UIResponder, UIWindowSceneDelegate {
        
        func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if let url = URLContexts.first?.url {
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
        
    }
    
}
