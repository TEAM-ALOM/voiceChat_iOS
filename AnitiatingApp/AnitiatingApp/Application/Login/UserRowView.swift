//
//  UserRowView.swift
//  AnitiatingApp
//
//  Created by 이창희 on 8/17/24.
//

import SwiftUI

// 유저 프로필 row
struct UserRowView: View {
    
    var user : BlockedUser      // 일단 BlockedUser로 테스트중
    
    
    
    var body: some View {
        
        HStack {
            
            ProfileImageView(imageUrl: URL(string: user.profile)!)
            
            
            VStack(alignment:.leading) {
                Text("\(user.name)")
                    .font(.body)
                    .font(.system(size: 25))
                    .lineLimit(1)
                
                Text("\(user.coment)")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .font(.system(size: 17))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                
            }
            
               
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .leading)
   //     .padding(.vertical)
        
        
        
        
    }
}

#Preview {
    UserRowView(user: BlockedUser(name: "이창희", profile: "https://www.shutterstock.com/image-vector/snoopy-peanut-cartoon-vector-illustration-260nw-2449727009.jpg", coment: "암ㄴㅇㅁㄴㅇ어렵...", id: "1234124"))
}
