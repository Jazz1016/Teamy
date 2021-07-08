//
//  SignUpLabel.swift
//  TeamyApp
//
//  Created by Ethan Scott on 7/8/21.
//

import UIKit
class SignUpLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLabel()
    }
    
    func setupLabel() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5
    }
    
}
