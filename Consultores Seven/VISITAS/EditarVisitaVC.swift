//
//  EditarVisitaVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 09/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import CFAlertViewController
import KRProgressHUD
import FirebaseFirestore

class EditarVisitaVC: UIViewController, UITextFieldDelegate {

    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    let db = Firestore.firestore()
    
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
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    @IBOutlet weak var StackViewPlacaNormal: UIStackView!
    @IBOutlet weak var StackViewPlacaMERCOSUL: UIStackView!
    @IBOutlet weak var SwitchPlacaMercosul: UISwitch!
    
    let kCep: String!         = "cep";
    let kUF: String!          = "uf"
    let kLocalidade: String!  = "localidade"
    let kBairro: String!      = "bairro"
    let kLogradouro: String!  = "logradouro"
    let kComplemento: String! = "complemento"
    let kUnidade: String!     = "unidade"
    let kIbge: String!        = "ibge"
    let kGia: String!         = "gia"
    
    var isZeroKm = false
    var tpveiculo = "1"
    var visitaEscolhida: Visita!
    
    @IBOutlet weak var cancelarBttn: UIButton!
    @IBOutlet weak var finalizarBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placaTxt.delegate = self
        cepTxt.delegate = self
        dt_visitaTxt.delegate = self
        hr_visitaTxt.delegate = self
        MakeButtonsNav()
        cancelarBttn.layer.cornerRadius = 7
        cancelarBttn.clipsToBounds = true
        
        finalizarBttn.layer.cornerRadius = 7
        finalizarBttn.clipsToBounds = true
        
        preencheCampos(v: self.visitaEscolhida)
        // Do any additional setup after loading the view.
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
    
