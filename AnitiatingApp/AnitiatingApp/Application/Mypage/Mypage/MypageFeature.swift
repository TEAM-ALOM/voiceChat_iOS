import ComposableArchitecture
import Combine
import Foundation

@Reducer
struct MypageFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoggedIn: Bool 
        let user: User?
    }
    
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce {state, action in
            
            switch action {
                
                
                
                
            }
            
        }
        
    }
    
    
    
}
