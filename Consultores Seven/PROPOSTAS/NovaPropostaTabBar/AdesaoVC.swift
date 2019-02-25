//
//  AdesaoVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 11/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Alamofire
import SwiftyJSON
import Static
import SwiftyPickerPopover

class AdesaoVC: UIViewController, UITextFieldDelegate {
    
    var propostaEscolhida: Proposta!
    let db = Firestore.firestore()
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    let kCep: String!         = "cep";
    let kUF: String!          = "uf"
    let kLocalidade: String!  = "localidade"
    let kBairro: String!      = "bairro"
    let kLogradouro: String!  = "logradouro"
    let kComplemento: String! = "complemento"
    let kUnidade: String!     = "unidade"
    let kIbge: String!        = "ibge"
    let kGia: String!         = "gia"
    
    @IBOutlet weak var valorAdesaoTxt: UITextField!
    @IBOutlet weak var valorMensalTxt: UITextField!
    @IBOutlet weak var dtVistoriaTxt: UITextField!
    @IBOutlet weak var dtPropostaTxt: UITextField!
    @IBOutlet weak var obsTxtView: UITextView!
    @IBOutlet weak var danosMateriaisBox: M13Checkbox!
    @IBOutlet weak var CopartBox: M13Checkbox!
    @IBOutlet weak var protVidrosBox: M13Checkbox!
    @IBOutlet weak var cartaoPremBox: M13Checkbox!
    @IBOutlet weak var rastreadorBox: M13Checkbox!
    @IBOutlet weak var uberBox: M13Checkbox!
    @IBOutlet weak var avariasBox: M13Checkbox!
    @IBOutlet weak var pctPremiumSegmented: UISegmentedControl!
    @IBOutlet weak var carroReservaSegmented: UISegmentedControl!
    @IBOutlet weak var ass24hSegmented: UISegmentedControl!
    @IBOutlet weak var tpProtecaoSegmented: UISegmentedControl!
    @IBOutlet weak var tpVeicSegmented: UISegmentedControl!

    
    @IBOutlet weak var viewTotalVl: UIView!
    
    @IBOutlet weak var valorAdicionalLbl: UILabel!
    @IBOutlet weak var valorTotalLbl: UILabel!
    
    
    var carres15 = false
    var carres30 = false
    var pctprem15 = false
    var pctprem30 = false
    var km1000 = false
    var km700 = false
    var km500 = false
    var tpProt = "1"
    var tpVeic = "1"
    
