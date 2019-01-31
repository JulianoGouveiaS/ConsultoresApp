//
//  EditarCaptacaoViewController.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 08/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import FirebaseFirestore
import KRProgressHUD
import Alamofire
import SwiftyJSON
import CFAlertViewController

class EditarCaptacaoViewController: UIViewController, UITextFieldDelegate {

    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    @IBOutlet weak var origemLbl: UITextField!
    @IBOutlet weak var nomeLbl: UITextField!
    @IBOutlet weak var telLbl: UITextField!
    @IBOutlet weak var modeloLbl: UITextField!
    @IBOutlet weak var ano_modeloLbl: UITextField!
    @IBOutlet weak var placaLbl: UITextField!
    
    
    @IBOutlet weak var cancelarBttn: UIButton!
    @IBOutlet weak var finalizarBttn: UIButton!
    @IBOutlet weak var enviarBttn: UIButton!
    
    var captaçãoEscolhida: Captacao!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MakeButtonsNav()
        cancelarBttn.layer.cornerRadius = 7
        cancelarBttn.clipsToBounds = true
        
        finalizarBttn.layer.cornerRadius = 7
        finalizarBttn.clipsToBounds = true
        
        preencheCampos(cap: self.captaçãoEscolhida)
        // Do any additional setup after loading the view.
    }
    

    func preencheCampos(cap: Captacao){
        self.origemLbl.text = cap.origem
        self.nomeLbl.text = cap.nome
        self.telLbl.text = cap.telefone
        self.modeloLbl.text = cap.modelo_veiculo
        self.ano_modeloLbl.text = cap.ano_modelo
        self.placaLbl.text = cap.placa
    }
    
    @IBAction func enviarCaptacao(_ sender: Any) {
        
        
    }
    
    @IBAction func cancelarClick(_ sender: Any) {
        
        let alertController = CFAlertViewController(title: "Atenção",
                                                    message: "Deseja realmente cancelar essa captação?",
                                                    textAlignment: .center,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        
        // Create Upgrade Action
        let defaultAction = CFAlertAction(title: "Cancelar Captação",
                                          style: .Default,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(41.0 / 255.0), green: CGFloat(79.0 / 255.0), blue: CGFloat(118.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            let alertController = UIAlertController(title: "Cancelamento", message: "Por qual motivo você está cancelando esta captação?", preferredStyle: .alert)
                                            
                                            alertController.addTextField { (textField : UITextField!) -> Void in
                                                textField.placeholder = "Motivo"
                                            }
                                            let cancelarCap = UIAlertAction(title: "Pronto", style: .default, handler: { alert -> Void in
                                                let firstTextField = alertController.textFields![0] as UITextField
                                                if firstTextField.text! != ""{
                                                    self.mudaSituacao(status: "1", motivo: firstTextField.text!, captacao_enviada: "1")
                                                    _ = self.navigationController?.popViewController(animated: true)
                                                  
                                                }else{
                                                    self.CriarAlertaSemErro(tituloAlerta: "Ops", mensagemAlerta: "Você precisa escrever o motivo!", acaoAlerta: "OK")
                                                }
                                                
                                                
                                            })
                                            let voltar = UIAlertAction(title: "Voltar", style: .default, handler: { (action : UIAlertAction!) -> Void in })
                                            
                                            
                                            alertController.addAction(voltar)
                                            alertController.addAction(cancelarCap)
                                            
                                            self.present(alertController, animated: true, completion: nil)
                                           
        })
        
        let cancelar = CFAlertAction(title: "Não tenho certeza...",
                                     style: .Destructive,
                                     alignment: .center,
                                     backgroundColor: UIColor(red: CGFloat(41.0 / 255.0), green: CGFloat(79.0 / 255.0), blue: CGFloat(118.0 / 255.0), alpha: CGFloat(1)),
                                     textColor: nil,
                                     handler: { (action) in
                                        
                                        
        })
        
        // Add Action Button Into Alert
        alertController.addAction(defaultAction)
        alertController.addAction(cancelar)
        
        // Present Alert View Controller
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func finalizarClick(_ sender: Any) {
        let alertController = CFAlertViewController(title: "Atenção",
                                                    message: "Ao prosseguir você estará concordando que TODAS as informações estão corretas",
                                                    textAlignment: .center,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        
        // Create Upgrade Action
        let defaultAction = CFAlertAction(title: "Prosseguir",
                                          style: .Default,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(41.0 / 255.0), green: CGFloat(79.0 / 255.0), blue: CGFloat(118.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            
                                          self.EnviaCaptacao(cap: self.captaçãoEscolhida)
        })
        
        let cancelar = CFAlertAction(title: "Não tenho certeza...",
                                          style: .Destructive,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(41.0 / 255.0), green: CGFloat(79.0 / 255.0), blue: CGFloat(118.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            
                                       
        })
        
        // Add Action Button Into Alert
        alertController.addAction(defaultAction)
        alertController.addAction(cancelar)
        
        // Present Alert View Controller
        present(alertController, animated: true, completion: nil)
        
        
    }

    
    func EnviaCaptacao(cap: Captacao){
        
        KRProgressHUD.show()
        
        let parameters = ["id_voluntario": "\(self.id_user!)", "nome": cap.nome, "placa": cap.placa, "telefone": cap.telefone,
                          "origem": cap.origem, "veiculo": cap.modelo_veiculo, "dt_criacao": Date().millisecondsSince1970, "horas": "", "id_status": "20", "id_user_up": "14"] as [String : Any]
        
        let url = "https://www.sevenprotecaoveicular.com.br/Api/CaptacaoCap"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.mudaSituacao(status: "2", motivo: "", captacao_enviada: "1")
                
                
                print("Sucesso")
                KRProgressHUD.dismiss()
                
                
            case .failure(let error):
                KRProgressHUD.dismiss()
            
                
                print(error)
                if error._code == NSURLErrorTimedOut {
                    
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Conecte-se a internet!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }else {
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao enviar captação!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }
                
            }
            
        }
    }

    func criaVisita(){
            
            if origemLbl.text != "" && nomeLbl.text != "" && telLbl.text != "" && modeloLbl.text != "" && placaLbl.text != ""{
                KRProgressHUD.show()
                let date = NSDate()
                // *** create calendar object ***
                var calendar = NSCalendar.current
                // *** Get components using current Local & Timezone ***
                let unitFlags = Set<Calendar.Component>([.hour, .year, .minute])
                calendar.timeZone = TimeZone(identifier: "UTC")!
                _ = calendar.dateComponents(unitFlags, from: date as Date)
                let day = calendar.component(.day, from: date as Date)
                let month = calendar.component(.month, from: date as Date)
                let year = calendar.component(.year, from: date as Date)
                let hour = calendar.component(.hour, from: date as Date)
                let minutes = calendar.component(.minute, from: date as Date)
                let seconds = calendar.component(.second, from: date as Date)
                let data = String("\(day)/\(month)/\(year) - \(hour - 3):\(minutes):\(seconds)")
                
                
                var uuid = NSUUID().uuidString
                
                let usersReference = db.collection("ConsultorSeven").document("Visitas").collection("\(self.id_user!)").document("\(self.captaçãoEscolhida.id!)")
                
                let values = ["ano_modelo": ano_modeloLbl.text!, "bairro": "", "captacao_enviada": "0", "cep": "", "cidade": "", "complemento": "", "data": Date().millisecondsSince1970, "created_at": data, "dt_visita": "", "hr_visita": "", "id": "\(uuid)", "idconsultor": "\(self.id_user!)", "local_origem": "0", "logradouro": "", "modelo_veiculo": modeloLbl.text!, "nome": nomeLbl.text!, "num_residencia": "", "origem": origemLbl.text!, "placa": placaLbl.text!, "situacao": "0", "telefone": telLbl.text!, "tpveiculo": "", "uf": ""]  as [String : Any]
                
                usersReference.setData(values) { (error) in
                    if error != nil{
                        print("erro ao cadastrar no firebase", error)
                        self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                        return
                    }else{
                        print("captacao cadastrada no firebase com sucesso")
                        _ = self.navigationController?.popViewController(animated: true)
                        KRProgressHUD.showSuccess()
                    }
                }
            }else{
                CriarAlertaSemErro(tituloAlerta: "Opa!", mensagemAlerta: "Você precisa informar todos os campos!", acaoAlerta: "OK")
            }
    }
    
    func MakeButtonsNav(){
        let button: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        button.setImage(UIImage(named: "salvar"), for: UIControlState.normal)
        button.addTarget(self, action: "save", for: UIControlEvents.touchUpInside)
        button.frame = self.CGRectMake(0, 0, 53, 31)
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc func save(){
        let usersReference = db.collection("ConsultorSeven").document("Captacoes").collection("\(self.id_user!)").document("\(self.captaçãoEscolhida.id!)")
        
        let values = ["ano_modelo": ano_modeloLbl.text!, "data": Date().millisecondsSince1970,"modelo_veiculo": modeloLbl.text!, "nome": nomeLbl.text!, "origem": origemLbl.text!, "placa": placaLbl.text!, "telefone": telLbl.text!]  as [String : Any]
        
        usersReference.updateData(values) { (error) in
            if error != nil{
                print("erro ao atualizar => ", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                return
            }else{
                print("captacao atualizada no firebase com sucesso")

                KRProgressHUD.showMessage("Atualizado")
            }
        }
    }
    
    func mudaSituacao(status:String, motivo: String,captacao_enviada: String ){
        
        KRProgressHUD.show()
        let usersReference = db.collection("ConsultorSeven").document("Captacoes").collection("\(self.id_user!)").document("\(captaçãoEscolhida.id!)")
            
        let values = ["situacao": status, "motivocancelamento": motivo, "captacao_enviada":captacao_enviada ]  as [String : Any]
            
            usersReference.updateData(values) { (error) in
                if error != nil{
                    print("erro ao cadastrar no firebase", error)
                    self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                    KRProgressHUD.dismiss()
                    return
                }else{
                    if status == "2"{
                        self.criaVisita()
                    }
                    
                    KRProgressHUD.dismiss()
                }
            }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string )
        
        
        if self.telLbl == textField {
            telLbl.text = lastText.format("(NN)NNNN-NNNN", oldString: text)
            
            return false
        }
        return true
    }
    
}
