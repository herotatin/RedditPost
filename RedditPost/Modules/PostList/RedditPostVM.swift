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
    private var nextPostId : String? = ""
    private(set) var postCellViewModels : [RedditPostCellViewModel]! {
        didSet {
            self.bindRedditPostVMToController()
        }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var isLoadingMore: Bool = false {
        didSet {
            self.updateLoadingMore?()
        }
    }
    
    var bindRedditPostVMToController : (() -> ()) = {}
    var onErrorHandling : ((Error) -> Void)?
    var updateLoadingStatus: (()->())?
    var updateLoadingMore: (()->())?
    
    override init() {
        super.init()
        self.apiService =  APIService()
        getRedditPostsData()
    }
    
    func getRedditPostsData() {
        self.isLoading = true
        self.apiService.getTopRedditPost() { [unowned self] result in
            self.isLoading = false
            
            switch result {
            case .success(let intermediateData):
                let posts = intermediateData.children.map({ $0.data }).map {
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
                    
                self.nextPostId = intermediateData.after
                self.processResponse(posts: posts )
            case .failure(let error):
                self.onErrorHandling?(error)
            }
        }
    }
    
    func getMoreRedditPostsData() {
        self.isLoadingMore = true
        self.apiService.getTopRedditPost(completion: { [unowned self] result in
            self.isLoadingMore = false
            
            switch result {
            case .success(let intermediateData):
                let posts = intermediateData.children.map({ $0.data }).map {
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
                self.nextPostId = intermediateData.after
                self.handleResponse(newPosts: posts )
            case .failure(let error):
                self.onErrorHandling?(error)
            }
        }, offSet : self.nextPostId)
    }
    
    func createCellViewModel( post: RedditPost ) -> RedditPostCellViewModel {
        

        return RedditPostCellViewModel( authorText: post.author,
                                        createDateText: post.creationDate.timeAgoDisplay(),
                                       imageUrl: post.imageURL,
                                       thumbnailUrl: post.thumbnailURL,
                                       titleText: post.title,
                                       commentsText: "\(post.commentsCount) comments",
                                       read : post.read)
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
    
    private func handleResponse( newPosts: [RedditPost] ){
        self.posts.append(contentsOf : newPosts)
        var postsViewModels = [RedditPostCellViewModel]()
        for post in posts {
            postsViewModels.append( createCellViewModel(post: post) )
        }
        self.postCellViewModels = postsViewModels
    }
    
    func postRead(position : Int) {
        self.posts[position].read = true
        self.postCellViewModels[position].read = true
    }
    
    func removePost(position : Int) {
        self.posts.remove(at: position)
        self.postCellViewModels.remove(at: position) 
    }
}

struct RedditPostCellViewModel {
    let authorText: String
    let createDateText : String
    let imageUrl : String
    let thumbnailUrl : String
    let titleText: String
    let commentsText: String
    var read : Bool
}
