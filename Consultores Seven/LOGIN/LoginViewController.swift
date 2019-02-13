//
//  LoginViewController.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 08/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import PMSuperButton
import SwiftyJSON
import Alamofire
import KRProgressHUD
import FirebaseFirestore
import CFAlertViewController
import FirebaseAuth

class LoginViewController: UIViewController {
    var alamofireManager : Alamofire.SessionManager?
    @IBOutlet weak var loginTxtField: UITextField!
    @IBOutlet weak var senhaTxtField: UITextField!
    
    @IBOutlet weak var imagemLogo: UIImageView!
    @IBOutlet weak var ButtonEntrar: PMSuperButton!
    
    @IBOutlet weak var cpfTxtField: UITextField!
    @IBOutlet weak var ButtonEntrarCliente: PMSuperButton!
    @IBOutlet weak var ButtonVerSenha: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func verSenha(sender: Any){
        switch self.senhaTxtField.isSecureTextEntry {
        case true:
            self.senhaTxtField.isSecureTextEntry = false
            self.ButtonVerSenha.setImage(UIImage(named: "hide"), for: .normal)
        case false:
            self.senhaTxtField.isSecureTextEntry = true
            self.ButtonVerSenha.setImage(UIImage(named: "eye"), for: .normal)
        default:
            self.senhaTxtField.isSecureTextEntry = true
            self.ButtonVerSenha.setImage(UIImage(named: "eye"), for: .normal)
        }
    }
    
