//
//  AnitiatingAppApp.swift
//  AnitiatingApp
//
//  Created by 박근경 on 2024/07/23.
//

import SwiftUI
import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct AnitiatingAppApp: App {
    
    @UIApplicationDelegateAdaptor var appDelegate : MyAppDelegate
    
    var body: some Scene {
        
        WindowGroup {
           LoginView(store: Store(initialState: LoginFeature.State(isLoggedIn: false
                                                                       )){
               LoginFeature()
                   ._printChanges()
           })
            
        }
    }
}
