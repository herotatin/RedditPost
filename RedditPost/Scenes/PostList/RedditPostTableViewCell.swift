//
//  RedditPostTableViewCell.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import UIKit

protocol PostCellDelegate {
    func didPressDismiss(_ postId: Int)
}


class RedditPostTableViewCell: UITableViewCell {
   
    @IBOutlet var unreadStatus: UIView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var createdLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dismissBtn: UIButton!
    @IBOutlet var commentsLabel: UILabel!
    var post: RedditPostCellViewModel?
    
    var onDismiss: () -> Void = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func dismissMe(_ sender: UIButton) {
        onDismiss()
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
