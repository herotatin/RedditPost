//
//  RedditPostTableViewCell.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import UIKit

class RedditPostTableViewCell: UITableViewCell {
   
    @IBOutlet var unreadStatus: UIView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var createdLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dismissBtn: UIButton!
    @IBOutlet var commentsLabel: UILabel!
    
    var onDismiss: () -> Void = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func dismissMe(_ sender: UIButton) {
        onDismiss()
    }
    
}
