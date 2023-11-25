//
//  Posts.swift
//  WBDN
//
//  Created by Mason Kim on 11/26/23.
//

import Foundation

struct CreatePostDto: Codable {
    let contents: String
    let photo: Data
    
    let device: String
    let shutterSpeed: String?
    let editContents: String?
    let additionalContents: String?
    let latitude: Double?
    let longitude: Double?
    let shootingDate: String?
    let iso: String?
    let fnumber: String?
}

struct PostDetailResDto: Codable {
    let postId: Int
    let nickname: String
    let editContents: String?
    let additionalContents: String?
    let device: String
    let latitude: Double?
    let longitude: Double?
    let address: String?
    let shutterSpeed: String?
    let shootingDate: String?
    let photoUrl: String
    let like: Bool
    let iso: String?
    let fnumber: String?
}

struct PostListResDto: Codable {
    let memberId: Int
    let nickname: String
    let postListDtos: [Post]
}

struct Post: Codable {
    let postId: Int
    let nickname: String
    let photoUrl: String
    let likes: Int
}

struct PostLikeResDto: Codable {
    let memberId: Int
    let postId: Int
}