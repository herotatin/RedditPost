//
//  UIVIewController.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 17/05/21.
//

import UIKit

extension  UIViewController {
    func createConfirmationAlert(_ title : String, _ message : String, _ action : String = "Ok" ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}
