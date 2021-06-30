//
//  RosterViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/28/21.
//

import UIKit

class RosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var addNewPlayerButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
         rosterTableView.delegate = self
        rosterTableView.dataSource = self
        addNewPlayerButton.isHidden = true
        if EventController.shared.isAdmin {
            addNewPlayerButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if EventController.shared.isAdmin {
            addNewPlayerButton.isHidden = false
        }
    }
    
    // MARK: - Actions
    @IBAction func addNewPlayerButtonTapped(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if EventController.shared.isAdmin {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            PlayerController.shared.players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { action, indexPath in
            
            print("edit button tapped")
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerController.shared.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerTableViewCell
            
            let player = PlayerController.shared.players[indexPath.row]
            
            cell?.player = player
            cell?.playerIndex = indexPath.row
            
            return cell ?? UITableViewCell()
    }
}//End of class
