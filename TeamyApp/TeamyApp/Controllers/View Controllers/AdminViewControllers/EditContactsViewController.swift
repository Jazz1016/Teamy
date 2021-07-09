//
//  EditContactsViewController.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class EditContactsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var contactsTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func addContactButtonTapped(_ sender: Any) {
        let createNewContactAlert = UIAlertController(title: "Create New Contact", message: "Please fill out all fields", preferredStyle: .alert)
        
        createNewContactAlert.addTextField { textfield in
            textfield.placeholder = "Contact name"
        }
        
        createNewContactAlert.addTextField { textfield in
            textfield.placeholder = "Contact method"
        }
        
        createNewContactAlert.addTextField { textfield in
            textfield.placeholder = "Enter method"
        }
        
        let addContactAction = UIAlertAction(title: "Create", style: .default) { action in
            
            guard let contactName = createNewContactAlert.textFields![0].text,
                  let contactType = createNewContactAlert.textFields![1].text,
                  let contactInfo = createNewContactAlert.textFields![2].text,
                  let teamId = EventController.shared.team else { return }
            
            let newContact = Contact(contactName: contactName, contactType: contactType, contactInfo: contactInfo)
            
            ContactController.shared.createContact(contact: newContact, teamId: teamId.teamId)
            
            self.contactsTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        createNewContactAlert.addAction(cancelAction)
        createNewContactAlert.addAction(addContactAction)
        present(createNewContactAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}//End of class

//MARK: - extensions
extension EditContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ContactController.shared.contacts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if EventController.shared.isAdmin {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addContactCell", for: indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "editContactCell", for: indexPath) as? EditContactTableViewCell
                
                let contact = ContactController.shared.contacts[indexPath.row - 1]
                cell?.contact = contact
                cell?.contactIndex = indexPath.row - 1
                
                return cell ?? UITableViewCell()
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editContactCell", for: indexPath) as? EditContactTableViewCell
            
            let contact = ContactController.shared.contacts[indexPath.row - 1]
            cell?.contact = contact
            cell?.contactIndex = indexPath.row - 1
            
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let team = EventController.shared.team else { return [] }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            let contactToDelete = ContactController.shared.contacts[indexPath.row - 1]
            ContactController.shared.contacts.remove(at: indexPath.row - 1)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            ContactController.shared.deleteContact(contact: contactToDelete, teamId: team.teamId)
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { action, indexPath in
            if let cell = tableView.cellForRow(at: indexPath) as? EditContactTableViewCell {
                cell.updateForEdit()
            }
        }
        
        editAction.backgroundColor = .systemBlue
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    
}
