//
//  PayListVC.swift
//  RealmTest
//
//  Created by Erim on 5.03.2020.
//  Copyright © 2020 Erim. All rights reserved.
//

import UIKit
import RealmSwift

class PayListVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBaar: UISearchBar!
    let realm = try! Realm()
    var payments : Results<Payment>?
    var total : Results<Payment>?
    var selectedActivity : Activity? {
        didSet {
            getPayments()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBaar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return payments?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payCell", for: indexPath)
        
        if let pay = payments?[indexPath.row] {
            cell.textLabel?.text = "\(pay.payerName) - \(pay.price) Lira"
//
//            if let total = total?[indexPath.row] {
//                cell.textLabel?.text = "\(pay.payerName)"
//            }
        }
        else {
            cell.textLabel?.text = "Henüz Ödeme Yapılmadı"
        }
        
        return cell
        
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Ödeme", message: "Ödeme Ekle", preferredStyle: .alert)
       
        alert.addTextField { nameTextField in
            nameTextField.placeholder = "Ödeyen Kişi"
        }
        
        alert.addTextField { descTextField in
            descTextField.placeholder = "Açıklama"
        }
        
        alert.addTextField { payTextField in
            payTextField.placeholder = "Ödeme Miktarı"
            payTextField.keyboardType = .numberPad
        }
        
        let addButton = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default) { action in
            
            let personText = alert.textFields![0]
            let descText = alert.textFields![1]
            let payText = alert.textFields![2]
            
            if let selectedActivity = self.selectedActivity {
                do {
                    try self.realm.write {
                        
                        let newPay = Payment()
                        newPay.payerName = personText.text ?? "Girilmedi"
                        newPay.payDescription = descText.text ?? "Girilmedi"
                        newPay.price = Int(payText.text ?? "-1")!
                        selectedActivity.payments.append(newPay)
                        
                        
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(addButton)
        present(alert, animated: true, completion: nil)
    }
    
    func getPayments() {
        payments = selectedActivity?.payments.sorted(byKeyPath: "payerName", ascending: true)
    }
    
    func getData() {
        payments = realm.objects(Payment.self).filter("ANY activity.name = %@", selectedActivity!.name).sorted(byKeyPath: "payerName", ascending: true)
//        total = realm.objects(Payment.self).filter("ANY activiy.name = %@", selectedActivity!.name).filter("price.@sum").sorted(byKeyPath: "payerName", ascending: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let destination = segue.destination as! DetailVC
            
            if let indexPath = tableView.indexPathForSelectedRow {
                if let selectedPay = payments? [indexPath.row] {
                    destination.selectedPay = selectedPay
                    destination.title = "\(selectedPay.payerName) Ödeme Bilgileri "
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let selectedPayment = payments?[indexPath.row] {
                do {
                    try realm.write {
                         realm.delete(selectedPayment)
                        tableView.beginUpdates()
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                catch {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.payments = self.payments?.filter("payerName CONTAINS[cd] %@" , searchBar.text!).sorted(byKeyPath: "payerName", ascending: true)
        self.tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getData()
        
        if searchBar.text!.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
