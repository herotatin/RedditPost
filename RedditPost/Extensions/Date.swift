//
//  Date.swift
//  RedditPost
//
//  Created by José Omar Colorado Pérez on 15/05/21.
//

import Foundation

extension Date {
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
