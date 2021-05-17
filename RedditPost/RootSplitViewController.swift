//
//  RootSplitViewController.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 17/05/21.
//

import UIKit

class RootSplitViewController: UISplitViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate = self

        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredDisplayMode = .oneBesideSecondary
            if #available(iOS 14, *) {
                preferredSplitBehavior = .tile
            }
        }
        }
    }

extension RootSplitViewController : UISplitViewControllerDelegate {

    @available(iOS 14.0, *)
    public func splitViewController(_ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn
        proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }

    public func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController:UIViewController,
                             onto primaryViewController:UIViewController) -> Bool {
        return true
    }
}
