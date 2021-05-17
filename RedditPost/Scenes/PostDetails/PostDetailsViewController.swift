//
//  PostDetailsViewController.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 16/05/21.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    @IBOutlet var postNameLabel: UILabel!
    @IBOutlet var thumbnaiUIImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    var post: RedditPostCellViewModel? {
      didSet {
        refreshUI()
      }
    }
    
    private func refreshUI() {
        postNameLabel.isHidden = false
        descriptionLabel.isHidden = false
        thumbnaiUIImage.isHidden = false
        
        loadViewIfNeeded()
        postNameLabel.text = post?.authorText
        descriptionLabel.text = post?.titleText
        
        guard let hasImage = post?.thumbnailUrl else {
            return
        }
        thumbnaiUIImage.load(urlString: hasImage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension PostDetailsViewController : PostSelectionDelegate {
    func postSelected(_ newPost: RedditPostCellViewModel) {
        self.post = newPost
    }
}
