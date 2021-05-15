//
//  UIIMAGE.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import UIKit

extension UIImageView {
    func load(urlString : String, placeholderImage : UIImage? = UIImage(imageLiteralResourceName : "PostPlaceholder.png")) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self.image = placeholderImage
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }else {
            DispatchQueue.main.async {
                self.image = placeholderImage
            }
        }
    }
}
