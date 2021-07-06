//
//  EditContactTableViewCell.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class EditContactTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactNameTextfield: UITextField!
    @IBOutlet weak var contactMethod: UITextField!
    @IBOutlet weak var enterMethod: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Properties
    
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Methods
    
    
}//End of class
