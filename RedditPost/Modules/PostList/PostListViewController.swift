//
//  ViewController.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import UIKit

class PostListViewController: UIViewController {
    
    @IBOutlet var postTableView: UITableView!
    
    private var redditPostVM : RedditPostVM!
        
    private var dataSource : RedditPostTableViewDataSource<RedditPostTableViewCell,RedditPostCellViewModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Reddit Top 50"
        self.postTableView.register(UINib(nibName: "RedditPostTableViewCell", bundle: nil), forCellReuseIdentifier: "RedditPostCell")
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        self.redditPostVM =  RedditPostVM()
        self.redditPostVM.onErrorHandling = { error in
            let alert = UIAlertController(title: "Oppss", message: "Something went wrong", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))

            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            
        }
        self.redditPostVM.bindRedditPostVMToController = {
           self.updateDataSource()
        }
    }
   
    func updateDataSource(){
            
        self.dataSource = RedditPostTableViewDataSource(cellIdentifier: "RedditPostCell", posts: self.redditPostVM.postCellViewModels, configureCell: { (cell, post) in
            cell.authorLabel.text = post.authorText
            cell.commentsLabel.text = post.commentsText
            cell.createdLabel.text = post.createDateText
            cell.descriptionLabel.text = post.titleText
            cell.postImageView.load(urlString: post.thumbnailUrl)
        })
        
        DispatchQueue.main.async {
            self.postTableView.dataSource = self.dataSource
            self.postTableView.reloadData()
        }
    }
    
}

extension PostListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell tapped")
    }
}


