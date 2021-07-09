//
//  ModalContactViewController.swift
//  TeamyApp
//
//  Created by James Lea on 7/6/21.
//

import UIKit

class ModalContactViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var contactModalView: UIView!
    @IBOutlet weak var contactNameLAbel: UILabel!
    @IBOutlet weak var contactTypeLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactModalView.layer.cornerRadius = 15

        contactNameLAbel.text = contact?.contactName
        contactTypeLabel.text = contact?.contactType
        contactInfoLabel.text = contact?.contactInfo
    }
    
    // MARK: - Properties
    var contact: Contact? {
        didSet {
            print("hit")
        }
    }
    
    
    // MARK: - Actions
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
