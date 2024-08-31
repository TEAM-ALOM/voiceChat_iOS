import SwiftUI
import ComposableArchitecture

struct UserBlockView: View {
    
    let store: StoreOf<UserBlockFeature>
    @State private var searchText: String = ""
    
    
    var searchResults: [BlockedUser] {
        // array가 emty라면 names 어레이의 데이터들이 추천 키워드로 출력, 빈 array인 []로 리턴시, 비어있는채로 출력됨
        
        if searchText.isEmpty {
            return store.blockedUsers
        } else {
            return store.blockedUsers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        let state = store.state
        
        VStack {
            
            // 차단친구 로딩중일떄
            if state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let errorMessage = state.errorMessage {   //
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(searchResults) { user in
                    
                    ForEach(searchResults) { user in
                        HStack {
                            UserRowView(user: user)
                            Button {
                                
                            } label: {
                                Text("삭제")
                            }

                        }
                        
                    }
                    
                    .onDelete { indexSet in
                        store.send(.deleteBlockedUser(indexSet))
                    }
                    
                }
                .listStyle(.plain)
                .searchable(text: $searchText, prompt: "현재 차단된 유저 찾기.")
                
            }
        }
        .navigationTitle("차단된 친구")
        .onAppear {
            store.send(.fetchBlockedUsers)
        }
        
    }
}


#Preview {
    
    NavigationStack {
        UserBlockView(store: Store(initialState: UserBlockFeature.State()){
         
            UserBlockFeature()
                ._printChanges()
            
        })
    }
    
}
