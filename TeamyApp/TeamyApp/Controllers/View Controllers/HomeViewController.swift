//
//  HomeViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    @IBOutlet weak var userTeamsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
                  try Auth.auth().signOut()
              } catch {
               print("error")
              }
        
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(identifier: "AuthVC")
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)
        }
    }
    



}
