//
//  DetailVC.swift
//  RealmTest
//
//  Created by Erim on 5.03.2020.
//  Copyright © 2020 Erim. All rights reserved.
//

import UIKit
import RealmSwift
class DetailVC: UIViewController {
    
    var selectedPay : Payment?
    var realm = try! Realm()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var payTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    
    @IBAction func updateButtonClicked(_ sender: Any) {
        
        if let selectedPay = selectedPay {
            do {
                try realm.write {
                    selectedPay.payerName = nameTextField.text!
                    selectedPay.payDescription = descTextField.text!
                    let priceText = payTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    
                    selectedPay.price = Int((priceText)!)!
                }
            }
            catch {
                print(error.localizedDescription)
            }
            let alert = UIAlertController(title: "Başarılı !", message: "Güncelleme Başarılı", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Tamam", style: .default) { (action) in
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "payList")
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func getData() {
        nameTextField.text = selectedPay?.payerName
        descTextField.text = selectedPay?.payDescription
        payTextField.text = "\(selectedPay!.price) "
    }
    
}
