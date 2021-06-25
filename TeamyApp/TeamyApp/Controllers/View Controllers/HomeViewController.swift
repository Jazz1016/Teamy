//
//  HomeViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var userTeamsTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userTeamsTableView.delegate = self
        userTeamsTableView.dataSource = self
        TeamController.shared.delegate = self
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("error")
//        }
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(identifier: "AuthVC")
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let user = Auth.auth().currentUser else {return}
        
        UserController.shared.fetchUser(userId: user.uid) { result in
            switch result {
            case .success(let user):
                UserController.shared.user = user
                
                DispatchQueue.main.async {
                    TeamController.shared.fetchTeamsForUser(teamIds: user.teams)
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            
        }
        reloadTeamsTable()
    }
    
    // MARK: - Properties
    
    // MARK: - Functions
    func reloadTeamsTable(){
        
        userTeamsTableView.reloadData()
    }
    
}//End of class

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeamController.shared.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTeamsTableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamTableViewCell
        
        let team = TeamController.shared.teams[indexPath.row]
        
        cell?.team = team
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let team = TeamController.shared.teams[indexPath.row]
            TeamController.shared.deleteTeam(team: team)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTeamVC" {
            guard let destination = segue.destination as? TeamViewController,
                  let indexPath = userTeamsTableView.indexPathForSelectedRow else {return}
            
            destination.team = TeamController.shared.teams[indexPath.row]
        }
    }
}//End of extension

extension HomeViewController: reloadHomeTableView {
    func updateTableView() {
        self.reloadTeamsTable()
    }
}
