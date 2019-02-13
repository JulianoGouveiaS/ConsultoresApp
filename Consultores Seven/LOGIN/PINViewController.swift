//
//  PINViewController.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 21/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import FirebaseAuth
import CBPinEntryView
import KRProgressHUD

class PINViewController: UIViewController, CBPinEntryViewDelegate {
    
    func entryChanged(_ completed: Bool) {
        print("entryChanged")
    }
    
    var id_user: Int!
    var nome_user: String!
    var cpf_user: String!
    var login: String!
    var senha: String!
    
    @IBOutlet weak var EntrarBttn: UIButton!

    @IBOutlet weak var codigoTxtField: CBPinEntryView!{
        didSet {
            codigoTxtField.delegate = self
        }
    }
    
    var id_voluntario: Int!
    var verificationID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.navigationController?.isNavigationBarHidden = false
        self.hideKeyboardWhenTappedAround()

    }
    @IBAction func submitCodigo(sender: Any){
        KRProgressHUD.show()
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: self.codigoTxtField.getPinAsString())
        // Sign in using the verificationID and the code sent to the user
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                self.CriarAlertaSemErro(tituloAlerta: "Erro", mensagemAlerta: "\(error)", acaoAlerta: "Ok")
                KRProgressHUD.dismiss()
                return
            }
            // User is signed in
            self.checkFunilExiste(id: self.id_voluntario) { fez in
                if !fez{
                    //funil
                    KRProgressHUD.dismiss()
                    let vc = UIStoryboard(name: "Funil", bundle: nil).instantiateViewController(withIdentifier: "FunilVC") as! FunilVC;
                    self.navigationController?.pushViewController(vc, animated: true);
                    
                }else{
                    KRProgressHUD.dismiss()
                    self.registraLogin(id: self.id_voluntario, login: self.login, senha: self.senha);
                    KeychainWrapper.standard.set(self.nome_user, forKey: "NOME");
                    KeychainWrapper.standard.set(self.cpf_user, forKey: "CPF");
                    KeychainWrapper.standard.set(self.id_user!, forKey: "ID");
                    
                    KeychainWrapper.standard.set(self.login, forKey: "LOGIN");
                    KeychainWrapper.standard.set(self.senha, forKey: "SENHA");
                    KRProgressHUD.dismiss();
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as! TabBarPrincipal;
                    
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
        }
    }
}
