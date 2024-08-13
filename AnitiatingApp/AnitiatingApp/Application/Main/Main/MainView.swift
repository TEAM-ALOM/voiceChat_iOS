import SwiftUI

struct MainView: View {
    var body: some View {
        
        TabView {
            
            Text("친구화면")
                .tabItem {
                    Image(systemName: "person")
                    Text("친구")
                }
            
            Text("채팅방 화면")
                .tabItem {
                    Image(systemName: "message")
                    Text("채팅")
                }
            
            //MypageView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("채팅")
                }
            
            
            
        }
        
        
        Text("로그인 성공!")
            .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    MainView()
}
