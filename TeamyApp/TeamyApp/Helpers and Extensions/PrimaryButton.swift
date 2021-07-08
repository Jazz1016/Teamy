//
//  PrimaryButton.swift
//  TeamyApp
//
//  Created by James Lea on 7/7/21.
//

import UIKit

class PrimaryButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButton()
    }
    
    func setupButton() {
        self.setTitleColor(.white, for: .normal)
        self.addCornerRadius()
        self.layer.backgroundColor = Colors.customGreen.cgColor
//        self.layer.borderColor = Colors.customGreen.cgColor
    }
    
}
