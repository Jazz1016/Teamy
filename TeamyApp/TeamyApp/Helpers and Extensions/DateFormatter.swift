//
//  DateFormatter.swift
//  TeamyApp
//
//  Created by Ethan Scott on 6/23/21.
//

import Foundation
extension Date {
    
    func formatToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        
        return formatter.string(from: self)
    }
}
