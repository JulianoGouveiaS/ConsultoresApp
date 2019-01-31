//
//  SuporteVC.swift
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


class SuporteVC: UIViewController {
    private let customAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = .red
        var imageView : UIImageView
        imageView  = UIImageView(frame:view.frame);
        imageView.image = UIImage(named:"whatsapp")
        view.addSubview(imageView)
        return view
    }()

    var rows = [Row]()
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initializers
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.navigationController?.isNavigationBarHidden = false
        dataSource.tableView = tableView
        
        tableView.rowHeight = 50
        loadNumeros()
        // Note:
        // Required to be set pre iOS11, to support autosizing
        tableView.estimatedSectionHeaderHeight = 13.5
        tableView.estimatedSectionFooterHeight = 13.5
        
        
        // Do any additional setup after loading the view.
    }
    

    func loadNumeros(){
        KRProgressHUD.show()
        let db = Firestore.firestore()
        
        db.collection("ConsultorSeven").document("Suporte").collection("Contatos").addSnapshotListener { (querySnapshot, err) in
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
                        
                        let urlWhats = "whatsapp://send?phone=\(tel)&abid=12354&text=Olá, minha dúvida é: "
                        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                            if let whatsappURL = URL(string: urlString) {
                                if UIApplication.shared.canOpenURL(whatsappURL) {
                                    UIApplication.shared.openURL(whatsappURL)
                                } else {
                                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Whatsapp não detectado", acaoAlerta: "Ok")
                                }
                            }
                        }
                        
                        }, cellClass: SubtitleCell.self)
                    if nome != "Logistíca" && nome != "Treinamento" && nome != "RH" && nome != "Financeiro"{
                        self.rows.append(row)
                    }
                    
                }
                
                
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.dataSource.sections = [
                        Section(header: "Números Whatsapp", rows: self.rows)
                    ]
                    self.tableView.reloadData()
                }
            }
            KRProgressHUD.dismiss()
        }
    }
    

}
