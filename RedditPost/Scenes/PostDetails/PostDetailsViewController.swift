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
    @IBOutlet var btnDownloadImage: UIButton!
    
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
        
        guard let hasThumbnail = post?.thumbnailUrl else {
            return
        }
        thumbnaiUIImage.load(urlString: hasThumbnail)
        guard let hasImage = post?.imageUrl else {
            return
        }
        print("Image", hasImage)
        btnDownloadImage.isHidden = false
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
    
    
    @IBAction func downloadImage(_ sender: Any) {
        guard let hasImage = thumbnaiUIImage.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(hasImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var alert : UIAlertController!
        
        if let error = error {
            print("ERROR: \(error)")
            alert = self.createConfirmationAlert("Image not saved", "Unexpected error saving the post iamge")
        }
        alert = self.createConfirmationAlert("Image saved", "Image was saved on your gallery")
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

extension PostDetailsViewController : PostSelectionDelegate {
    func postSelected(_ newPost: RedditPostCellViewModel) {
        self.post = newPost
    }
}

extension PostDetailsViewController {
    override func encodeRestorableState(with coder: NSCoder) {
        do {
            let encodedVM = try PropertyListEncoder().encode(post)
            coder.encode(encodedVM, forKey: "redditPost")
        } catch {
            print("Save Failed")
        }
        super.encodeRestorableState(with: coder)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        guard let model = coder.decodeObject(forKey: "redditPost") as? RedditPostCellViewModel else {
            return
        }
        self.post = model
    }
}
