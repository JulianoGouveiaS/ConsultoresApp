//
//  TablePagamentosVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 24/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import CFAlertViewController

class TablePagamentosVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    let db = Firestore.firestore()
    
    var listaPagamentos = [Pagamento]()
    
    
    @IBOutlet weak var enviarBttn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPagamentos()
         self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPagamentos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulareuso",
                                                 for: indexPath as IndexPath) as! PagamentoCell
        var pag = Pagamento()
        pag = self.listaPagamentos[indexPath.row]
        
       
        
        cell.numLabel.text = pag.numero!
        cell.placaLabel.text = "Placa: \(pag.placa!)"
        cell.dataLabel.text = "Data: \(pag.data!)"
        
        self.tableView.rowHeight = 87
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var pag = Pagamento()
        pag = self.listaPagamentos[indexPath.row]
       
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComprovanteVC") as! ComprovanteVC
        vc.cartaoRecebido = pag.numero
        vc.dataRecebido = pag.data
        vc.idVendaRecebido = pag.id_venda
        vc.nomeRecebido = pag.nome
        vc.parcelasRecebido = pag.parcelas
        vc.placaRecebido = pag.placa
        vc.totalRecebido = pag.valor
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func loadPagamentos(){
        KRProgressHUD.show()
        
        db.collection("ConsultorSeven").document("ComprovantesPagamentos").collection("\(self.id_user!)").order(by: "data", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.listaPagamentos = []
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                    let pag = Pagamento()
                    pag.data = dictionary["data"] as? String ?? ""
                    pag.id_venda = dictionary["id_venda"] as? String ?? ""
                    pag.nome = dictionary["nome"] as? String ?? ""
                    pag.numero = dictionary["numero"] as? String ?? ""
                    pag.parcelas = dictionary["parcelas"] as? String ?? ""
                    pag.placa = dictionary["placa"] as? String ?? ""
                    pag.valor = dictionary["valor"] as? String ?? ""
                    
                    self.listaPagamentos.append(pag)
                    
                }
                
                
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            KRProgressHUD.dismiss()
        }
    }
    
    
    
    
}
