//
//  VeiculoVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Alamofire
import SwiftyJSON
import SwiftyPickerPopover

class VeiculoVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewComb: UIView!
    @IBOutlet weak var viewCor: UIView!
    var propostaEscolhida: Proposta!
    let db = Firestore.firestore()
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    var idTabela = 1
    
    let kCep: String!         = "cep";
    let kUF: String!          = "uf"
    let kLocalidade: String!  = "localidade"
    let kBairro: String!      = "bairro"
    let kLogradouro: String!  = "logradouro"
    let kComplemento: String! = "complemento"
    let kUnidade: String!     = "unidade"
    let kIbge: String!        = "ibge"
    let kGia: String!         = "gia"
    
    @IBOutlet weak var ano_fabTxt: UITextField!
    @IBOutlet weak var ano_modeloTxt: UITextField!
    @IBOutlet weak var fipeTxt: UITextField!
    @IBOutlet weak var valor_fipeTxt: UITextField!
    @IBOutlet weak var tipoTxt: UITextField!
    @IBOutlet weak var placaTxt: UITextField!
    @IBOutlet weak var renavamTxt: UITextField!
    @IBOutlet weak var chassiTxt: UITextField!
    @IBOutlet weak var combustivelTxt: UITextField!
    @IBOutlet weak var corTxt: UITextField!
    
    var arrAllProducts = [Produto]()
    var arrChosenProducts = [Produto]()
    
    var arrComb = ["Selecione o Combustível","FLEX","GASOLINA","ETANOL","DIESEL","BIO-GÁS","TETRA-FUEL","NÃO INFORMADO"]
    
    var arrCor = ["Selecione uma Cor","PRETO","BRANCO","AZUL","VERMELHO","VERDE","CINZA","BEGE","AMARELO","PRATA","NÃO ESPECIFICADO","DOURADO","LARANJA","MARROM","FANTASIA","ROXO","ROSA","OURO"]
    
    var valorMensal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       preencheCampos()
        // Do any additional setup after loading the view.
        let tapComb = UITapGestureRecognizer(target: self, action: #selector(self.clickComb))
        viewComb.addGestureRecognizer(tapComb)
        
        let tapCor = UITapGestureRecognizer(target: self, action: #selector(self.clickCor))
        viewCor.addGestureRecognizer(tapCor)
        
    }
    
    func preencheCampos(){
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                
                self.ano_fabTxt.text = dictionary?["anofabricacao"] as? String ?? ""
                self.ano_modeloTxt.text = dictionary?["anomodelo"] as? String ?? ""
                self.fipeTxt.text = dictionary?["fipe"] as? String ?? ""
                self.valor_fipeTxt.text = dictionary?["valorveiculo"] as? String ?? ""
                self.tipoTxt.text = dictionary?["ddltabela"] as? String ?? ""
                self.placaTxt.text = dictionary?["placa"] as? String ?? ""
                self.renavamTxt.text = dictionary?["renavam"] as? String ?? ""
                self.chassiTxt.text = dictionary?["chassi"] as? String ?? ""
                self.valorMensal = dictionary?["valormensal"] as? String ?? ""
                self.combustivelTxt.text = self.arrComb[Int(dictionary?["combustivel"] as? String ?? "0") ?? 0]
                self.corTxt.text = self.arrCor[Int(dictionary?["cor"] as? String ?? "0") ?? 0]
            }
        }
    }
    
    
        // function which is triggered when handleTap is called
        func clickComb(_ sender: AnyObject) {
            dismissKeyboard()
            let p = StringPickerPopover(title: "Combustíveis", choices: arrComb)
                .setDoneButton(action: {
                    popover, selectedRow, selectedString in
                    print("done row \(selectedRow) \(selectedString)")
                    self.combustivelTxt.text = selectedString
                })
                .setCancelButton(action: { _, _, _ in
                    print("cancel")
                })
            
            p.appear(originView: self.viewComb, baseViewController: self)
        }
    
    
    func clickCor(_ sender: AnyObject) {
        dismissKeyboard()
        let p = StringPickerPopover(title: "Cores", choices: arrCor )
            .setDoneButton(action: {
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
                self.corTxt.text = selectedString
            })
            .setCancelButton(action: { _, _, _ in
                print("cancel")
            })
        
        p.appear(originView: self.viewCor, baseViewController: self)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string )
        
        
        if self.ano_modeloTxt == textField {
            ano_modeloTxt.text = lastText.format("NNNN", oldString: text)
            return false
        }else if self.ano_fabTxt == textField {
            ano_fabTxt.text = lastText.format("NNNN", oldString: text)
            return false
        }else if self.chassiTxt == textField {
            chassiTxt.text = lastText.format("XXXXXXXXXXXXXXXXX", oldString: text)
            return false
        }
        return true
    }
    
    func checkFipe(fipe: String, modelo: String){
        KRProgressHUD.show()
        
            let parameters = ["ano": modelo,"fipe": fipe] as [String : Any]
        
            let url = "https://sevenprotecaoveicular.com.br/Api/FipeAno"
            Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    
                    let valor = json["user_data"]["valor"].stringValue
                    self.valor_fipeTxt.text = valor
                    
                    let dlltabelaa = json["user_data"]["tabela"].int!
                    self.idTabela = dlltabelaa
                    
                   self.valorMensal = json["user_data"]["valor_mes"].stringValue
//
//                    let valor1 = valor_mes.replacingOccurrences(of: ".", with: "")
//                    let valorNew = valor1.replacingOccurrences(of: ",", with: ".")
//
//                    self.valorveicLabel.text = valorNew
                    
                    let nm_tabela = json["user_data"]["nm_tabela"].stringValue
                    self.tipoTxt.text = nm_tabela
                    
                    for i in 0...json["produtos"].count - 1{
                        let produto = Produto()
                            produto.id = json["produtos"][i]["id"].int
                            produto.nome = json["produtos"][i]["descricao_produto"].stringValue
                            produto.valor = json["produtos"][i]["valor_produto"].stringValue
                        
                        self.arrAllProducts.append(produto)
                    }
                    
                    self.salvarCampos()
                    
                    KRProgressHUD.showMessage("Completed!")
                    
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Insira o ano e o código FIPE corretamente!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    print("erro: \(error)")
                    
                }
            }
    }
    
    
    @IBAction func calculaFipe(_ sender: Any){
        checkFipe(fipe: self.fipeTxt.text!, modelo: self.ano_modeloTxt.text!)
    
    }
    
    func salvarCampos(){
     
        if self.ano_fabTxt.text!.count != 4{
            self.ano_fabTxt.text = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Ano de fabricação inválido.", acaoAlerta: "Ok")
            return
          
        }
        
        if self.ano_modeloTxt.text!.count != 4{
            self.ano_modeloTxt.text = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Ano do modelo inválido.", acaoAlerta: "Ok")
            return
        }
        
        if self.chassiTxt.text!.count != 17{
            self.chassiTxt.text = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Chassi inválido.", acaoAlerta: "Ok")
            return
        }
        
        let indexComb = self.arrComb.index(of: self.combustivelTxt.text!)
        if indexComb == 0{
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Selecione o combustível.", acaoAlerta: "Ok")
            return
        }
        let indexCor = self.arrCor.index(of: self.corTxt.text!)
        
        if indexCor == 0{
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Selecione a cor.", acaoAlerta: "Ok")
            return
        }
        
        let usersReference = db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)")
        
        let values = [
            "anofabricacao": self.ano_fabTxt.text!,
            "anomodelo": self.ano_modeloTxt.text!,
            "fipe": self.fipeTxt.text!,
            "valorveiculo": "\(self.valor_fipeTxt.text!)",
            "ddltabela": "\(self.tipoTxt.text!)",
            "placa": "\(self.placaTxt.text!)",
            "renavam": "\(self.renavamTxt.text!)",
            "chassi": self.chassiTxt.text!,
            "combustivel": "\(indexComb!)",
            "cor": "\(indexCor!)",
            "dlltabelaa": "\(self.idTabela)",
            "valormensal": self.valorMensal]
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
    
}
