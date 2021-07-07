//
//  PrimaryButton.swift
//  TeamyApp
//
//  Created by Lizzie Ferguson on 7/7/21.
//

import UIKit

class PrimaryButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButton()
    }
    
    func setupButton() {
        self.backgroundColor = Colors.backgroundBlack
        self.setTitleColor(.white, for: .normal)
        self.addCornerRadius()
    }

}
