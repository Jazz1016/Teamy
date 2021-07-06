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
        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//        }
        
        userTeamsTableView.delegate = self
        userTeamsTableView.dataSource = self
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
                    //Ethan - Having issue when User changes name, teams no longer fetch.
                    TeamController.shared.fetchTeamsForUser(teamIds: user.teams) { result in
                        if result {
                            self.userTeamsTableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        EventController.shared.isAdmin = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userTeamsTableView.reloadData()
    }
    
    // MARK: - Method
    
    
}//End of class

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeamController.shared.teams.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == TeamController.shared.teams.count {
            let cell = userTeamsTableView.dequeueReusableCell(withIdentifier: "joinTeamCell") as? JoinTeamTableViewCell
            return cell ?? UITableViewCell()
        } else if indexPath.row == TeamController.shared.teams.count + 1 {
            guard let cell = userTeamsTableView.dequeueReusableCell(withIdentifier: "createTeamCell", for: indexPath) as? CreateTeamTableViewCell else {return UITableViewCell()}
            return cell
        } else {
            guard let cell = userTeamsTableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamTableViewCell else {return UITableViewCell()}
            let team = TeamController.shared.teams[indexPath.row]
            cell.team = team
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let team = TeamController.shared.teams[indexPath.row]
//            TeamController.shared.deleteTeam(team: team)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTeamVC" {
            guard let destination = segue.destination as? TeamViewController,
                  let indexPath = userTeamsTableView.indexPathForSelectedRow else {return}
            destination.team = TeamController.shared.teams[indexPath.row]
        }
        if segue.identifier == "toProfileSettingsVC" {
            guard let destination = segue.destination as? UserSettingsViewController else {return}
            destination.user = UserController.shared.user
            
        }
    }
}//End of extension
