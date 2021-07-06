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
    
}

//MARK: - extensions
extension EditContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //AnthonyByrd - Return to add cell
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //AnthonyByrd - Return to add cell
        
        return UITableViewCell()
    }
    
    
}
