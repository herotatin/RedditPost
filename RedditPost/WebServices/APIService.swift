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
    
    private let sourcesURL = URL(string: "https://www.reddit.com/top.json?limit=50")!
    
    func getTopRedditPost(completion : @escaping (Result<[RedditPost], Error>) -> ()){
        
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let error = error {
              return completion(.failure(error))
            }
            guard let data = data else {
              return completion(.failure(HTTPError.noData))
            }
          
            let redditPostsData = parseRedditPostFromJson(data)
            completion(redditPostsData)
            
        }.resume()
    }
    
}

fileprivate struct IntermediateRedditPost: Decodable {
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
  }
  let data: Data
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