    func preencheCampos(v: Visita){
        self.nomeTxt.text = v.nome
        if v.tpveiculo == "1"{
            self.tpVeicSegmented.selectedSegmentIndex = 0
            self.tpveiculo = "1"
        }else if v.tpveiculo == "2"{
            self.tpVeicSegmented.selectedSegmentIndex = 1
            self.tpveiculo = "2"
        }
        
        if v.is0KM == false{
            self.isZeroKmSegmented.selectedSegmentIndex = 0
            isZeroKm = false
            self.placaTxt.isEnabled = true
            self.placaTxt.textColor = UIColor.black
            self.placaTxt.text = ""
        }else if v.is0KM == true{
            self.isZeroKmSegmented.selectedSegmentIndex = 1
            isZeroKm = true
            self.placaTxt.isEnabled = false
            self.placaTxt.textColor = UIColor.gray
            self.placaTxt.text = randomString(length: 7)
        }
        if !v.placa_isMERCOSUL{
            self.SwitchPlacaMercosul.setOn(false, animated: false)
            self.placaTxt.text = v.placa
            self.StackViewPlacaNormal.isHidden = false
            self.StackViewPlacaMERCOSUL.isHidden = true
        }else if v.placa_isMERCOSUL{
            self.SwitchPlacaMercosul.setOn(true, animated: false)
            self.placaMERCOSULTxt.text = v.placa
            self.StackViewPlacaNormal.isHidden = true
            self.StackViewPlacaMERCOSUL.isHidden = false
        }
        
        self.dt_visitaTxt.text = v.dt_visita
        self.hr_visitaTxt.text = v.hr_visita
        self.cepTxt.text = v.cep
        self.ufTxt.text = v.uf
        self.cidadeTxt.text = v.cidade
        self.bairroTxt.text = v.bairro
        self.logradouroTxt.text = v.logradouro
        self.numeroTxt.text = v.num_residencia
        self.complementoTxt.text = v.complemento
        
       
        
    }
    @IBAction func MudouTipoPlaca(_ sender: Any) {
        if self.SwitchPlacaMercosul.isOn{
            self.StackViewPlacaNormal.isHidden = true
            self.StackViewPlacaMERCOSUL.isHidden = false
        }else if !self.SwitchPlacaMercosul.isOn{
            self.StackViewPlacaNormal.isHidden = false
            self.StackViewPlacaMERCOSUL.isHidden = true
        }
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
        case 1:
            isZeroKm = true
            self.placaTxt.isEnabled = false
            self.placaTxt.textColor = UIColor.gray
            self.placaTxt.text = randomString(length: 7)
        default:
            break
        }
    }
    
    @IBAction func CEPChange(_ sender: Any) {
       
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
        }else if self.dt_visitaTxt == textField {
            dt_visitaTxt.text = lastText.format("NN/NN/NNNN", oldString: text)
            
            return false
        } else if self.hr_visitaTxt == textField {
            hr_visitaTxt.text = lastText.format("NN:NN", oldString: text)
            
            return false
        }
        return true
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
        let usersReference = db.collection("ConsultorSeven").document("Visitas").collection("\(self.id_user!)").document("\(self.visitaEscolhida.id!)")
        var placa = self.placaTxt.text!
        
        if self.SwitchPlacaMercosul.isOn{
            placa = self.placaMERCOSULTxt.text!
        }
        let values = [
            "bairro": "\(self.bairroTxt.text!)",
            "cep": "\(self.cepTxt.text!)",
            "cidade": "\(self.cidadeTxt.text!)",
            "complemento": "\(self.complementoTxt.text!)",
            "data": Date().millisecondsSince1970,
            "dt_visita": self.dt_visitaTxt.text!,
            "hr_visita": self.hr_visitaTxt.text!,
            "logradouro": self.logradouroTxt.text!,
            "nome": self.nomeTxt.text!,
            "num_residencia": self.numeroTxt.text!,
            "placa": placa,
            "uf": self.ufTxt.text!,
            "zerokm": self.isZeroKm,
            "tpveiculo": self.tpveiculo]
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
    
    
    @IBAction func cancelarClick(_ sender: Any) {
        
        let alertController = CFAlertViewController(title: "Atenção",
                                                    message: "Deseja realmente cancelar essa visita?",
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
                                            let alertController = UIAlertController(title: "Cancelamento", message: "Por qual motivo você está cancelando esta visita?", preferredStyle: .alert)
                                            
                                            alertController.addTextField { (textField : UITextField!) -> Void in
                                                textField.placeholder = "Motivo"
                                            }
                                            let cancelarCap = UIAlertAction(title: "Pronto", style: .default, handler: { alert -> Void in
                                                let firstTextField = alertController.textFields![0] as UITextField
                                                if firstTextField.text! != ""{
                                              
                                                    self.mudaSituacao(status: "1", motivo: firstTextField.text!)
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
                                            
                                            self.criaProposta()
                                            //mudar nivel da visita pra 2
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

    func mudaSituacao(status:String, motivo: String){
        
        KRProgressHUD.show()
        let usersReference = db.collection("ConsultorSeven").document("Visitas").collection("\(self.id_user!)").document("\(visitaEscolhida.id!)")
        
        let values = ["situacao": status, "motivocancelamento": motivo]  as [String : Any]
        
        usersReference.updateData(values) { (error) in
            if error != nil{
                print("erro ao cadastrar no firebase", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                KRProgressHUD.dismiss()
                return
            }else{
                if status == "2"{
                    //criar proposta
                   // self.criaProposta()
                }
                
                KRProgressHUD.dismiss()
            }
        }
    }
    
    func criaProposta(){
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
        
        var placa = self.placaTxt.text!
        
        if self.SwitchPlacaMercosul.isOn{
            placa = self.placaMERCOSULTxt.text!
        }
        
        let usersReference = self.db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.visitaEscolhida.id!)")
        let values = [
            "avarias": false,
            "bairro": self.bairroTxt.text!,
            "carres15": false,
            "carres30": false,
            "cartaopremio": false,
            "cep": self.cepTxt.text!,
            "cidade": self.cidadeTxt.text!,
            "combustivel": "0",
            "complemento": self.complementoTxt.text!,
            "coparticipacaored": false,
            "cor": "0",
            "cpfcnpj": "",
            "created_at": data!,
            "danosterceiros": false,
            "data": Date().millisecondsSince1970,
            "id": self.visitaEscolhida.id!,
            "idconsultor": "\(self.id_user!)",
            "km1000": false,
            "km500": false,
            "km700": false,
            "local_origem": "0",
            "logradouro": self.logradouroTxt.text!,
            "nome": self.nomeTxt.text!,
            "num_residencia": self.numeroTxt.text!,
            "pctpremio15": false,
            "pctpremio30": false,
            "pessoa": "",
            "placa": placa,
            "protvidro": false,
            "rastreadorparceirosv": false,
            "seguro": "",
            "sexo": "0",
            "situacao": "1",
            "status_permissao": "0",
            "uber": false,
            "uf": self.ufTxt.text!,
            "zerokm": true,
            "mes": "\(getMesByInt(mes: month))/\(year)"
            ] as [String : Any]
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro ao cadastrar no firebase2")
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(String(describing: error))")
                KRProgressHUD.dismiss()
            }else{
                print("cadastrado no firebase com sucesso")
                self.criaCamposImagens()
            }
        }
    }
    
    func criaCamposImagens(){
        //Fotos
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
        let data = "\(year)/\(month)/\(day) - \(hour - 3):\(minutes):\(seconds)"
        
        let usersReference = self.db.collection("ConsultorSeven").document("FotosPropostas").collection("\(self.id_user!)").document("\(self.visitaEscolhida.id!)")
        let values = [
            "data": Date().millisecondsSince1970,
            "created_at": data,
            "video_vistoria": "",
            "video_preview": "",
            "vistoria_str": "",
            "proposta_st": "",
            "doc1_st": "",
            "doc2_st": "",
            "doc3_st": "",
            "doc4_st": "",
            "dut_st": "",
            "rasteador_st": "",
            "fronta1_st": "",
            "fronta2_st": "",
            "lat1_st": "",
            "lat2_st": "",
            "lat3_st": "",
            "lat4_st": "",
            "traseira_st": "",
            "p_malas_st": "",
            "teto_st": "",
            "motor_st": "",
            "chassi_st": "",
            "veloc_st": "",
            "esto1_st": "",
            "esto2_st": "",
            "esto3_st": "",
            "esto4_st": "",
            "lanterna1_st": "",
            "lanterna2_st": "",
            "farol1_st": "",
            "farol2_st": "",
            "pneu1_st": "",
            "pneu2_st": "",
            "pneu3_st": "",
            "pneu4_st": "",
            "pneu5_st": "",
            "pneu6_st": "",
            "vidro1_st": "",
            "vidro2_st": "",
            "vidro3_st": "",
            "vidro4_st": "",
            "vidro5_st": "",
            "vidro6_st": "",
            "vidro7_st": "",
            "vidro8_st": "",
            "vidro9_st": "",
            "vidro10_st": "",
            "vidro11_st": "",
            "vidro12_st": "",
            "avaria1_st": "",
            "avaria2_st": "",
            "avaria3_st": "",
            "avaria4_st": "",
            "avaria5_st": "",
            "avaria6_st": "",
            "avaria7_st": "",
            "avaria8_st": "",
            "avaria9_st": "",
            "avaria10_st":  ""
            ] as [String : Any]
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro ao iniciar campos de fotos no firebase")
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(String(describing: error))")
                KRProgressHUD.dismiss()
            }else{
                print("sucesso ao iniciar campos de fotos no firebase")
                self.mudaSituacao(status: "2", motivo: "")
                KRProgressHUD.dismiss()
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
