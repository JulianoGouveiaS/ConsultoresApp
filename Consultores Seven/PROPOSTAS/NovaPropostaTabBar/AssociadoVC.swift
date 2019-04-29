//
//  AssociadoVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Gallery
import CFAlertViewController
import SDWebImage
import Agrume


class AssociadoVC: UIViewController, UITextFieldDelegate, GalleryControllerDelegate{
    
     var propostaEscolhida: Proposta!
        let db = Firestore.firestore()
    
    @IBOutlet weak var checkBox: M13Checkbox!
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    var comprovante = false
    
    let kCep: String!         = "cep";
    let kUF: String!          = "uf"
    let kLocalidade: String!  = "localidade"
    let kBairro: String!      = "bairro"
    let kLogradouro: String!  = "logradouro"
    let kComplemento: String! = "complemento"
    let kUnidade: String!     = "unidade"
    let kIbge: String!        = "ibge"
    let kGia: String!         = "gia"
    
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var nomeMaeTxt: UITextField!
    @IBOutlet weak var cpfTxt: UITextField!
    @IBOutlet weak var rgTxt: UITextField!
    @IBOutlet weak var dt_nascTxt: UITextField!
    @IBOutlet weak var cnhTxt: UITextField!
    @IBOutlet weak var celTxt: UITextField!
    @IBOutlet weak var telTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var cepTxt: UITextField!
    @IBOutlet weak var cidadeTxt: UITextField!
    @IBOutlet weak var ufTxt: UITextField!
    @IBOutlet weak var bairroTxt: UITextField!
    @IBOutlet weak var logradouroTxt: UITextField!
    @IBOutlet weak var numTxt: UITextField!
    @IBOutlet weak var complementoTxt: UITextField!
    
    @IBOutlet weak var tpPessoaSegmented: UISegmentedControl!
    @IBOutlet weak var sexoSegmented: UISegmentedControl!
    
    
    @IBOutlet weak var BttnAdcComprovante: UIButton!
    @IBOutlet weak var ImgViewComprovante: UIImageView!
    
    @IBOutlet weak var checkbox: M13Checkbox?
    
