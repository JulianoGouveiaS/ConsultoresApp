//
//  CriarVisitaVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 09/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Gallery
import CFAlertViewController
import SDWebImage
import Agrume

class CriarVisitaVC: UIViewController, UITextFieldDelegate{

    let kCep: String!         = "cep";
    let kUF: String!          = "uf"
    let kLocalidade: String!  = "localidade"
    let kBairro: String!      = "bairro"
    let kLogradouro: String!  = "logradouro"
    let kComplemento: String! = "complemento"
    let kUnidade: String!     = "unidade"
    let kIbge: String!        = "ibge"
    let kGia: String!         = "gia"
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    


    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var placaTxt: UITextField!
    @IBOutlet weak var placaMERCOSULTxt: UITextField!
    @IBOutlet weak var dt_visitaTxt: UITextField!
    @IBOutlet weak var hr_visitaTxt: UITextField!
    @IBOutlet weak var cepTxt: UITextField!
    @IBOutlet weak var ufTxt: UITextField!
    @IBOutlet weak var cidadeTxt: UITextField!
    @IBOutlet weak var bairroTxt: UITextField!
    @IBOutlet weak var logradouroTxt: UITextField!
    @IBOutlet weak var numeroTxt: UITextField!
    @IBOutlet weak var complementoTxt: UITextField!
    @IBOutlet weak var tpVeicSegmented: UISegmentedControl!
    
   
    @IBOutlet weak var isZeroKmSegmented: UISegmentedControl!
    
    
    @IBOutlet weak var StackViewPlacaNormal: UIStackView!
    @IBOutlet weak var StackViewPlacaMERCOSUL: UIStackView!
    @IBOutlet weak var SwitchPlacaMercosul: UISwitch!
    
    var uuid = NSUUID().uuidString
    
    let db = Firestore.firestore()
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var isZeroKm = false
    var tpveiculo = "1"
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placaTxt.delegate = self
        cepTxt.delegate = self
        dt_visitaTxt.delegate = self
        hr_visitaTxt.delegate = self
        MakeButtonsNav()
        showDatePicker()
        showTimePicker()
       
