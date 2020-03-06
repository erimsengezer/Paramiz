//
//  ActivityVC.swift
//  RealmTest
//
//  Created by Erim on 5.03.2020.
//  Copyright © 2020 Erim. All rights reserved.
//

import UIKit
import RealmSwift

class ActivityVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    //    var activities = ["Ankara Gezisi", "İstanbul Gezisi", "İzmir Gezisi"]
    var activities : Results<Activity>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let a1 = Activity()
//        a1.name = "Ev"
//        a1.isFinish = true
//        activities.append(a1)
//
//        let a2 = Activity()
//        a2.name = "Ankara Gezisi"
//        a2.isFinish = false
//        activities.append(a2)
//
//        let a3 = Activity()
//        a3.name = "İstanbul Gezisi"
//        a3.isFinish = false
//        activities.append(a3)
//
//        let a4 = Activity()
//        a4.name = "İzmir Gezisi"
//        a4.isFinish = true
//        activities.append(a4)
        
        getData()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activities?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "activities")
        
        
        let sonuc : Int = activities?[indexPath.row].payments.sum(ofProperty: "price") ?? 0
        
        if let name = activities?[indexPath.row].name {
            cell.textLabel?.text = "\(name) - \(sonuc)"
        }
        else {
            cell.textLabel?.text = activities?[indexPath.row].name ?? "Aktivite Bulunamadı"
        }
        
        if activities?[indexPath.row].isFinish ?? false {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell = tableView.cellForRow(at: indexPath)
//
//        activities[indexPath.row].isFinish = !activities[indexPath.row].isFinish
//        tableView.reloadData()
        
        performSegue(withIdentifier: "paySegue", sender: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let deleteObject = activities?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(deleteObject.payments)
                        realm.delete(deleteObject)
                         
                    }
                }
                catch {
                    print("Error \(error.localizedDescription)")
                }
            }
            

        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            tableView.reloadData()
        }
        
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paySegue" {
            let destinationVC = segue.destination as! PayListVC
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedActivity = activities?[indexPath.row]
            }
            
        }
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Aktivite Ekle", message: "Eklemek istediğiniz aktiviteyi yazınız", preferredStyle: .alert)
        alert.addTextField { (activityName) in
            activityName.placeholder = "Aktivite Adı"
        }
        
        let addAction = UIAlertAction(title: "Ekle", style: .default) { (action) in
            let activityName = alert.textFields![0]
            if !activityName.text!.isEmpty {
                let a1 = Activity()
                a1.name = activityName.text!
                self.saveData(activity : a1)
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveData(activity : Activity) {
        do {
            try realm.write {
                realm.add(activity)
            }
        }
        catch {
            
        }
    }
    
    func getData() {
        activities = realm.objects(Activity.self)
        tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.activities = self.activities?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getData()
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            } 
        }
    }
    
    
}
