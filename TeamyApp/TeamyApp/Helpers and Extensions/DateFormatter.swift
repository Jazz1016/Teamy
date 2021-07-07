//
//  DateFormatter.swift
//  TeamyApp
//
//  Created by Ethan Scott on 6/23/21.
//

import Foundation
extension Date {
    
    func formatToMediumString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        
        
        return formatter.string(from: self)
    }
    
    func formatToFullString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        
        
        return formatter.string(from: self)
    }
    
    func formatToCustomString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d, h:mm a"
        
        
        return formatter.string(from: self)
    }
}
