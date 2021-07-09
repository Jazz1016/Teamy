//
//  StyleGuide.swift
//  TeamyApp
//
//  Created by James Lea on 7/7/21.
//

import UIKit

extension UIView {
    
    func addCornerRadius(_ radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
    }
}

struct Colors {
    static let customGreen = UIColor(named: "CustomGreen")!
}
