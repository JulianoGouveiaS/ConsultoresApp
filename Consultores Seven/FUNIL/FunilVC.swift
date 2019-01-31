//
//  FunilVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 29/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import FirebaseFirestore
import KRProgressHUD

class FunilVC: UIViewController {

    @IBOutlet weak var CaptacoesTxtField: UITextField!
    @IBOutlet weak var LigacoesTxtField: UITextField!
    @IBOutlet weak var AgendamentosTxtField: UITextField!
    @IBOutlet weak var VisitasClientesTxtField: UITextField!
    @IBOutlet weak var PublicacoesTxtField: UITextField!
    @IBOutlet weak var VisitasParceirosTxtField: UITextField!
    @IBOutlet weak var ConhecerPessoasTxtField: UITextField!
    @IBOutlet weak var VendasTxtField: UITextField!
    @IBOutlet weak var EncantamentosTxtField: UITextField!
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    let db = Firestore.firestore()
    let date = Date()
    let calendar = Calendar.current
    var loginAux: String!
    var senhaAux: String!
    
    @IBOutlet weak var EnviarBttn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ClickEnviar(sender:Any){
        if CaptacoesTxtField.text! == "" || Int(CaptacoesTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if LigacoesTxtField.text! == "" || Int(LigacoesTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if AgendamentosTxtField.text! == "" || Int(AgendamentosTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if VisitasClientesTxtField.text! == "" || Int(VisitasClientesTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if PublicacoesTxtField.text! == "" || Int(PublicacoesTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if PublicacoesTxtField.text! == "" || Int(PublicacoesTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if VisitasParceirosTxtField.text! == "" || Int(VisitasParceirosTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if ConhecerPessoasTxtField.text! == "" || Int(ConhecerPessoasTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if VendasTxtField.text! == "" || Int(VendasTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else if EncantamentosTxtField.text! == "" || Int(EncantamentosTxtField.text!) ?? 0 <= 0{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher todos os campos!", acaoAlerta: "OK")
        }else{
            self.enviaCaptações()
        }
        
    }
    
    
    

    func enviaCaptações(){
        KRProgressHUD.show(withMessage: "Enviando Informações...", completion: nil)
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("Captacoes").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(CaptacoesTxtField.text!)!] as [String : Any]
        
            usersReference.setData(values) { (error) in
                if error != nil{
                    print("erro =>", error)
                    self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                    self.enviaCaptações()
                }else{
                    print("captacao enviada")
                    self.enviaLigacoes()
                }
            }
        }
    
    func enviaLigacoes(){
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("Ligacoes").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(LigacoesTxtField.text!)!] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro =>", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                self.enviaLigacoes()
            }else{
                print("Ligacoes enviada")
                self.enviaAgendamentos()
            }
        }
    }
    
    func enviaAgendamentos(){
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("Agendamentos").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(AgendamentosTxtField.text!)!] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro =>", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                self.enviaAgendamentos()
            }else{
                print("Agendamentos enviada")
                self.enviaVisClientes()
            }
        }
    }
    
    func enviaVisClientes(){
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("VisitasClientes").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(VisitasClientesTxtField.text!)!] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro =>", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                self.enviaVisClientes()
            }else{
                print("visitas clientes enviada")
                self.enviaPublicacoes()
            }
        }
    }
    
    func enviaPublicacoes(){
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("Publicacoes").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(PublicacoesTxtField.text!)!] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro =>", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                self.enviaPublicacoes()
            }else{
                print("publicacoes enviada")
                self.enviaVisParceiros()
            }
        }
    }
    
    func enviaVisParceiros(){
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("VisitasParceiros").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(VisitasParceirosTxtField.text!)!] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro =>", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                self.enviaVisParceiros()
            }else{
                print("visitas clientes enviada")
                self.enviaConhecer()
            }
        }
    }
    
    func enviaConhecer(){
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("ConhecerPessoas").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(ConhecerPessoasTxtField.text!)!] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro =>", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                self.enviaConhecer()
            }else{
                print("conhecer pessoas enviada")
                self.enviaVendas()
            }
        }
    }
    
    func enviaVendas(){
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("Vendas").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(VendasTxtField.text!)!] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro =>", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                self.enviaVendas()
            }else{
                print("vendas enviada")
                self.enviaEncantamentos()
            }
        }
    }
    
    func enviaEncantamentos(){
        let dia = calendar.component(.day, from: date)
        var diaAux = ""
        if dia < 10{
            diaAux = "0\(dia)"
        }else{
            diaAux = "\(dia)"
        }
        let mes = calendar.component(.month, from: date)
        var mesAux = ""
        if mes < 10{
            mesAux = "0\(mes)"
        }else{
            mesAux = "\(mes)"
        }
        let ano = calendar.component(.year, from: date)
        var anoAux = ""
        if ano < 10{
            anoAux = "0\(ano)"
        }else{
            anoAux = "\(ano)"
        }
        let usersReference = self.db.collection("FunilConsultores").document("Encantamentos").collection("\(self.id_user!)").document("\(anoAux)-\(mesAux)-\(diaAux)")
        
        let values = ["data": "\(anoAux)-\(mesAux)-\(diaAux)", "id_user": self.id_user!, "quantidade": Int(EncantamentosTxtField.text!)!] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro =>", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar dados!", acaoAlerta: "OK", erroRecebido: "\(error)")
                self.enviaEncantamentos()
            }else{
                print("FUNIL ENVIADO")
                KRProgressHUD.dismiss()
                self.registraLogin(id: self.id_user!, login: self.loginAux, senha: self.senhaAux);
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as! TabBarPrincipal
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
