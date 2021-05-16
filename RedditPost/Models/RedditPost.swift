//
//  RedditPost.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import Foundation
struct RedditPost {
    let id, title, author, imageURL, thumbnailURL : String
    let creationDate : Date
    let commentsCount: Int
    var read : Bool = false
}
