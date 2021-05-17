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
       
        loadViewIfNeeded()
        postNameLabel.isHidden = false
        descriptionLabel.isHidden = false
        thumbnaiUIImage.isHidden = false
        postNameLabel.text = post?.authorText
        descriptionLabel.text = post?.titleText
        
        guard let hasImage = post?.thumbnailUrl else {
            return
        }
        thumbnaiUIImage.load(urlString: hasImage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        thumbnaiUIImage.isUserInteractionEnabled = true
        thumbnaiUIImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        guard let urlString = post?.imageUrl,  let url = URL(string: urlString) else {
          return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension PostDetailsViewController : PostSelectionDelegate {
    func postSelected(_ newPost: RedditPostCellViewModel) {
        self.post = newPost
    }
}