    var idTabela = "1"
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dtVistoriaTxt.delegate = self
        dtPropostaTxt.delegate = self
        self.viewTotalVl.layer.borderWidth = 0.5
        self.viewTotalVl.layer.borderColor = UIColor.lightGray.cgColor
        preencheCampos()
        // Do any additional setup after loading the view.
    }
    
    func handleOpcionais(Enable: Bool){
       self.danosMateriaisBox.isEnabled = Enable
       self.CopartBox.isEnabled = Enable
       self.protVidrosBox.isEnabled = Enable
       self.cartaoPremBox.isEnabled = Enable
       self.rastreadorBox.isEnabled = Enable
       self.uberBox.isEnabled = Enable
       self.avariasBox.isEnabled = Enable
       self.pctPremiumSegmented.isEnabled = Enable
       self.carroReservaSegmented.isEnabled = Enable
       self.ass24hSegmented.isEnabled = Enable
       self.tpProtecaoSegmented.isEnabled = Enable
       self.tpVeicSegmented.isEnabled = Enable
    }
    
    func salvarCampos(){
        
        if self.dtVistoriaTxt.text!.count != 10{
            self.dtVistoriaTxt.text! = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Data de vistoria inválida.", acaoAlerta: "Ok")
            return
        }
        
        if self.dtPropostaTxt.text!.count != 10{
            self.dtPropostaTxt.text! = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Data de proposta inválida.", acaoAlerta: "Ok")
            return
        }
        
        if self.valorAdesaoTxt.text! != ""{
            let valorColocado: Int! = Int(self.valorAdesaoTxt.text!)!
            if valorColocado < 150{
                self.valorAdesaoTxt.text! = ""
                CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "O valor da adesão deve ser maior que 150 reais.", acaoAlerta: "Ok")
                return
            }
        }else{
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Valor de adesão inválido", acaoAlerta: "Ok")
            return
        }
        
        if self.dtPropostaTxt.text!.count != 10{
            self.dtPropostaTxt.text! = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Data de proposta inválida", acaoAlerta: "Ok")
            return
        }
        var auxVidros = false
        if self.tpVeic == "1"{
            auxVidros = self.protVidrosBox.isChecked
        }
        
        let usersReference = db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)")

        let values = [
            "valoradesao": self.valorAdesaoTxt.text!,
            "valormensal": self.valorMensalTxt.text!,
            "dtvistoria": "\(self.dtVistoriaTxt.text!)",
            "dtproposta": "\(self.dtPropostaTxt.text!)",
            "obs": "\(self.obsTxtView.text!)",
            "danosterceiros": self.danosMateriaisBox.isChecked,
            "coparticipacaored": self.CopartBox.isChecked,
            "protvidro": auxVidros,
            "cartaopremio": self.cartaoPremBox.isChecked,
            "rastreadorparceirosv": self.rastreadorBox.isChecked,
            "uber": self.uberBox.isChecked,
            "avarias": self.avariasBox.isChecked,
            "carres15": self.carres15,
            "carres30": self.carres30,
            "pctpremio15": self.pctprem15,
            "pctpremio30": self.pctprem30,
            "km1000": self.km1000,
            "km700": self.km700,
            "km500": self.km500,
            "seguro": self.tpProt,
            "tpveiculo": self.tpVeic
            ]
            as [String : Any]

        usersReference.updateData(values) { (error) in
            if error != nil{
                print("erro ao atualizar => ", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                return
            }else{
                print("visita atualizada no firebase com sucesso")

                KRProgressHUD.showMessage("Atualizado")
            }
        }
    }
    
    func preencheCampos(){
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                
                self.valorAdesaoTxt.text = dictionary?["valoradesao"] as? String ?? ""
                self.valorMensalTxt.text = dictionary?["valormensal"] as? String ?? ""
                if self.valorMensalTxt.text == ""{
                    self.handleOpcionais(Enable: false)
                }else{
                    self.handleOpcionais(Enable: true)
                }
                
                self.valorTotalLbl.text = dictionary?["valormensal"] as? String ?? ""
                self.dtVistoriaTxt.text = dictionary?["dtvistoria"] as? String ?? ""
                self.dtPropostaTxt.text = dictionary?["dtproposta"] as? String ?? ""
                self.obsTxtView.text = dictionary?["obs"] as? String ?? ""
                self.idTabela = dictionary?["dlltabelaa"] as? String ?? ""
                
                self.preencheCheckBox(estado: dictionary?["danosterceiros"] as? Bool ?? false, checkBox: self.danosMateriaisBox)
                self.preencheCheckBox(estado: dictionary?["coparticipacaored"] as? Bool ?? false, checkBox: self.CopartBox)
                self.preencheCheckBox(estado: dictionary?["protvidro"] as? Bool ?? false, checkBox: self.protVidrosBox)
                self.preencheCheckBox(estado: dictionary?["cartaopremio"] as? Bool ?? false, checkBox: self.cartaoPremBox)
                self.preencheCheckBox(estado: dictionary?["rastreadorparceirosv"] as? Bool ?? false, checkBox: self.rastreadorBox)
                self.preencheCheckBox(estado: dictionary?["uber"] as? Bool ?? false, checkBox: self.uberBox)
                self.preencheCheckBox(estado: dictionary?["avarias"] as? Bool ?? false, checkBox: self.avariasBox)
                
                if (dictionary?["carres15"] as? Bool ?? false) == true{
                    self.carroReservaSegmented.selectedSegmentIndex = 1
                    self.carres15 = true
                    self.carres30 = false
                }else if (dictionary?["carres30"] as? Bool ?? false) == true{
                    self.carroReservaSegmented.selectedSegmentIndex = 2
                    self.carres15 = false
                    self.carres30 = true
                }else{
                    self.carroReservaSegmented.selectedSegmentIndex = 0
                    self.carres15 = false
                    self.carres30 = false
                }
                
                if (dictionary?["pctpremio15"] as? Bool ?? false) == true{
                    self.pctPremiumSegmented.selectedSegmentIndex = 1
                    self.pctprem15 = true
                    self.pctprem30 = false
                    
                    if self.idTabela != "0"{
                        if self.idTabela == "1" || self.idTabela == "2"{
                        } else if self.idTabela == "5" || self.idTabela == "6" {
                        }
                    }
                }else if (dictionary?["pctpremio30"] as? Bool ?? false) == true{
                    self.pctPremiumSegmented.selectedSegmentIndex = 2
                    self.pctprem15 = false
                    self.pctprem30 = true
                    
                    if self.idTabela != "0"{
                        if self.idTabela != "3" {
                        }
                    }
                }else{
                    self.pctPremiumSegmented.selectedSegmentIndex = 0
                    self.pctprem15 = false
                    self.pctprem30 = false
                }
                
                if (dictionary?["km1000"] as? Bool ?? false) == true{
                    self.ass24hSegmented.selectedSegmentIndex = 1
                    self.km1000 = true
                    self.km700 = false
                    self.km500 = false
                    
                    if self.idTabela != "0"{
                    }
                }else if (dictionary?["km700"] as? Bool ?? false) == true{
                    self.ass24hSegmented.selectedSegmentIndex = 2
                    self.km1000 = false
                    self.km700 = true
                    self.km500 = false
                    if self.idTabela != "0"{
                    }
                }else if (dictionary?["km500"] as? Bool ?? false) == true{
                    self.ass24hSegmented.selectedSegmentIndex = 3
                    self.km1000 = false
                    self.km700 = false
                    self.km500 = true
                    
                    if self.idTabela != "0"{
                        if self.idTabela == "3"{
                        }else{
                        }
                    }
                }else{
                    self.ass24hSegmented.selectedSegmentIndex = 0
                    self.km1000 = false
                    self.km700 = false
                    self.km500 = false
                }
                
                if (dictionary?["seguro"] as? String ?? "0") == "1"{
                    self.tpProtecaoSegmented.selectedSegmentIndex = 0
                    self.tpProt = "1"
                    
                }else if (dictionary?["seguro"] as? String ?? "0") == "2"{
                    self.tpProtecaoSegmented.selectedSegmentIndex = 2
                    self.tpProt = "2"
                   
                }else if (dictionary?["seguro"] as? String ?? "0") == "3"{
                    self.tpProtecaoSegmented.selectedSegmentIndex = 1
                    self.tpProt = "3"
                }else{
                    self.tpProtecaoSegmented.selectedSegmentIndex = 0
                    self.tpProt = "1"
                }
                
                if (dictionary?["tpveiculo"] as? String ?? "0") == "1"{
                    self.tpVeicSegmented.selectedSegmentIndex = 0
                    self.tpVeic = "1"
                }else if (dictionary?["tpveiculo"] as? String ?? "0") == "2"{
                    self.tpVeicSegmented.selectedSegmentIndex = 1
                    self.tpVeic = "2"
                }else{
                    self.tpVeicSegmented.selectedSegmentIndex = 0
                    self.tpVeic = "1"
                    
                }
            }
        }
    }
    
    @IBAction func pctPremiumClick(_ sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            if self.idTabela != "0"{
                if self.idTabela == "1" || self.idTabela == "2"{
                    if self.pctprem15 == true{
                        handleValorAdicional(adicionar: false, valor: 39.90)
                    }else if self.pctprem30 == true{
                        handleValorAdicional(adicionar: false, valor: 69.90)
                    }
                } else if self.idTabela == "5" || self.idTabela == "6" {
                    if pctprem15 == true{
                        handleValorAdicional(adicionar: false, valor: 54.90)
                    }else if self.pctprem30 == true{
                        handleValorAdicional(adicionar: false, valor: 69.90)
                    }
                }
            }
            
            self.pctprem15 = false
            self.pctprem30 = false
            
        case 1:
            if pctprem30 == true{
                if self.idTabela != "0"{
                    if self.idTabela != "3" {
                        handleValorAdicional(adicionar: false, valor: 69.90)
                    }
                }
            }
            
            if self.idTabela != "0"{
                if self.idTabela == "1" || self.idTabela == "2"{
                    handleValorAdicional(adicionar: true, valor: 39.90)
                } else if self.idTabela == "5" || self.idTabela == "6" {
                    handleValorAdicional(adicionar: true, valor: 54.90)
                }
            }
            
            self.pctprem15 = true
            self.pctprem30 = false
        case 2:
            
            if pctprem15 == true{
                if self.idTabela != "0"{
                    if self.idTabela == "1" || self.idTabela == "2"{
                        handleValorAdicional(adicionar: false, valor: 39.90)
                    } else if self.idTabela == "5" || self.idTabela == "6" {
                        handleValorAdicional(adicionar: false, valor: 54.90)
                    }
                }
            }
            
            if self.idTabela != "0"{
                if self.idTabela != "3" {
                    handleValorAdicional(adicionar: true, valor: 69.90)
                }
            }
            
            self.pctprem15 = false
            self.pctprem30 = true
        default:
            self.pctprem15 = false
            self.pctprem30 = false
        }
    }
    
    func handleValorAdicional(adicionar: Bool, valor: Float){
        if let valorM = Float(self.valorMensalTxt.text!.replace(target: ",", withString:".")) {
            
            if adicionar{
                self.valorMensalTxt.text = "\(valorM + valor)"
            }else{
                self.valorMensalTxt.text = "\(valorM - valor)"
            }
        } else {
            print("Not a valid number: \(self.valorMensalTxt.text!)")
        }
        
        if let valorAdicional = Float(self.valorAdicionalLbl.text!) {
            if let valorMensal = Float(self.valorMensalTxt.text!.replace(target: ",", withString:".") ) {
                self.valorMensalTxt.text = "\(valorAdicional + valorMensal)"
            }
        }
        
    }
    
    
    @IBAction func DanosTercClick(_ sender: Any) {
        
        if self.idTabela != "0"{
            if self.idTabela == "3"{
                if danosMateriaisBox.isChecked{
                   handleValorAdicional(adicionar: true, valor: 30.00)
                }else{
                    handleValorAdicional(adicionar: false, valor: 30.00)
                }
            }else{
                if danosMateriaisBox.isChecked{
                    handleValorAdicional(adicionar: true, valor: 15.00)
                }else{
                    handleValorAdicional(adicionar: false, valor: 15.00)
                }
            }}
    }
    
    @IBAction func COparticipacaoClick(_ sender: Any) {
        if self.idTabela != "0"{
            if self.idTabela == "6" || self.idTabela == "7"{
                if CopartBox.isChecked {
                    handleValorAdicional(adicionar: true, valor: 30.00)
                }else{
                    handleValorAdicional(adicionar: false, valor: 30.00)
                }
            }else{
                if CopartBox.isChecked{
                    handleValorAdicional(adicionar: true, valor: 15.00)
                }else{
                    handleValorAdicional(adicionar: false, valor: 15.00)
                }
            }
        }
    }
    
    
    @IBAction func vidro80Click(_ sender: Any) {
        if self.idTabela != "0"{
            if protVidrosBox.isChecked{
                handleValorAdicional(adicionar: true, valor: 15.00)
            }else{
                handleValorAdicional(adicionar: false, valor: 15.00)
            }
        }
    }
    
    
    @IBAction func cartaoClick(_ sender: Any) {
        if self.idTabela != "0"{
            if cartaoPremBox.isChecked{
                handleValorAdicional(adicionar: true, valor: 20.00)
            }else{
                handleValorAdicional(adicionar: false, valor: 20.00)
            }
        }
    }
    
    @IBAction func rastreadorClick(_ sender: Any) {
        
        if rastreadorBox.isChecked{
            handleValorAdicional(adicionar: true, valor: 50.00)
        }else{
            handleValorAdicional(adicionar: false, valor: 50.00)
        }
    }
    
    @IBAction func uberClick(_ sender: Any) {
        if self.idTabela != "0"{
            if uberBox.isChecked == true{
                handleValorAdicional(adicionar: true, valor: 50.00)
            }else{
                handleValorAdicional(adicionar: false, valor: 50.00)
            }
        }
    }
    
    @IBAction func carresValueChange(_ sender: AnyObject){
        switch sender.selectedSegmentIndex {
        case 0:
            if self.carres15 == true{
                if self.idTabela != "0"{
                    if self.idTabela != "3"{
                        handleValorAdicional(adicionar: false, valor: 15.00)
                    }
                }
            }else if self.carres30 == true{
                if self.idTabela != "0"{
                    if self.idTabela != "3"{
                        handleValorAdicional(adicionar: false, valor: 30.00)
                    }
                }
            }
            self.carres15 = false
            self.carres30 = false
            
        case 1:
            if self.carres30 == true{
                if self.idTabela != "0"{
                    if self.idTabela != "3"{
                        handleValorAdicional(adicionar: false, valor: 30.00)
                    }
                }
            }
            handleValorAdicional(adicionar: true, valor: 15.00)
            self.carres15 = true
            self.carres30 = false
            
        case 2:
            if self.carres15 == true{
                if self.idTabela != "0"{
                    if self.idTabela != "3"{
                        handleValorAdicional(adicionar: false, valor: 15.00)
                    }
                }
            }
            
            handleValorAdicional(adicionar: true, valor: 30.00)
            self.carres15 = false
            self.carres30 = true
        default:
            self.carres15 = false
            self.carres30 = false
        }
    }
    
    @IBAction func assistenciaValueChange(_ sender: AnyObject){
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            if self.km500 == true{
                if self.idTabela != "0"{
                    if self.idTabela == "3"{
                        handleValorAdicional(adicionar: false, valor: 25.00)
                    }else{
                        handleValorAdicional(adicionar: false, valor: 15.00)
                    }
                }
            }
            
            if self.km700 == true{
                if self.idTabela != "0"{
                    handleValorAdicional(adicionar: false, valor: 25.00)
                }
            }
            
            if self.km1000 == true{
                if self.idTabela != "0"{
                    handleValorAdicional(adicionar: false, valor: 35.00)
                }
            }
            
            self.km1000 = false
            self.km700 = false
            self.km500 = false
        case 1:
            
            if self.km500 == true{
                if self.idTabela != "0"{
                    if self.idTabela == "3"{
                        handleValorAdicional(adicionar: false, valor: 25.00)
                    }else{
                        handleValorAdicional(adicionar: false, valor: 15.00)
                    }
                }
            }
            
            if self.km700 == true{
                if self.idTabela != "0"{
                    handleValorAdicional(adicionar: false, valor: 25.00)
                }
            }
            
            
            if self.idTabela != "0"{
                handleValorAdicional(adicionar: true, valor: 35.00)
            }
            
            self.km1000 = true
            self.km700 = false
            self.km500 = false
        case 2:
            
            if self.km500 == true{
                if self.idTabela != "0"{
                    if self.idTabela == "3"{
                        handleValorAdicional(adicionar: false, valor: 25.00)
                    }else{
                        handleValorAdicional(adicionar: false, valor: 15.00)
                    }
                }
            }
            
            if self.km1000 == true{
                if self.idTabela != "0"{
                    handleValorAdicional(adicionar: false, valor: 35.00)
                }
            }
            
            if self.idTabela != "0"{
                handleValorAdicional(adicionar: true, valor: 25.00)
            }
            
            self.km1000 = false
            self.km700 = true
            self.km500 = false
        case 3:
            
            if self.km1000 == true{
                if self.idTabela != "0"{
                    handleValorAdicional(adicionar: false, valor: 35.00)
                }
            }
            
            if self.km700 == true{
                if self.idTabela != "0"{
                    handleValorAdicional(adicionar: false, valor: 25.00)
                }
            }
            
            if self.idTabela != "0"{
                if self.idTabela == "3"{
                    handleValorAdicional(adicionar: true, valor: 25.00)
                }else{
                    handleValorAdicional(adicionar: true, valor: 15.00)
                }
            }
            
            self.km1000 = false
            self.km700 = false
            self.km500 = true
        default:
            self.km1000 = false
            self.km700 = false
            self.km500 = false
        }
    }
    
    @IBAction func tpProtValueChange(_ sender: AnyObject){
        switch sender.selectedSegmentIndex {
        case 0:
            self.tpProt = "1"
        case 1:
            self.tpProt = "3"
        case 2:
            self.tpProt = "2"
        default:
            self.tpProt = "1"
        }
    }
    
    @IBAction func tpveiculoValueChange(_ sender: AnyObject){
        switch sender.selectedSegmentIndex {
        case 0:
            self.tpVeic = "1"
        case 1:
            self.tpVeic = "2"
        default:
            self.tpProt = "1"
        }
    }
    
    
    func preencheCheckBox(estado: Bool, checkBox: M13Checkbox){
        if estado == true{
            checkBox.setCheckState(.checked, animated: true)
        }else{
            checkBox.setCheckState(.unchecked, animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string )
        
        
        if self.dtVistoriaTxt == textField {
            dtVistoriaTxt.text = lastText.format("NN/NN/NNNN", oldString: text)
            
            return false
        }else if self.dtPropostaTxt == textField {
            dtPropostaTxt.text = lastText.format("NN/NN/NNNN", oldString: text)
            
            return false
        }
        return true
    }
    
    

}
