import SwiftUI
import ComposableArchitecture


enum Tab {
    case friend, chat, myPage
}

struct MainView: View {
    
    @Bindable var store: StoreOf<MainFeature>

    
    @State private var selectedTab: Tab = .friend

    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            Text("친구화면")
                .tabItem {
                    Image(systemName: "person")
                    Text("친구")
                }
                .tag(Tab.friend)
            
            Text("채팅방 화면")
                .tabItem {
                    Image(systemName: "message")
                    Text("채팅")
                }
                .tag(Tab.chat)

            
            IfLetStore(
                self.store.scope(state: \.$mypage, action: MainFeature.Action.mypage),
                then: { mypageStore in
                    MypageView(store: mypageStore)
                },
                else: {
                    Text("로그인이 필요합니다.")
                }
                )
                .tabItem {
                    Image(systemName: "person.2")
                    Text("마이페이지")
                }
                .tag(Tab.myPage)
            
            
            
        }
        .onChange(of: selectedTab) { newValue in
                handleTabSelection(tab: newValue)
        }
        
        
                .navigationBarBackButtonHidden(true) 

    }
    
    private func handleTabSelection(tab: Tab) {
            switch tab {
            case .friend:
                print("친구 탭 선택됨")
            case .chat:
                print("채팅 탭 선택됨")
            case .myPage:
                print("마이페이지 탭 선택됨")
                store.send(.mypageTabTapped)
            }
        }
}

#Preview {
    
    
    NavigationStack {
        MainView(store: Store(initialState: MainFeature.State(isLoggedIn: true, user: User(id: "1231231", name: "이창희")
                                                             )){
            MainFeature()
                ._printChanges()
        })
        
    }
}
