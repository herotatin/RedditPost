//
//  RedditPostTableViewDataSource.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import UIKit

class RedditPostTableViewDataSource<tableCell : UITableViewCell,T> : NSObject, UITableViewDataSource {
    
    private var cellIdentifier : String!
    private var posts : [T]!
    var configureCell : (tableCell, T) -> () = {_,_ in }
    
    init(cellIdentifier : String, posts : [T], configureCell : @escaping (tableCell, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.posts =  posts
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! tableCell
               
        let item = self.posts[indexPath.row]
        self.configureCell(cell, item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

}
