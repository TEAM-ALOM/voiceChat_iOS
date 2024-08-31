//
//  ProfileImageView.swift
//  AnitiatingApp
//
//  Created by 이창희 on 8/17/24.
//

import SwiftUI
import URLImage     // url로 넘어오는 이미지 처리

// 유저 프사 
struct ProfileImageView: View {
    
    let imageUrl: URL
    
    var body: some View {
        
        
        URLImage(imageUrl) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .overlay(Circle().stroke(lineWidth: 0.5))
    }
}

#Preview {
    
    
    ProfileImageView(imageUrl: URL(string: "https://www.shutterstock.com/image-vector/snoopy-peanut-cartoon-vector-illustration-260nw-2449727009.jpg")!)
}
