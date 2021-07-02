//
//  CodeModalViewController.swift
//  TeamyApp
//
//  Created by James Lea on 7/1/21.
//

import UIKit

class CodeModalViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var teamCodeLabel: UILabel!
    @IBOutlet weak var teamCodeView: UIView!
    @IBOutlet weak var resetCodeButton: UIButton!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let team = EventController.shared.team else {return}
        
        teamCodeLabel.text = team.teamCode
    }
    
    // MARK: - Actions
    @IBAction func dismissModalButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetCodeButtonTapped(_ sender: Any) {
        
    }
    
}
