//
//  PagarVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 18/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Stripe
import KRProgressHUD
import Alamofire
import SwiftyJSON
import FirebaseFirestore
import SwiftyPickerPopover

class PagarVC: UIViewController, UITextFieldDelegate {
    
    var propostaEscolhida: Proposta!
    @IBOutlet weak var tipoView: UIView!
    @IBOutlet weak var formaPgtoView: UIView!

    @IBOutlet weak var numCartaoLbl: UITextField!
    @IBOutlet weak var vencimentoLbl: UITextField!
    @IBOutlet weak var cvvLbl: UITextField!
    
    @IBOutlet weak var comprovanteViewMenor: UIView!
    @IBOutlet weak var comprovanteView: UIView!
    @IBOutlet weak var idVendaLbl: UILabel!
    @IBOutlet weak var nomeLbl: UILabel!
    @IBOutlet weak var cartaoLbl: UILabel!
    @IBOutlet weak var placaLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var parcelasLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var placaTxt: UITextField!
    @IBOutlet weak var valorAdesaoTxt: UITextField!
    @IBOutlet weak var formaPgtoTxt: UITextField!
    @IBOutlet weak var tipoTxt: UITextField!
    @IBOutlet weak var nomeCartaoTxt: UITextField!
    
    let db = Firestore.firestore()
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    var formaPagArr = ["À VISTA", "2 VEZES"]
    var formaPagSelectedIndexStr = "0"
    var TipoPagArr = ["TIPO DE PAGAMENTO", "ADESÃO", "SUBSTITUIÇÃO", "REATIVAÇÃO"]
    var tipoSelectedIndexStr = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preencheCampos()
        getCampos()
        
        let tapFormasPag = UITapGestureRecognizer(target: self, action: #selector(self.clickFormasPag))
        formaPgtoView.addGestureRecognizer(tapFormasPag)
        
        let tapTiposPag = UITapGestureRecognizer(target: self, action: #selector(self.clickTiposPag))
        tipoView.addGestureRecognizer(tapTiposPag)
        
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string )
        
        
        if self.numCartaoLbl == textField {
            numCartaoLbl.text = lastText.format("NNNNNNNNNNNNNNNN", oldString: text)
            
            return false
        }else if self.vencimentoLbl == textField {
            vencimentoLbl.text = lastText.format("NN/NN", oldString: text)
            
            return false
        }else if self.cvvLbl == textField {
            cvvLbl.text = lastText.format("NNN", oldString: text)
            
            return false
        }
        return true
    }
    
    func clickFormasPag(_ sender: AnyObject) {
        let p = StringPickerPopover(title: "Formas de Pagamento", choices: formaPagArr )
            .setDoneButton(action: {
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
                self.formaPagSelectedIndexStr = "\(selectedRow)"
                self.formaPgtoTxt.text = selectedString
            })
            .setCancelButton(action: { _, _, _ in
                print("cancel")
            })
        
        p.appear(originView: self.formaPgtoView, baseViewController: self)
    }
    
    func clickTiposPag(_ sender: AnyObject) {
        let p = StringPickerPopover(title: "Tipos", choices: TipoPagArr )
            .setDoneButton(action: {
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
                self.tipoSelectedIndexStr = "\(selectedRow)"
                self.tipoTxt.text = selectedString
            })
            .setCancelButton(action: { _, _, _ in
                print("cancel")
            })
        
        p.appear(originView: self.tipoView, baseViewController: self)
    }
   
