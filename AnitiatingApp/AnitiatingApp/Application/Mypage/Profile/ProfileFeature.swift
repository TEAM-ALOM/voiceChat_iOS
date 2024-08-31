
import ComposableArchitecture
import Combine
import Foundation

@Reducer
struct ProfileFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var user: User
        var originalUser: User? // 원본 상태를 저장하기 위한 변수 추가

    }
    
    
    enum Action {
       
        case editButtonTapped
        
        
        case setName(String)
        case setComent(String)
        case setImage(String)
        
        case saveButtonTapped  // 저장 버튼 액션 추가
        case saveSuccess       // 저장 성공 액션
        //case saveFailure(Error) // 저장 실패 액션
        
        case cancelButtonTapped
        
        case delegate(Delegate)
        enum Delegate: Equatable {
              case cancel
              case saveEdit(User)
        }
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce {state, action in
            
            switch action {
                
            case .editButtonTapped:
                state.originalUser = state.user
                return .none
                
           
                
            case let .setName(name):
                state.user.name = name
                return .none
                
            case let .setComent(coment):
                state.user.coment = coment
                return .none
                
            case let .setImage(image):
                state.user.profile = image
                return .none
                
            case .delegate:
                return .none
                
            case .saveButtonTapped:     // 여기서 수정하는거 서버 통신
                
                return .none
                //return .send(.delegate(.saveEdit(state.user)))
             
            case .cancelButtonTapped:
                if let originalUser = state.originalUser {
                    state.user = originalUser
                }
                return .none
                //return .send(.delegate(.cancel))
                
            case .saveSuccess:
                return .none
                
            
            }
            
        }
    }
    
}

