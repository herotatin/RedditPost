//
//  RedditPostVM.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import Foundation


class RedditPostVM : NSObject {
    
    private var apiService : APIService!
    private var posts: [RedditPost] = [RedditPost]()
    private(set) var postCellViewModels : [RedditPostCellViewModel]! {
        didSet {
            self.bindRedditPostVMToController()
        }
    }
    
    var bindRedditPostVMToController : (() -> ()) = {}
    var onErrorHandling : ((Error) -> Void)?
    
    override init() {
        super.init()
        self.apiService =  APIService()
        getRedditPostsData()
    }
    
    func getRedditPostsData() {
        self.apiService.getTopRedditPost() { [unowned self] result in
          switch result {
          case .success(let posts):
            self.processResponse(posts: posts)
          case .failure(let error):
            self.onErrorHandling?(error)
          }
        }
    }
    
    func createCellViewModel( post: RedditPost ) -> RedditPostCellViewModel {
        
       
        
        return RedditPostCellViewModel( authorText: post.author,
                                        createDateText: post.creationDate.timeAgoDisplay(),
                                       imageUrl: post.imageURL,
                                       thumbnailUrl: post.thumbnailURL,
                                       titleText: post.title,
                                       commentsText: "\(post.commentsCount) comments")
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> RedditPostCellViewModel {
        return postCellViewModels[indexPath.row]
    }
    
    private func processResponse( posts: [RedditPost] ) {
        self.posts = posts // Cache
        var postsViewModels = [RedditPostCellViewModel]()
        for post in posts {
            postsViewModels.append( createCellViewModel(post: post) )
        }
        self.postCellViewModels = postsViewModels
    }
}

struct RedditPostCellViewModel {
    let authorText: String
    let createDateText : String
    let imageUrl : String
    let thumbnailUrl : String
    let titleText: String
    let commentsText: String
}
