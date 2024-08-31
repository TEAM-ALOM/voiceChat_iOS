import ComposableArchitecture
import Combine
import Foundation


// 차단유저 model 임시...
// MARK: - UserElement
struct BlockedUser: Codable, Equatable, Identifiable {
    let name: String
    let profile: String
    let coment, id: String
}

// typealias BlockedUsers = [BlockedUser]

struct BlockedUserClient {
    var fetchBlockedUsers: () async throws -> [BlockedUser]
}

private enum BlockedUserClientKey: DependencyKey {
    
    static let liveValue = BlockedUserClient(
        fetchBlockedUsers: {
            
            let url = URL(string: "https://66a1e631967c89168f1df3bb.mockapi.io/user")!   //  mock API 로 랜덤한 유저가 잘 출력되나 확인
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return try JSONDecoder().decode([BlockedUser].self, from: data)
            
        }
    )
    
}

extension DependencyValues {
    var blockedUserClient: BlockedUserClient {
        get { self[BlockedUserClientKey.self] }
        set { self[BlockedUserClientKey.self] = newValue }
    }
    
}


@Reducer
struct UserBlockFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var isLoading: Bool = false
        var user: User?
        
        var blockedUsers: [BlockedUser] = []
        var errorMessage: String?
        
        
        
    }
    
    
    enum Action {
        
        case fetchBlockedUsers
        case blockedUsersResponse(TaskResult<[BlockedUser]>)
        
        case deleteBlockedUser(IndexSet)

    }
    
    @Dependency(\.blockedUserClient) var blockedUserClient
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerOf<Self> {
        
        Reduce {state, action in
            
            switch action {
                
            
            case .fetchBlockedUsers:
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    let result = await TaskResult { try await blockedUserClient.fetchBlockedUsers() }
                    await send(.blockedUsersResponse(result), animation: .default)
                }

                
            case let .blockedUsersResponse(.success(blockedUsers)):
                state.isLoading = false
                state.blockedUsers = blockedUsers
                return .none
                
            case let .blockedUsersResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = "API 통신 오류: \(error)"
                return .none
                
                
            case let .deleteBlockedUser(indexSet):
                
                state.blockedUsers.remove(atOffsets: indexSet)  // onAppear 이라서 따로 state값 삭제는 안해도 될지도..
                
                return .none       // 이곳에다가 삭제 요청 보내는 코드 작성
                
            }
            
        }
    }
    
}