    var tppessoa: String!
     var sexo: String!
    var permissao = ""
    var ArrFotosUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.getPermissao(id_user: "\(self.id_user!)", propostaEscolhida: self.propostaEscolhida)
        self.dt_nascTxt.delegate = self
        self.cpfTxt.delegate = self
        self.celTxt.delegate = self
        self.telTxt.delegate = self
        self.emailTxt.delegate = self
        self.cepTxt.delegate = self
        self.dt_nascTxt.delegate = self
        preencheCampos()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImg))
        ImgViewComprovante.addGestureRecognizer(tapGestureRecognizer)
        ImgViewComprovante.isUserInteractionEnabled = true
        let longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapImg))
        ImgViewComprovante.addGestureRecognizer(longTapGestureRecognizer)
        
        loadFoto()
        // Do any additional setup after loading the view.
       
    }
    
    func getPermissao(id_user:String, propostaEscolhida: Proposta){
        let db = Firestore.firestore()
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(id_user)").document("\(propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot?.data()
                
                Config.Camera.recordLocation = true
                print(dictionary?["status_permissao"] as? String ?? "")
                self.permissao = dictionary?["status_permissao"] as? String ?? ""
            }
            KRProgressHUD.dismiss()
        }
    }
    
    @IBAction func adcFoto(sender: Any){
        self.showGallery(ArrFotosUrls: self.ArrFotosUrls, totalFotos: 1, permissao: self.permissao)
    }
   
    @objc func tapImg(){
        if ImgViewComprovante.image != nil{
            let agrume = Agrume(image: ImgViewComprovante.image!)
            agrume.show(from: self)
        }
    }
    
    @objc func longTapImg(){
        if ImgViewComprovante.image != nil{
            let alertController = CFAlertViewController(title: "Atenção",
                                                        message: "Deseja realmente excluir essa foto?",
                                                        textAlignment: .center,
                                                        preferredStyle: .alert,
                                                        didDismissAlertHandler: nil)
            
            // Create Upgrade Action
            let defaultAction = CFAlertAction(title: "Excluir Foto",
                                              style: .Default,
                                              alignment: .center,
                                              backgroundColor: UIColor(red: CGFloat(41.0 / 255.0), green: CGFloat(79.0 / 255.0), blue: CGFloat(118.0 / 255.0), alpha: CGFloat(1)),
                                              textColor: nil,
                                              handler: { (action) in
                                                
                                                self.removeFotoComprovante(field: "comprovanteFoto", uuid: self.propostaEscolhida.id!, id_user: "\(self.id_user!)")
                                                self.comprovante = false
                                                
            })
            
            let voltar = CFAlertAction(title: "Cancelar",
                                       style: .Default,
                                       alignment: .center,
                                       backgroundColor: UIColor(red: CGFloat(41.0 / 255.0), green: CGFloat(79.0 / 255.0), blue: CGFloat(118.0 / 255.0), alpha: CGFloat(1)),
                                       textColor: nil,
                                       handler: { (action) in })
            
            alertController.addAction(defaultAction)
            alertController.addAction(voltar)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func loadFoto(){
        KRProgressHUD.show()
        
        db.collection("ConsultorSeven").document("FotosPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ArrFotosUrls = []
                
                let dictionary = querySnapshot?.data()
                if (dictionary?["comprovanteFoto"] as? String ?? "") == ""{
                    self.ImgViewComprovante.image = nil
                }else{
                    if !(dictionary?["comprovanteFoto"] as? String ?? "").contains(".emulated"){
                        let url = dictionary?["comprovanteFoto"] as? String ?? ""
                        self.ImgViewComprovante.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "imgLoad"))
                        self.comprovante = true
                    
                    }
                }
            }
            KRProgressHUD.dismiss()
        }
    }
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        print("didSelectVideo")
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print("requestLightbox")
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
        images[0].resolve(completion: { (imagem) in
            let data1 = UIImagePNGRepresentation(imagem!)
            
            let fotoComprimida = self.colocaLogo(imgData: data1!).compressTo(0.2)
            print("data1.count => \(data1!.count) \n fotoComprimida.count => \(String(describing: UIImagePNGRepresentation(fotoComprimida!)))" )
            
            self.enviaComprovanteStorage(nomeImg: "comprovanteFoto", imagem: fotoComprimida!, id_user: "\(self.id_user!)", idProposta: self.propostaEscolhida.id!)
            self.comprovante = true
        })
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func checkboxValueChanged(_ sender: M13Checkbox) {
            switch sender.checkState {
            case .unchecked:
                print("unchecked")
                break
            case .checked:
                print("checked")
                break
            case .mixed:
                print("mixed")
                break
            }
    }
    
    func preencheCampos(){
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                    let dictionary = querySnapshot!.data()
                
                    self.nomeTxt.text = dictionary?["nome"] as? String ?? ""
                    self.nomeMaeTxt.text = dictionary?["mae"] as? String ?? ""
                    self.cpfTxt.text = dictionary?["cpfcnpj"] as? String ?? ""
                    self.rgTxt.text = dictionary?["rg"] as? String ?? ""
                    self.cnhTxt.text = dictionary?["cnh"] as? String ?? ""
                    self.dt_nascTxt.text = dictionary?["dtnasc"] as? String ?? ""
                    self.celTxt.text = dictionary?["celular"] as? String ?? ""
                    self.telTxt.text = dictionary?["telefone"] as? String ?? ""
                    self.emailTxt.text = dictionary?["email"] as? String ?? ""
                    self.cepTxt.text = dictionary?["cep"] as? String ?? ""
                    self.cidadeTxt.text = dictionary?["cidade"] as? String ?? ""
                    self.ufTxt.text = dictionary?["uf"] as? String ?? ""
                    self.bairroTxt.text = dictionary?["bairro"] as? String ?? ""
                    self.logradouroTxt.text = dictionary?["logradouro"] as? String ?? ""
                    self.numTxt.text = dictionary?["num_residencia"] as? String ?? ""
                    self.complementoTxt.text = dictionary?["complemento"] as? String ?? ""
                    self.comprovante = dictionary?["comprovante"] as? Bool ?? false
                
                if dictionary?["pessoa"] as? String == "1"{
                    self.tpPessoaSegmented.selectedSegmentIndex = 0
                    self.tppessoa = "1"
                }else if dictionary?["pessoa"] as? String == "2"{
                    self.tpPessoaSegmented.selectedSegmentIndex = 1
                    self.tppessoa = "2"
                }
                
                if dictionary?["sexo"] as? String == "1"{
                    self.sexoSegmented.selectedSegmentIndex = 0
                    self.sexo = "1"
                }else if dictionary?["sexo"] as? String == "2"{
                    self.sexoSegmented.selectedSegmentIndex = 1
                    self.sexo = "2"
                }
            }
                
        }
        
    }
    
    func salvarCampos(){
        if self.tpPessoaSegmented.selectedSegmentIndex == 0{
            self.tppessoa = "1"
        }else if self.tpPessoaSegmented.selectedSegmentIndex == 1{
            self.tppessoa = "2"
        }
        
        if self.sexoSegmented.selectedSegmentIndex == 0{
            self.sexo = "1"
        }else if self.sexoSegmented.selectedSegmentIndex == 1{
            self.sexo = "2"
        }
        
        if !self.cpfTxt.text!.isValidCPF && !self.cpfTxt.text!.isValidCNPJ{
            self.cpfTxt.text! = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "CPF ou CNPJ inválido(s)", acaoAlerta: "Ok")
            return
        }
        
        if self.dt_nascTxt.text!.count != 10{
            self.dt_nascTxt.text! = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Data de nascimento inválida", acaoAlerta: "Ok")
            return
        }
        
        if self.celTxt.text!.count != 12 && self.celTxt.text!.count != 13{
            self.celTxt.text! = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Número celular inválido", acaoAlerta: "Ok")
            return
        }
        
        if self.telTxt.text!.count != 12 && self.telTxt.text!.count != 13{
            self.telTxt.text! = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Número de telefone inválido", acaoAlerta: "Ok")
            self.setBottomBorder(textField: self.telTxt)
            return
        }
        
        if self.emailTxt.text!.isValidEmail() == false{
            self.emailTxt.text = ""
            CriarAlertaSemErro(tituloAlerta: "Falha ao Salvar", mensagemAlerta: "Email inválido", acaoAlerta: "Ok")
            self.setBottomBorder(textField: self.emailTxt)
            return
        }
        
        let usersReference = db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)")
        
        let values = [
            "pessoa": self.tppessoa,
            "sexo": self.sexo,
            "nome": "\(self.nomeTxt.text!)",
            "mae": "\(self.nomeMaeTxt.text!)",
            "cpfcnpj": "\(self.cpfTxt.text!)",
            "rg": "\(self.rgTxt.text!)",
            "cnh": "\(self.cnhTxt.text!)",
            "dtnasc": self.dt_nascTxt.text!,
            "celular": self.celTxt.text!,
            "telefone": self.telTxt.text!,
            "email": self.emailTxt.text!,
            "cep": self.cepTxt.text!,
            "cidade": self.cidadeTxt.text!,
            "uf": self.ufTxt.text!,
            "bairro": self.bairroTxt.text!,
            "logradouro": self.logradouroTxt.text!,
            "num_residencia": self.numTxt.text!,
            "complemento": self.complementoTxt.text!,
            "comprovante": self.comprovante]
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
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string )
        
        
        if self.dt_nascTxt == textField {
            dt_nascTxt.text = lastText.format("NN/NN/NNNN", oldString: text)
            return false
        }else if self.cpfTxt == textField {
            cpfTxt.text = lastText.format("NNNNNNNNNNN", oldString: text)
            
            return false
        }else if self.celTxt == textField {
            celTxt.text = lastText.format("(NN)NNNNNNNNN", oldString: text)
            
            return false
        }else if self.telTxt == textField {
            telTxt.text = lastText.format("(NN)NNNNNNNNN", oldString: text)
            
            return false
        }
        return true
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
}
