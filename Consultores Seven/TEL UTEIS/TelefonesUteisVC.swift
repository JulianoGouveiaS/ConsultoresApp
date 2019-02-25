//
//  TelefonesUteisVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 24/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Alamofire
import SwiftyJSON
import Static
import SwiftyPickerPopover


class TelefonesUteisVC: UIViewController {
  
    var rows = [Row]()
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initializers
    var dataSource = DataSource()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        dataSource.tableView = tableView
        
        tableView.rowHeight = 50
        loadTelUteis()
        // Note:
        // Required to be set pre iOS11, to support autosizing
        tableView.estimatedSectionHeaderHeight = 13.5
        tableView.estimatedSectionFooterHeight = 13.5
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func loadTelUteis(){
        KRProgressHUD.show()
        let db = Firestore.firestore()
        
        db.collection("ConsultorSeven").document("TelefonesUteis").collection("contatos").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.rows = []
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                    let pag = Pagamento()
                    let nome = dictionary["nome"] as? String ?? ""
                    let tel = dictionary["telefone"] as? String ?? ""
                    
                    let row = Row(text: "\(nome)", detailText: "\(tel)", selection: { [unowned self] in
                        
                        if let url = URL(string: tel), UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                        
                        }, cellClass: SubtitleCell.self)
                    
                    self.rows.append(row)
                    
                }
                
                
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.dataSource.sections = [
                        Section(header: "", rows: self.rows)
                    ]
                    self.tableView.reloadData()
                }
            }
            KRProgressHUD.dismiss()
        }
    }
    
    
}
