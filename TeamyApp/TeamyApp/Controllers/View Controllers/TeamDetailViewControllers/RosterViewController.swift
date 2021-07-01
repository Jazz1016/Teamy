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
    
    // MARK: - Properties
//    var delegate: editCellTapped?
    
    // MARK: - Actions
    @IBAction func addNewPlayerButtonTapped(_ sender: Any) {
        let createPlayerController = UIAlertController(title: "Create New Player", message: "Please fill out all fields", preferredStyle: .alert)
        
        createPlayerController.addTextField { textfield in
            textfield.placeholder = "Player Name"
        }
        
        createPlayerController.addTextField { textfield in
            textfield.placeholder = "Player Role"
        }
        
        createPlayerController.addTextField { textfield in
            textfield.placeholder = "Jersey Number"
            textfield.keyboardType = UIKeyboardType.numberPad
        }
        
        let addPlayerAction = UIAlertAction(title: "Create", style: .default) { action in
            guard let playerNameField = createPlayerController.textFields![0].text,
                  let playerRoleField = createPlayerController.textFields![1].text,
                  let jerseyNumberField = createPlayerController.textFields![2].text,
                  let teamId = EventController.shared.team else {return}
                  
            let newPlayer = Player(name: playerNameField, role: playerRoleField, jerseyNumber: jerseyNumberField)
            
            PlayerController.shared.createPlayer(player: newPlayer, teamId: teamId.teamId)
                  
            self.rosterTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        createPlayerController.addAction(cancelAction)
        createPlayerController.addAction(addPlayerAction)
        present(createPlayerController, animated: true, completion: nil)
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
//            let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerTableViewCell
            if let cell = tableView.cellForRow(at: indexPath) as? PlayerTableViewCell {
                cell.updateForEdit()
            }
        }
        
        editAction.backgroundColor = .systemBlue
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
            cell?.delegate = self
            return cell ?? UITableViewCell()
    }
    
}//End of class
