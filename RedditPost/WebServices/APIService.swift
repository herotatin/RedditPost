//
//  APIService.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import Foundation

enum HTTPError: Error {
    case transportError(Error)
    case serverSideError(Int)
    case noData
}


class APIService :  NSObject {
    
    private let baseStringURL = "https://www.reddit.com/"
    
    func getTopRedditPost(completion : @escaping (Result<IntermediateRedditPost.Data, Error>) -> (), offSet: String? = nil){
        var getPostStringURL = "\(baseStringURL)top.json?limit=50"
        
        if ((offSet) != nil && offSet != "") {
            getPostStringURL.append("?after=\(offSet!)")
        }
        print(getPostStringURL)
        let postURL = URL(string: getPostStringURL)!
        URLSession.shared.dataTask(with: postURL) { (data, urlResponse, error) in
            if let error = error {
              return completion(.failure(error))
            }
            guard let data = data else {
              return completion(.failure(HTTPError.noData))
            }
          
//            let redditPostsData = parseRedditPostFromJson(data)
            let redditPostResponse = parseRedditResponseFromJson(data)
            completion(redditPostResponse)
            
        }.resume()
    }
    
}

struct IntermediateRedditPost: Decodable {
    struct Data: Decodable {
      struct Children: Decodable {
        struct Data: Decodable {
          var id: String
          var title: String
          var created_utc: Double
          var num_comments: Int
          var author: String
          var thumbnail: String
          var url: String
        }
        let data: Data
      }
      let children: [Children]
      let after : String?
      let before : String?
    }
    let data: Data
}

fileprivate func parseRedditResponseFromJson(_ data: Data) -> Result<IntermediateRedditPost.Data, Error> {
  return Result {
    try JSONDecoder().decode(IntermediateRedditPost.self, from: data).data
  }
}

fileprivate func parseRedditPostFromJson(_ data: Data) -> Result<[RedditPost], Error> {
  return Result {
    try JSONDecoder().decode(IntermediateRedditPost.self, from: data).data.children.map({ $0.data }).map {
      return RedditPost(
        id: $0.id,
        title: $0.title,
        author: $0.author,
        imageURL : $0.url,
        thumbnailURL : $0.thumbnail,
        creationDate: Date(timeIntervalSince1970: $0.created_utc),
        commentsCount: $0.num_comments
      )
    }
  }
}

