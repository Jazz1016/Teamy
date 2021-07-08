//
//  TextField.swift
//  TeamyApp
//
//  Created by Ethan Scott on 7/8/21.
//

import UIKit
class TextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTextField()
    }
    
    func setupTextField() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5
    }
    
    
}