    func Login(login: String, senha: String){
        
        KRProgressHUD.show()
        
        let login = login
        let password = senha
        
        let parameters = ["login": "\(login)","password": "\(password)"] as [String : Any]
        
        let url = "https://sevenprotecaoveicular.com.br/Api/Login"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                if json["user_data"]["id"].stringValue == "0"{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Usuário não encontrado!", acaoAlerta: "Ok", erroRecebido: "json[user_data][id].stringValue retornou 0")
                    
                    KRProgressHUD.dismiss()
                }else{
                    
                    let id_user = json["user_data"]["id"].int
                    let nome_user = json["user_data"]["name"].stringValue
                    let cpf_user = json["user_data"]["cpf"].stringValue
                    let num_cell = json["user_data"]["num_cell"].stringValue
                    
                    KeychainWrapper.standard.set(nome_user, forKey: "NOME")
                    KeychainWrapper.standard.set(cpf_user, forKey: "CPF")
                    KeychainWrapper.standard.set(id_user!, forKey: "ID")
                
                    self.inicializaPerfil(nome: nome_user, cpf: cpf_user, id_user: "\(id_user!)")
                    
                    let num_cell1 = num_cell.replace(target: "(", withString: "")
                    let num_cell2 = num_cell1.replace(target: ")", withString: "")
                    let num_cell3 = num_cell2.replace(target: " ", withString: "")
                    let num_cell4 = num_cell3.replace(target: "-", withString: "")
                    let numeroCel = "+55\(num_cell4)"
                    self.VerificaStatus(id_voluntario: id_user!, num_cell: numeroCel, id: id_user!, nome: nome_user, cpf: cpf_user, login: self.loginTxtField.text!, senha: self.senhaTxtField.text!)
                    KRProgressHUD.dismiss()
                    
                }
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                KRProgressHUD.showMessage("Erro!")
                
                print(error)
                if error._code == NSURLErrorTimedOut {
                    
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Conecte-se a internet!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }else {
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao conectar-se!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }
                
            }
            
        }
    }
    
    func VerificaStatus(id_voluntario: Int, num_cell: String, id: Int, nome:String, cpf: String, login: String, senha: String){
        
        KRProgressHUD.show()
        
        let parameters = ["id_voluntario": "\(id_voluntario)"] as [String : Any]
        
        
        
        let url = "https://sevenprotecaoveicular.com.br/Api/VerificaUser"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let id_status = json["user_data"]["id_status"].int
                
                if id_status == 61{
                    self.checkFunilExiste(id: id_voluntario) { fez in
                        if !fez{
                            //funil
                            let vc = UIStoryboard(name: "Funil", bundle: nil).instantiateViewController(withIdentifier: "FunilVC") as! FunilVC
                            vc.loginAux = self.loginTxtField.text!
                            vc.senhaAux = self.senhaTxtField.text!
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            
                            self.registraLogin(id: id_voluntario, login: login, senha: senha);
                       
                            KeychainWrapper.standard.set(nome, forKey: "NOME");
                            KeychainWrapper.standard.set(cpf, forKey: "CPF");
                            KeychainWrapper.standard.set(id, forKey: "ID");
                            
                            KeychainWrapper.standard.set(login, forKey: "LOGIN");
                            KeychainWrapper.standard.set(senha, forKey: "SENHA");
                            KRProgressHUD.dismiss();
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as! TabBarPrincipal;
                            
                            self.navigationController?.pushViewController(vc, animated: true);
                            
                            /*
                            KRProgressHUD.dismiss()
                            self.verifyIfIsTest(finished: { (status) in
                                if status == true{
                                    let alertController = CFAlertViewController(title: "CONFIRMAÇÃO",
                                                                                message: "O Código será enviado para este número: +55 34 0000-0000",
                                                                                textAlignment: .center,
                                                                                preferredStyle: .alert,
                                                                                didDismissAlertHandler: nil)
                                    
                                    // Create Upgrade Action
                                    let ok = CFAlertAction(title: "Ok",
                                                           style: .Default,
                                                           alignment: .center,
                                                           backgroundColor: UIColor(displayP3Red: 0/255, green: 14/255, blue: 87/255, alpha: 1),
                                                           textColor: UIColor.white,
                                                           handler: { (action) in
                                                            KRProgressHUD.show()
                                                            Auth.auth().languageCode = "pt"
                                                            PhoneAuthProvider.provider().verifyPhoneNumber("+553400000000", uiDelegate: nil) { (verificationID, error) in
                                                                if let error = error {
                                                                    print(error)
                                                                    KRProgressHUD.dismiss()
                                                                    self.CriarAlertaSemErro(tituloAlerta: "Erro", mensagemAlerta: "\(error)", acaoAlerta: "Ok")
                                                                    return
                                                                }
                                                                KRProgressHUD.dismiss()
                                                                let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "PINViewController") as! PINViewController
                                                                vc.id_voluntario = id_voluntario
                                                                vc.verificationID = verificationID
                                                                vc.id_user = id
                                                                vc.nome_user = nome
                                                                vc.cpf_user = cpf
                                                                vc.login = login
                                                                vc.senha = senha
                                                                self.navigationController?.pushViewController(vc, animated: true)
                                                            }
                                    })
                                    
                                    // Create Upgrade Action
                                    let Cancelar = CFAlertAction(title: "Cancelar",
                                                                 style: .Destructive,
                                                                 alignment: .center,
                                                                 backgroundColor: UIColor(displayP3Red: 0/255, green: 14/255, blue: 87/255, alpha: 1),
                                                                 textColor: UIColor.white,
                                                                 handler: { (action) in
                                                                    
                                    })
                                    // Add Action Button Into Alert
                                    alertController.addAction(ok)
                                    alertController.addAction(Cancelar)
                                    
                                    // Present Alert View Controller
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                }else{
                                    //status false
                                    let alertController = CFAlertViewController(title: "CONFIRMAÇÃO",
                                                                                message: "O Código será enviado para o número: \(num_cell)",
                                        textAlignment: .center,
                                        preferredStyle: .alert,
                                        didDismissAlertHandler: nil)
                                    
                                    // Create Upgrade Action
                                    let ok = CFAlertAction(title: "Ok",
                                                           style: .Default,
                                                           alignment: .center,
                                                           backgroundColor: UIColor(displayP3Red: 0/255, green: 14/255, blue: 87/255, alpha: 1),
                                                           textColor: UIColor.white,
                                                           handler: { (action) in
                                                            KRProgressHUD.show()
                                                            Auth.auth().languageCode = "pt"
                                                            PhoneAuthProvider.provider().verifyPhoneNumber(num_cell, uiDelegate: nil) { (verificationID, error) in
                                                                if let error = error {
                                                                    print(error)
                                                                    return
                                                                }
                                                                KRProgressHUD.dismiss()
                                                                let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "PINViewController") as! PINViewController
                                                                vc.id_voluntario = id_voluntario
                                                                vc.verificationID = verificationID
                                                                vc.id_user = id
                                                                vc.nome_user = nome
                                                                vc.cpf_user = cpf
                                                                vc.login = login
                                                                vc.senha = senha
                                                                self.navigationController?.pushViewController(vc, animated: true)
                                                            }
                                    })
                                    
                                    // Create Upgrade Action
                                    let Cancelar = CFAlertAction(title: "Cancelar",
                                                                 style: .Destructive,
                                                                 alignment: .center,
                                                                 backgroundColor: UIColor(displayP3Red: 0/255, green: 14/255, blue: 87/255, alpha: 1),
                                                                 textColor: UIColor.white,
                                                                 handler: { (action) in
                                                                    
                                    })
                                    // Add Action Button Into Alert
                                    alertController.addAction(ok)
                                    alertController.addAction(Cancelar)
                                    
                                    // Present Alert View Controller
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                    
                                }
                            })*/
                        }}
                        
                }else if id_status == 91{
                    KRProgressHUD.dismiss()
                    //cadastrar user
                    self.registraLogin(id: id_voluntario, login: login, senha: senha)
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as! TabBarPrincipal
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    KRProgressHUD.dismiss()
                    self.logoutApp()
                }
                    
                KRProgressHUD.dismiss()
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                
                print(error)
                    
                self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao Efetuar login!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                
                
            }
            
        }
    }
    
    func LoginCliente(cpf: String){
        
        KRProgressHUD.show()
        
        let cpf = cpf
        
        let parameters = ["cpf": "\(cpf)"] as [String : Any]
        
        let url = "https://sevenprotecaoveicular.com.br/Api/LoginCliente"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                if json["user_data"]["id"].stringValue == "0"{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Usuário não encontrado!", acaoAlerta: "Ok", erroRecebido: "json[user_data][id].stringValue retornou 0")
                    
                    KRProgressHUD.dismiss()
                }else{
                    
                    let id_user = json["user_data"]["id"].int
                    let nome_user = json["user_data"]["name"].stringValue
                    let cpf_user = json["user_data"]["cpf"].stringValue
                    
                    KeychainWrapper.standard.set(nome_user, forKey: "NOME-C")
                    KeychainWrapper.standard.set(cpf_user, forKey: "CPF-C")
                    KeychainWrapper.standard.set(id_user!, forKey: "ID-C")
                    
                    let vc = UIStoryboard(name: "MainCliente", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipalCliente") as! TabBarPrincipalCliente
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    KRProgressHUD.dismiss()
                }
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                
                print(error)
                
                self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro encontrado!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                
                
            }
            
        }
    }
    
    @IBAction func LoginClienteButton(_ sender: Any) {
        if self.cpfTxtField.text! != ""{
            LoginCliente(cpf: self.cpfTxtField.text!)
        }else{
            self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Digite seu CPF!", acaoAlerta: "Ok", erroRecebido: "Campo vazio.")
        }
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        if self.loginTxtField.text! != "" && self.senhaTxtField.text! != ""{
            Login(login: self.loginTxtField.text!, senha: senhaTxtField.text!)
        }else{
            self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Digite login e senha!", acaoAlerta: "Ok", erroRecebido: "self.loginTxtField.text ou self.senhaTxtField.text não estão preenchidos.")
        }
    }
    
    func enviaUserFirestore(cargo: String, cpf:String, id: String, img_user:String, nivel_id: String, nome: String, valid_natal: String){
        KRProgressHUD.show()
        let db = Firestore.firestore()
        
        let usersReference = db.collection("EventoSeven").document("Perfil").collection("Users").document("\(id)")
        
        let values = ["cargo": cargo, "cpf":cpf, "id": id, "img_user": img_user, "nivel_id": nivel_id, "nome": nome, "valid_natal": valid_natal] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro ao cadastrar no firebase", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                return
            }else{
                print("cadastrado no firebase com sucesso")
                KRProgressHUD.showSuccess(withMessage: "Usuário registrado")
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as! TabBarPrincipal
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

