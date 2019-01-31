//
//  CamposRastreadorVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 25/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore


class CamposRastreadorVC: UIViewController, UITextFieldDelegate {
    
    var propostaEscolhida: Proposta!
    let db = Firestore.firestore()
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var cpfTxt: UITextField!
    @IBOutlet weak var placaTxt: UITextField!
    
    @IBOutlet weak var bttnProsseguir: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        preencheCampos()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func prosseguir(sender: Any){
        let vc = UIStoryboard(name: "Rastreador", bundle: nil).instantiateViewController(withIdentifier: "FotosRastreadorVC") as! FotosRastreadorVC
        vc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func preencheCampos(){
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                
                self.nomeTxt.text = dictionary?["nome"] as? String ?? ""
                self.cpfTxt.text = dictionary?["cpfcnpj"] as? String ?? ""
                self.placaTxt.text = dictionary?["placa"] as? String ?? ""
                
                
            }
            
        }
        
    }
    
   
    
}
