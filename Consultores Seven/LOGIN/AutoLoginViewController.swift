//
//  AutoLoginViewController.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 08/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//\

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class AutoLoginViewController: UIViewController {
    
    
    var alamofireManager : Alamofire.SessionManager?
    let loginAUX = KeychainWrapper.standard.string(forKey: "LOGIN")
    let senhaAUX = KeychainWrapper.standard.string(forKey: "SENHA")
    override func viewDidAppear(_ animated: Bool) {
        
        
        var testeConexao = checkWiFi()
        if testeConexao == false {
            print("VOCE NAO ESTA CONECTADO")
            
            KRProgressHUD.showMessage("Erro de conexão")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Wifi detectada")
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KRProgressHUD.show()
        
       
        let cpfCliente = KeychainWrapper.standard.string(forKey: "CPF-C")
        print("loginAUX => \(loginAUX)")
        print("senhaAUX => \(senhaAUX)")
        print("cpfCliente => \(cpfCliente)")
       
        if (loginAUX == nil || senhaAUX == nil) {
            if cpfCliente == nil{
                let InicialViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(InicialViewController, animated: true)
                
                KRProgressHUD.showMessage("Desconectado")
            }else{
                LoginCliente(cpf: cpfCliente!)
            }
        }else{
                
            print("loginAUX!: \(loginAUX!) / senhaAUX!: \(senhaAUX!)")
            self.Login(login: loginAUX!, senha: senhaAUX!)
        }
    }
    
    
    func Login(login: String, senha: String){
        
        KRProgressHUD.show()
        print("login: \(login) ,password: \(senha)")
        let parameters = ["login": "\(login)","password": "\(senha)"] as [String : Any]
        
        
        
        let url = "https://sevenprotecaoveicular.com.br/Api/Login"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                if json["user_data"]["id"].stringValue == "0"{
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    KRProgressHUD.dismiss()
                    
                    
                }else{
                    
                    let id_user = json["user_data"]["id"].int
                    let nome_user = json["user_data"]["name"].stringValue
                    let cpf_user = json["user_data"]["cpf"].stringValue
                    
                    
                    KeychainWrapper.standard.set(nome_user, forKey: "NOME")
                    KeychainWrapper.standard.set(cpf_user, forKey: "CPF")
                    KeychainWrapper.standard.set(id_user!, forKey: "ID")
                    KeychainWrapper.standard.removeObject(forKey: "CPF-C")
                    
                    self.VerificaStatus(id_voluntario: id_user!)
                    KRProgressHUD.dismiss()
                    
                }
                
            case .failure(let error):
                
                    KRProgressHUD.showMessage("Erro de conexão")
                    print("error => ", error)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                
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
                    KeychainWrapper.standard.removeObject(forKey: "LOGIN")
                    KeychainWrapper.standard.removeObject(forKey: "SENHA")
                    
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
    func VerificaStatus(id_voluntario: Int){
        
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
                        vc.loginAux = self.loginAUX!
                        vc.senhaAux = self.senhaAUX!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        
                            self.registraLogin(id: id_voluntario, login: self.loginAUX!, senha: self.senhaAUX!)
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as! TabBarPrincipal
                       
                        self.navigationController?.pushViewController(vc, animated: true)
                        }}
                }else if id_status == 91{
                    //cadastrar user
                    self.registraLogin(id: id_voluntario, login: self.loginAUX!, senha: self.senhaAUX!)
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as! TabBarPrincipal
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
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
}