    func preencheCampos(){
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                
                if dictionary?["situacao"] as? String != "4" && dictionary?["situacao"] as? String != "3"{
                    self.comprovanteView.isHidden = true
                    self.numCartaoLbl.isHidden = false
                }else{
                    self.comprovanteView.isHidden = false
                    self.numCartaoLbl.isHidden = true
                   
                }
                
                self.placaTxt.text = dictionary?["placa"] as? String ?? ""
                self.valorAdesaoTxt.text = "\(dictionary?["valoradesao"] as? String ?? "0,00")"
                self.formaPgtoTxt.text = self.formaPagArr[0]
                self.tipoTxt.text = self.TipoPagArr[0]
                
            }
        }
    }
    @objc func salvarComprovante(){
        let imgComprovante = self.comprovanteViewMenor.asImage()
            UIImageWriteToSavedPhotosAlbum(imgComprovante, self, nil, nil)
        KRProgressHUD.showMessage("Comprovante Salvo")
    }
    func checkCampos(){
        
        if self.placaTxt.text == "" {
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Placa não informada.", acaoAlerta: "Ok")
            return
        }else
        if self.valorAdesaoTxt.text == "" {
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Valor de Adesão não informado.", acaoAlerta: "Ok")
        }else
        if self.tipoTxt.text == self.TipoPagArr[0] {
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Tipo de pagamento não informado", acaoAlerta: "Ok")
            return
        }else
        if self.numCartaoLbl.text == ""{
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Número do cartão não informado.", acaoAlerta: "Ok")
            return
        }else
        if self.cvvLbl.text == "" {
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "CVV não informado.", acaoAlerta: "Ok")
            return
        }else
        if self.vencimentoLbl.text == "" {
            CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Data de vencimento não informada.", acaoAlerta: "Ok")
            return
        }else
            if self.vencimentoLbl.text!.count != 5 {
                CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Data de vencimento inválida.", acaoAlerta: "Ok")
                return
            }else{
            let ano = self.vencimentoLbl.text!.substring(from: self.vencimentoLbl.text!.index(self.vencimentoLbl.text!.endIndex, offsetBy: -2))
            self.EnviarPagamento(num: self.numCartaoLbl.text!, id_user: self.id_user!, placa: self.placaTxt.text!, vl_pagamento: self.valorAdesaoTxt.text!, num_parcelas: self.formaPagSelectedIndexStr, cvv: self.cvvLbl.text!, local_origem: "0", nomeCartao: self.nomeCartaoTxt.text!, mes: String(self.vencimentoLbl.text!.prefix(2)), ano: "20\(ano)", tipopag: self.tipoSelectedIndexStr)
        }
    }
    
    func pagar(){
         self.checkCampos()
    }
    
    func EnviarPagamento(num:String, id_user:Int, placa:String, vl_pagamento:String, num_parcelas:String, cvv: String, local_origem: String, nomeCartao: String, mes:String, ano: String, tipopag: String){
        KRProgressHUD.show()
        var mesAux = mes
        
        let parameters = [
            "num"           : num,
            "id_user"       : id_user,
            "placa"         : placa,
            "vl_pagamento"  : "\(vl_pagamento),00",
            "num_parcelas"  : num_parcelas,
            "cvv"           : cvv,
            "local_origem"  : local_origem,
            "nm_cartao"     : nomeCartao,
            "mes"           : mesAux,
            "ano"           : ano,
            "tipopag"       : tipopag] as [String : Any]
        
        print("parameters =>", parameters)
        let url = "https://sevenprotecaoveicular.com.br/Api/CartaoApp"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                if json["user_data"]["id"].stringValue != "00" && json["user_data"]["id"].stringValue != "000"{
                    let msg = json["user_data"]["mensagem"].stringValue
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: msg, acaoAlerta: "Ok", erroRecebido: "\(JSON(value))")
                    
                    KRProgressHUD.dismiss()
                }else{
                    
                    let data = json["user_data"]["data"].stringValue
                    let id_pagamento = json["user_data"]["id_pagamento"].stringValue
                    let numero = json["user_data"]["numero"].stringValue
                    let parcelas = json["user_data"]["parcelas"].intValue
                    
                    self.mudaSituacao(situacao: "4")
                    
                    let db = Firestore.firestore()
                    let usersReference = db.collection("ConsultorSeven").document("ComprovantesPagamentos").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)")
                    let values = ["data": data, "id_venda": id_pagamento, "nome": self.nomeCartaoTxt.text!, "numero": numero, "parcelas": "\(parcelas)", "placa": self.placaTxt.text!, "valor": self.valorAdesaoTxt.text!] as [String : Any]
                    usersReference.setData(values) { (error) in
                        if error != nil{
                            print("erro ao cadastrar no firebase")
                            self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(String(describing: error))")
                            KRProgressHUD.dismiss()
                        }else{
                            print("cadastrado no firebase com sucesso")
                            KRProgressHUD.dismiss()
                        }
                    }
                   
                    KRProgressHUD.showSuccess()
                    
                }
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                
                self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Encontramos um erro no pagamento!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                
            }
            
        }
    }
    
    func mudaSituacao(situacao:String){
        
        KRProgressHUD.show()
        let usersReference = db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)")
        
        let values = ["situacao": situacao]  as [String : Any]
        
        usersReference.updateData(values) { (error) in
            if error != nil{
                print("erro ao cadastrar no firebase", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao acessar proposta no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                KRProgressHUD.dismiss()
                return
            }else{
                KRProgressHUD.dismiss()
            }
        }
    }
    
    func getCampos(){
        
        db.collection("ConsultorSeven").document("ComprovantesPagamentos").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                
                self.dataLbl.text = dictionary?["data"] as? String ?? ""
                self.idVendaLbl.text = dictionary?["id_venda"] as? String ?? ""
                self.nomeLbl.text = dictionary?["nome"] as? String ?? ""
                self.cartaoLbl.text = dictionary?["numero"] as? String ?? ""
                self.parcelasLbl.text = "\(dictionary?["parcelas"] as? Int ?? 0)"
                self.placaLbl.text = dictionary?["placa"] as? String ?? ""
                self.totalLbl.text = dictionary?["valor"] as? String ?? "" + ",00"
               
    
            }
            
        }
        
    }
    
}
