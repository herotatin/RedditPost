//
//  RedditPostVM.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import Foundation


class RedditPostVM : NSObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case state
    }
      
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(state, forKey: .state)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        state = try container.decode(State.self, forKey: .state)
    }
    
    private var apiService : APIService!
    private var nextPostId : String? = ""
    private var posts: [RedditPost] = [RedditPost]()
    
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
    
    private(set) var state = State(posts: []) {
        didSet {
            self.callback?(state)
        }
    }
    
    var callback: ((State) -> ())?
    var onErrorHandling : ((Error) -> Void)?
    var updateLoadingStatus: (()->())?
    var updateLoadingMore: (()->())?
  
    override init() {
        self.apiService =  APIService()
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
    
    func getCellViewModel( at indexPath: IndexPath ) -> RedditPostCellViewModel {
        return state.postCellViewModels[indexPath.row]
    }
    
    private func createCellViewModel( post: RedditPost ) -> RedditPostCellViewModel {
        
        let image = post.imageURL
        let replacedImg = image.replacingOccurrences(of: ".gifv", with: ".gif")

        return RedditPostCellViewModel( authorText: post.author,
                                        createDateText: post.creationDate.timeAgoDisplay(),
                                       imageUrl: replacedImg,
                                       thumbnailUrl: post.thumbnailURL,
                                       titleText: post.title,
                                       commentsText: "\(post.commentsCount) comments",
                                       read : post.read)
    }
    
    private func processResponse( posts: [RedditPost] ) {
        self.posts = posts // Cache
        var postsViewModels = [RedditPostCellViewModel]()
        for post in posts {
            postsViewModels.append( createCellViewModel(post: post) )
        }
        self.state.updateAction = .refresh(postsViewModels)
    }
    
    private func handleResponse( newPosts: [RedditPost] ){
        self.posts.append(contentsOf : newPosts)
        var postsViewModels = [RedditPostCellViewModel]()
        for post in posts {
            postsViewModels.append( createCellViewModel(post: post) )
        }
        self.state.updateAction = .refresh(postsViewModels)
    }
    
    func postRead(position : Int) {
        state.updateAction = .update(IndexPath(row: position, section: 0))
    }
    
    func removePost(_ post : RedditPostCellViewModel) {
        guard let indexPath = self.state.postCellViewModels.firstIndex(of: post).map({ IndexPath(row: $0, section: 0) }) else {
          return
        }
        state.updateAction = .delete(indexPath)
    }
    
    func removeAll(){
        self.state.updateAction = .deleteAll
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

extension RedditPostCellViewModel : Codable {
    enum CodingKeys: String, CodingKey {
        case author
        case created
        case image
        case thumbnail
        case title
        case comments
        case read
     }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(authorText, forKey: .author)
        try container.encode(createDateText, forKey: .created)
        try container.encode(imageUrl, forKey: .image)
        try container.encode(thumbnailUrl, forKey: .thumbnail)
        try container.encode(titleText, forKey: .title)
        try container.encode(commentsText, forKey: .comments)
        try container.encode(read, forKey: .read)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        authorText = try container.decode(String.self, forKey: .title)
        createDateText = try container.decode(String.self, forKey: .created)
        imageUrl = try container.decode(String.self, forKey: .image)
        thumbnailUrl = try container.decode(String.self, forKey: .thumbnail)
        titleText = try container.decode(String.self, forKey: .title)
        commentsText = try container.decode(String.self, forKey: .comments)
        read = try container.decode(Bool.self, forKey: .read)

    }
}

extension RedditPostCellViewModel: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.titleText == rhs.titleText
  }
}

struct State {
    enum EditingAction {
        case update(IndexPath)
        case delete(IndexPath)
        case deleteAll
        case refresh([RedditPostCellViewModel])
    }
    
    var postCellViewModels: [RedditPostCellViewModel]

    var updateAction: EditingAction {
        didSet {
            switch updateAction {
            case let .refresh(posts):
                postCellViewModels = posts
            case let .delete(indexPath):
                postCellViewModels.remove(at: indexPath.row)
            case let .update(indexPath):
                if ( !postCellViewModels[indexPath.row].read) {
                    postCellViewModels[indexPath.row].read = true
                }
            case .deleteAll:
                self.postCellViewModels.removeAll()
            }
        }
    }
    
    init(posts: [RedditPostCellViewModel]) {
        self.postCellViewModels = posts
        self.updateAction = .refresh(posts)
    }
}

extension State : Codable {
    enum CodingKeys: String, CodingKey {
        case postCellViewModels
        case updateAction
    }
      
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(postCellViewModels, forKey: .postCellViewModels)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postCellViewModels = try container.decode([RedditPostCellViewModel].self, forKey: .postCellViewModels)
        updateAction = .refresh(postCellViewModels)
    }
}
