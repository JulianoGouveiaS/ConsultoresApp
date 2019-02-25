//
//  CriarCaptacaoViewController.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 08/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore

class CriarCaptacaoViewController: UIViewController, UITextFieldDelegate {
    
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
    
   
    let db = Firestore.firestore()
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        MakeButtonsNav()
        placaLbl.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func mandaProDatabase(){
       
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
            
            let usersReference = db.collection("ConsultorSeven").document("Captacoes").collection("\(self.id_user!)").document("\(uuid)")
            
            let values = ["ano_modelo": ano_modeloLbl.text!, "bairro": "", "captacao_enviada": "0", "cep": "", "cidade": "", "complemento": "", "data": Date().millisecondsSince1970,"created_at": data, "dt_visita": "", "hr_visita": "", "id": "\(uuid)", "idconsultor": "\(self.id_user!)", "local_origem": "0", "logradouro": "", "modelo_veiculo": modeloLbl.text!, "nome": nomeLbl.text!, "num_residencia": "", "origem": origemLbl.text!, "placa": placaLbl.text!, "situacao": "0", "telefone": telLbl.text!, "tpveiculo": "", "uf": "", "mes": "\(getMesByInt(mes: month))/\(year)"]  as [String : Any]
            
            usersReference.setData(values) { (error) in
                if error != nil{
                    print("erro ao cadastrar no firebase", error)
                    self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                    KRProgressHUD.dismiss()
                    return
                }else{
                    print("captacao cadastrada no firebase com sucesso")
                    _ = self.navigationController?.popViewController(animated: true)
                    KRProgressHUD.showSuccess()
                }
            }
        }else{
            CriarAlertaSemErro(tituloAlerta: "Opa!", mensagemAlerta: "Você precisa informar todos os campos!", acaoAlerta: "OK")
            KRProgressHUD.dismiss()
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
        mandaProDatabase()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string )
        
        
        if self.telLbl == textField {
            telLbl.text = lastText.format("(NN)NNNNNNNNN", oldString: text)
            
            return false
        } else if self.placaLbl == textField {
            placaLbl.text = lastText.format("XXXXXXX", oldString: text)
            
            return false
        }
        return true
    }
}