        // Do any additional setup after loading the view.
    }
    
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "pt_br")
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "donedatePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelDatePicker")
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        dt_visitaTxt.inputAccessoryView = toolbar
        // add datepicker to textField
        dt_visitaTxt.inputView = datePicker
        
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dt_visitaTxt.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func showTimePicker(){
        //Formate Date
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "pt_br")
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "doneTimePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelTimePicker")
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        hr_visitaTxt.inputAccessoryView = toolbar
        // add datepicker to textField
        hr_visitaTxt.inputView = timePicker
        
    }
    
    func doneTimePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        hr_visitaTxt.text = formatter.string(from: timePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelTimePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }

    func MakeButtonsNav(){
        let button: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        button.setImage(UIImage(named: "salvar"), for: UIControlState.normal)
        button.addTarget(self, action: "save", for: UIControlEvents.touchUpInside)
        button.frame = self.CGRectMake(0, 0, 53, 31)
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    @IBAction func MudouTipoPlaca(_ sender: Any) {
        if self.SwitchPlacaMercosul.isOn{
            self.StackViewPlacaNormal.isHidden = true
            self.StackViewPlacaMERCOSUL.isHidden = false
            self.placaMERCOSULTxt.becomeFirstResponder()
        }else if !self.SwitchPlacaMercosul.isOn{
            self.StackViewPlacaNormal.isHidden = false
            self.StackViewPlacaMERCOSUL.isHidden = true
            self.placaTxt.becomeFirstResponder()
        }
    }
    
    @objc func save(){
        DispatchQueue.main.async {
            self.mandaProDatabase()
        }
    }
    
    func mandaProDatabase(){
        
        if checkCampos(){
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
            let data = String("\(year)/\(month)/\(day) - \(hour - 3):\(minutes):\(seconds)")
            
        
            let usersReference = db.collection("ConsultorSeven").document("Visitas").collection("\(self.id_user!)").document("\(uuid)")
            var placa = self.placaTxt.text!
            var isMERCOSUL = false
            if self.SwitchPlacaMercosul.isOn{
                placa = self.placaMERCOSULTxt.text!
                isMERCOSUL = true
            }
            
            let values = ["ano_modelo": "",
                          "bairro": "\(self.bairroTxt.text!)",
                        "captacao_enviada": "0",
                        "cep": "\(self.cepTxt.text!)",
                        "cidade": "\(self.cidadeTxt.text!)",
                        "complemento": "\(self.complementoTxt.text!)",
                        "data": Date().millisecondsSince1970,
                        "created_at": data,
                        "dt_visita": self.dt_visitaTxt.text!,
                        "hr_visita": self.hr_visitaTxt.text!,
                        "id": "\(uuid)",
                        "idconsultor": "\(self.id_user!)",
                        "local_origem": "0",
                        "logradouro": self.logradouroTxt.text!,
                        "modelo_veiculo": "",
                        "nome": self.nomeTxt.text!,
                        "num_residencia": self.numeroTxt.text!,
                        "origem": "",
                        "placa": placa,
                        "situacao": "0",
                        "telefone": "",
                        "uf": self.ufTxt.text!,
                        "zerokm": self.isZeroKm,
                        "placa_isMERCOSUL": isMERCOSUL,
                        "tpveiculo": self.tpveiculo]
                        as [String : Any]
            
            usersReference.getDocument { (document, erro) in
                if let document = document {
                    if !document.exists{
                        usersReference.setData(values) { (error) in
                            if error != nil{
                                print("erro ao acessar servidor", error)
                                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                                KRProgressHUD.dismiss()
                                return
                            }else{
                                print("visita enviado com sucesso")
                                _ = self.navigationController?.popViewController(animated: true)
                                KRProgressHUD.showSuccess()
                            }
                        }
                        KRProgressHUD.dismiss()
                    }else{
                        usersReference.updateData(values) { (error) in
                            if error != nil{
                                print("erro ao acessar servidor", error)
                                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                                KRProgressHUD.dismiss()
                                return
                            }else{
                                print("Comprovante enviado com sucesso")
                                KRProgressHUD.showSuccess()
                            }
                        }
                        KRProgressHUD.dismiss()
                    }
                }
            }
            
        }
        
    }

    func checkCampos() -> Bool{
        
        if self.SwitchPlacaMercosul.isOn{
            if self.placaMERCOSULTxt.text == ""{
                self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha a placa!", acaoAlerta: "OK")
                return false
            }
        }else{
            if self.placaTxt.text == ""{
                self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha a placa!", acaoAlerta: "OK")
                return false
            }
        }
        
        if self.nomeTxt.text == ""{
            self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha seu nome!", acaoAlerta: "OK")
            return false
        }else if self.dt_visitaTxt.text == ""{
            self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha a data!", acaoAlerta: "OK")
            return false
        }else if self.hr_visitaTxt.text == ""{
            self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha a hora!", acaoAlerta: "OK")
            return false
        }else if self.cepTxt.text == ""{
            self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha seu cep!", acaoAlerta: "OK")
            return false
        }else if self.ufTxt.text == ""{
            self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha sua UF!", acaoAlerta: "OK")
            return false
        }else if self.cidadeTxt.text == ""{
            self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha sua cidade!", acaoAlerta: "OK")
            return false
        }else if self.numeroTxt.text == ""{
            self.CriarAlertaSemErro(tituloAlerta: "Ops!", mensagemAlerta: "Preencha seu número!", acaoAlerta: "OK")
            return false
        }else{
            return true
        }
}

        
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string )
        
        
        if self.placaTxt == textField {
            placaTxt.text = lastText.format("CCCNNNN", oldString: text)
            return false
        }else if self.placaMERCOSULTxt == textField {
            placaMERCOSULTxt.text = lastText.format("CCCNCNN", oldString: text)
            return false
        }else if self.cepTxt == textField {
            cepTxt.text = lastText.format("NNNNNNNN", oldString: text)
            return false
        }
        return true
    }
    
    @IBAction func TpVeicindexChanged(_ sender: AnyObject) {
        switch self.tpVeicSegmented.selectedSegmentIndex
        {
        case 0:
            tpveiculo = "1"
        case 1:
            tpveiculo = "2"
        default:
            break
        }
    }
    
    @IBAction func zeroKmIndexChanged(_ sender: AnyObject) {
        switch self.isZeroKmSegmented.selectedSegmentIndex
        {
        case 0:
            isZeroKm = false
            self.placaTxt.isEnabled = true
            self.placaTxt.textColor = UIColor.black
            self.placaTxt.text = ""
            self.placaMERCOSULTxt.isEnabled = true
            self.placaMERCOSULTxt.textColor = UIColor.black
            self.placaMERCOSULTxt.text = ""
        case 1:
            isZeroKm = true
            self.placaTxt.isEnabled = false
            self.placaTxt.textColor = UIColor.gray
            self.placaTxt.text = randomString(length: 7)
            self.placaMERCOSULTxt.isEnabled = false
            self.placaMERCOSULTxt.textColor = UIColor.gray
            self.placaMERCOSULTxt.text = randomString(length: 7)
        default:
            break
        }
    }
    
    @IBAction func CEPChange(_ sender: Any) {
        print(self.cepTxt.text)
        let session = URLSession.shared
        
        let urlPath = URL(string: "https://viacep.com.br/ws/"+self.cepTxt.text!+"/json")
        var request = URLRequest(url: urlPath!)
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            } else {
                do {
                    _ = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
                    let _: NSError?
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers)
                    
                    DispatchQueue.main.async(execute: {
                        let dic: NSDictionary = (jsonResult as! NSDictionary);
                        
                        if dic.count > 1 {
                            self.preencheDados(jsonResult as! NSDictionary)
                        } else {
                            self.preencheDados(nil)
                        }
                    })
                } catch {
                    DispatchQueue.main.async(execute: {
                        self.preencheDados(nil)
                    })
                }
            }
            
        }).resume()
        
    }
    
    func preencheDados(_ dados:NSDictionary!) {
        
        let x: CGFloat = 20
        var y: CGFloat = 95
        let h: CGFloat = 23
        let w: CGFloat = 1000
        
        var label: UILabel!;
        if let theLabel = self.view.viewWithTag(1000) as? UILabel {
            label = theLabel
            label.removeFromSuperview()
        } else {
            label = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        }
        label.tag = 1000;
        if dados == nil {
            label.text = "";
        } else {
            self.cepTxt.text = (dados.value(forKey: self.kCep) as! String);
        }
        self.view.addSubview(label)
        y += h;
        
        if let theLabel = self.view.viewWithTag(1001) as? UILabel {
            label = theLabel
            label.removeFromSuperview()
        } else {
            label = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        }
        label.tag = 1001;
        if dados == nil {
            label.text = "";
        } else {
            self.cidadeTxt.text = (dados.value(forKey: self.kLocalidade) as! String)
            self.ufTxt.text = (dados.value(forKey: self.kUF) as! String);
        }
        
        if let theLabel = self.view.viewWithTag(1002) as? UILabel {
            label = theLabel
            label.removeFromSuperview()
        } else {
            label = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        }
        label.tag = 1002;
        if dados == nil {
            label.text = "";
        } else {
            self.bairroTxt.text = (dados.value(forKey: self.kBairro) as! String);
        }
        
        if dados == nil {
            label.text = "";
        } else {
            self.logradouroTxt.text = (dados.value(forKey: self.kLogradouro) as! String);
        }
        
        if dados == nil {
            label.text = "";
        } else {
            self.complementoTxt.text = (dados.value(forKey: self.kComplemento) as! String)
        }
    }
}
