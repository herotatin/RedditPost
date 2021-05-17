//
//  ViewController.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import UIKit


protocol PostSelectionDelegate: class {
  func postSelected(_ newPost: RedditPostCellViewModel)
}

class PostListViewController: UIViewController {
    
    @IBOutlet var postTableView: UITableView!
    
    private var redditPostVM : RedditPostVM!
    private let refreshControl = UIRefreshControl()
    private let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    weak var selectionDelegate: PostSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Reddit Top 50"
        self.postTableView.register(UINib(nibName: "RedditPostTableViewCell", bundle: nil), forCellReuseIdentifier: "RedditPostCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading posts")
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        postTableView.refreshControl = refreshControl
        
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: postTableView.bounds.width, height: CGFloat(44))
        spinner.color = UIColor.orange
        self.postTableView.tableFooterView = spinner
        self.postTableView.tableFooterView?.isHidden = false
        
        callToViewModelForUIUpdate()
        postTableView.delegate = self
        postTableView.dataSource = self
        
        splitViewController?.delegate = self
    }
    
    @objc func refreshPosts(refreshControl: UIRefreshControl) {
        redditPostVM.getRedditPostsData()
    }
    
    func callToViewModelForUIUpdate(){
        self.redditPostVM =  RedditPostVM({ [unowned self] (state) in
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.refreshControl.endRefreshing()
                switch state.updateAction {
                   
                case let .delete(indexPath):
                    
                    self.postTableView.beginUpdates()
                    self.postTableView.deleteRows(at: [indexPath], with: .fade)
                    self.postTableView.endUpdates()
                case let .update(indexPath):
                   
                    self.postTableView.beginUpdates()
                    self.postTableView.reloadRows(at: [indexPath], with: .automatic)
                    self.postTableView.endUpdates()
                    
                case .deleteAll:
                    self.postTableView.reloadData()
                case .refresh(_):
                    self.postTableView.reloadData()
                }
            }
        })
        
        self.redditPostVM.onErrorHandling = { error in
            let alert = UIAlertController(title: "Oppss", message: "Something went wrong", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))

            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            
        }
        self.redditPostVM.updateLoadingMore = {
            DispatchQueue.main.async {
                self.spinner.startAnimating()
            }
        }
        self.redditPostVM.getRedditPostsData()
    
    }
    
    @IBAction func dismissPosts(_ sender: UIButton) {
        redditPostVM.removeAll()
    }
    
}

extension PostListViewController : UITableViewDataSource  {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditPostVM?.state.postCellViewModels.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedditPostCell", for: indexPath) as! RedditPostTableViewCell
        let post = redditPostVM.getCellViewModel(at: indexPath)
        cell.authorLabel.text = post.authorText
        cell.commentsLabel.text = post.commentsText
        cell.createdLabel.text = post.createDateText
        cell.descriptionLabel.text = post.titleText
        cell.postImageView.load(urlString: post.thumbnailUrl)
        cell.unreadStatus.isHidden = post.read
        cell.onDismiss = { [weak self] in
            self?.redditPostVM.removePost(post)
        }
        cell.post = post
        return cell
    }
    
}

extension PostListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = redditPostVM.state.postCellViewModels[indexPath.row]
        selectionDelegate?.postSelected(selectedPost)
        redditPostVM.postRead(position: indexPath.row)
        if let detailVC = selectionDelegate as? PostDetailsViewController {
          splitViewController?.showDetailViewController(detailVC, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !redditPostVM.isLoading && indexPath.row == redditPostVM.state.postCellViewModels.count - 5 {
            redditPostVM.getMoreRedditPostsData()
        }
    }
}

extension PostListViewController : UISplitViewControllerDelegate {
    @available(iOS 14.0,*)
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        return true
    }
}


