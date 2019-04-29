//
//  Extensions.swift
//  SevenConsultor
//
//  Created by Juliano Gouveia on 19/06/2018.
//  Copyright © 2018 Raphael Higashi Silva. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD
import FirebaseFirestore
import CFAlertViewController
import Gallery
import Firebase
import FirebaseStorage

extension UIViewController {
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    func logoutApp(){
        // Create Alet View Controller
        let alertController = CFAlertViewController(title: "LOGOUT",
                                                    message: "Tem certeza que deseja sair do aplicativo?",
                                                    textAlignment: .center,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        
        // Create Upgrade Action
        let Sair = CFAlertAction(title: "Sair",
                                 style: .Default,
                                 alignment: .center,
                                 backgroundColor: UIColor.red,
                                 textColor: UIColor.black,
                                 handler: { (action) in
                                    
                                    KeychainWrapper.standard.removeAllKeys()
                                    
                                    let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                                    
                                    self.navigationController!.pushViewController(vc!, animated: true)
        })
        
        // Create Upgrade Action
        let Cancelar = CFAlertAction(title: "Cancelar",
                                     style: .Destructive,
                                     alignment: .center,
                                     backgroundColor: UIColor.purple,
                                     textColor: UIColor.black,
                                     handler: { (action) in
                                        
        })
        // Add Action Button Into Alert
        alertController.addAction(Sair)
        alertController.addAction(Cancelar)
        
        // Present Alert View Controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    func randomNumber(length: Int) -> String {
        
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func getNomeFotoPelaUrl(urlFirebase: String) -> String{
        
        let url = urlFirebase
        if url != "" || !url.contains("storage/emulated") || !url.contains("o/"){
            let arr1 = url.components(separatedBy: "o/")
            if arr1.count > 1{
                if arr1[1].contains("?"){
                    let arr2 = arr1[1].components(separatedBy: "?")
                    print("arr2 =>", arr2)
                    return arr2[0]
                }else{
                    return ""
                }
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
    
    func getMesByInt(mes: Int) -> String{
        switch mes {
        case 1:
            return "Janeiro"
        case 2:
            return "Fevereiro"
        case 3:
            return "Março"
        case 4:
            return "Abril"
        case 5:
            return "Maio"
        case 6:
            return "Junho"
        case 7:
            return "Julho"
        case 8:
            return "Agosto"
        case 9:
            return "Setembro"
        case 10:
            return "Outubro"
        case 11:
            return "Novembro"
        case 12:
            return "Dezembro"
        default:
            return ""
        }
    }

    
    func CriarAlerta (tituloAlerta: String, mensagemAlerta: String, acaoAlerta: String, erroRecebido: String) {
        //Cria um alerta no estilo Alert com titulo e mensagem
        let alertaController = UIAlertController(title: tituloAlerta, message: mensagemAlerta, preferredStyle: .alert)
        
        //Adiciona o Botao Acao Confirmar no Alerta
        let acaoCfonfirmar = UIAlertAction(title: acaoAlerta, style: .default, handler: nil)
     
        let mostraErroDetalhe = UIAlertAction(title: "Detalhes do Erro", style: UIAlertActionStyle.destructive, handler: { action in
            if erroRecebido != ""{
                let alert = UIAlertController(title: "Detalhes do Erro", message: "\(erroRecebido)", preferredStyle: .alert)
                let acaoConfirmar = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                alert.addAction(acaoConfirmar)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        //adiciona acoes
        alertaController.addAction(acaoCfonfirmar)
     // alertaController.addAction(mostraErroDetalhe)
        
        //Apresenta o alerta de forma animada
        present(alertaController, animated: true, completion: nil)
        //Cria o botao de açao Confirmar
        
        return
    } //FUNC CRIAR ALERTA
    
    func CriarAlertaSemErro (tituloAlerta: String, mensagemAlerta: String, acaoAlerta: String) {
        //Cria um alerta no estilo Alert com titulo e mensagem
        let alertaController = UIAlertController(title: tituloAlerta, message: mensagemAlerta, preferredStyle: .alert)
        
        //Adiciona o Botao Acao Confirmar no Alerta
        let acaoCfonfirmar = UIAlertAction(title: acaoAlerta, style: .default, handler: nil)
        
        //adiciona acoes
        alertaController.addAction(acaoCfonfirmar)
        
        //Apresenta o alerta de forma animada
        present(alertaController, animated: true, completion: nil)
        //Cria o botao de açao Confirmar
        
        return
    } //FUNC CRIAR ALERTA
    
    func tirarScreenshot(scrollView: UIScrollView){
        UIGraphicsBeginImageContext(scrollView.contentSize)
        
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame
        
        scrollView.contentOffset = CGPoint.zero
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame
        
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "Sem Câmera", message: "Câmera indisponível", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
   
    
    func colocaLogo(imgData: Data) -> UIImage{
       
        
        if let img = UIImage(data: imgData), let img2 = UIImage(named: "logoTransparente") {
            
            let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            
            UIGraphicsBeginImageContextWithOptions(img.size, true, 0)
            let context = UIGraphicsGetCurrentContext()
            
            context!.setFillColor(UIColor.white.cgColor)
            context!.fill(rect)
            
            img.draw(in: rect, blendMode: .normal, alpha: 1)
            img2.draw(in: CGRectMake(10,10,200,150), blendMode: .normal, alpha: 1)
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return result!
        }
        return UIImage(data: imgData)!
    }
    
    func enviaFotoPerfil(nomeImg: String, imagemDados: Data, id_user: String){
        KRProgressHUD.show()
        
        let armazenamento = Storage.storage().reference()
        let timestampValue = Date().millisecondsSince1970
        armazenamento.child("\(timestampValue)").putData(imagemDados, metadata: nil, completion: { (metaDados, erro) in
            if erro == nil{
                print("foto enviada com sucesso")
                print("nome imagem: \(timestampValue)")
                armazenamento.child("\(timestampValue)").downloadURL { url, error in
                    if let error = error {
                        print(error)
                        KRProgressHUD.dismiss()
                    } else {
                        self.enviaUrlDatabasePerfil(nomeImg: nomeImg, url: url!, id_user: id_user)
                    }
                }
            }else{
                self.CriarAlerta(tituloAlerta: "Opa", mensagemAlerta: "Ocorreu um erro ao enviar a foto pro storage", acaoAlerta: "OK", erroRecebido: "\(erro)")
                KRProgressHUD.dismiss()
            }
        })
    }
    
    func enviaUrlDatabasePerfil(nomeImg: String, url: URL, id_user: String){
        let db = Firestore.firestore()
        let usersReference = db.collection("ConsultorSeven").document("Perfil").collection("\(id_user)").document("Dados")
        
        var values = ["\(nomeImg)": "\(url)"] as [String : Any]
        
        usersReference.updateData(values) { (error) in
            if error != nil{
                print("erro ao cadastrar no firebase", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar foto no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                return
            }else{
                print("url enviada com sucesso")
                KRProgressHUD.showSuccess()
            }
        }
        KRProgressHUD.dismiss()
    }
    
    func inicializaPerfil(nome: String, cpf: String, id_user: String){
        let db = Firestore.firestore()
        let usersReference = db.collection("ConsultorSeven").document("Perfil").collection("\(id_user)").document("Dados")
        
        var values = ["nome": nome, "cpf": cpf, "id": id_user,"nivel_id": "1", "avaliacao_media": "", "conquistas_totais": "", "fotoperfil": "","recado": "Seven Proteção Veicular", "vendas_totais": ""] as [String : Any]
        usersReference.getDocument { (document, erro) in
            if let document = document {
                if !document.exists{
                    usersReference.setData(values) { (error) in
                        if error != nil{
                            print("erro ao cadastrar no firebase", error)
                            self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro encontrado!", acaoAlerta: "OK", erroRecebido: "\(error)")
                            return
                        }else{
                            print("url enviada com sucesso")
                            KRProgressHUD.showSuccess()
                        }
                    }
                    KRProgressHUD.dismiss()
                }else{
                    usersReference.updateData(values) { (error) in
                        if error != nil{
                            print("erro ao cadastrar no firebase", error)
                            self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro encontrado!", acaoAlerta: "OK", erroRecebido: "\(error)")
                            return
                        }else{
                            print("url enviada com sucesso")
                            KRProgressHUD.showSuccess()
                        }
                    }
                    KRProgressHUD.dismiss()
                }
            }
        }
    }
    
    func enviaComprovanteStorage(nomeImg: String, imagem: UIImage, id_user: String, idProposta: String){
        
        
        let armazenamento = Storage.storage().reference()
        let timestampValue = Date().millisecondsSince1970
        
        let imagemDados = UIImagePNGRepresentation(imagem)
        
        armazenamento.child("\(timestampValue).jpg").putData(imagemDados!, metadata: nil, completion: { (metaDados, erro) in
            if erro == nil{
                print("foto enviada com sucesso")
                print("nome imagem: \(timestampValue).jpg")
                armazenamento.child("\(timestampValue).jpg").downloadURL { url, error in
                    if let error = error {
                        print(error)
                        KRProgressHUD.dismiss()
                    }else {
                        self.enviaUrlComprovanteDatabase(nomeImg: nomeImg, url: url!, id_user: id_user, idProposta: idProposta)
                    }
                }
            }else{
                self.CriarAlerta(tituloAlerta: "Opa", mensagemAlerta: "Ocorreu um erro ao enviar a foto pro storage", acaoAlerta: "OK", erroRecebido: "\(erro)")
                KRProgressHUD.dismiss()
            }
        })
    }
    
    func enviaUrlComprovanteDatabase(nomeImg: String, url: URL, id_user: String, idProposta: String){
        let db = Firestore.firestore()
        let usersReference = db.collection("ConsultorSeven").document("FotosPropostas").collection("\(id_user)").document("\(idProposta)")
        
        var values = ["\(nomeImg)": "\(url)"] as [String : Any]
        
        usersReference.setData(values) { (error) in
            if error != nil{
                print("erro ao cadastrar no firebase", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar foto no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                return
            }else{
                print("url enviada com sucesso")
                KRProgressHUD.dismiss()
            }
        }
    }
    
    func enviaFotoStorage(nomeImg: String, imagem: UIImage, id_user: String, proposta: Proposta){
        
        let armazenamento = Storage.storage().reference()
        let timestampValue = Date().millisecondsSince1970
        
        let imagemDados = UIImagePNGRepresentation(imagem)
        
        armazenamento.child("\(timestampValue).jpg").putData(imagemDados!, metadata: nil, completion: { (metaDados, erro) in
            if erro == nil{
                print("foto enviada com sucesso")
                print("nome imagem: \(timestampValue).jpg")
                armazenamento.child("\(timestampValue).jpg").downloadURL { url, error in
                    if let error = error {
                        print(error)
                        KRProgressHUD.dismiss()
                    }else {
                        self.enviaUrlDatabase(nomeImg: nomeImg, url: url!, id_user: id_user, proposta: proposta)
                    }
                }
            }else{
                self.CriarAlerta(tituloAlerta: "Opa", mensagemAlerta: "Ocorreu um erro ao enviar a foto pro storage", acaoAlerta: "OK", erroRecebido: "\(erro)")
                KRProgressHUD.dismiss()
            }
        })
    }
    
    func verifyIfIsTest(finished: @escaping (Bool) -> Void){
        let db = Firestore.firestore()
     
        db.collection("ConsultorSeven").document("iosVersion").getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let dictionary = querySnapshot?.data()
                
                if dictionary?["atualizandoNew"] as? Bool ?? true == false{
                    finished(false)
                }else{
                    finished(true)
                }
            }
            KRProgressHUD.dismiss()
        }
    }
    
    func showGallery(ArrFotosUrls: [String], totalFotos: Int, permissao: String){
        let gallery = GalleryController()
        gallery.delegate = self as! GalleryControllerDelegate
        
        Config.Camera.recordLocation = true
        if permissao == "3"{
            Config.tabsToShow = [.imageTab, .cameraTab]
        }else{
            Config.tabsToShow = [.cameraTab]
        }
        
        
        let filteredArray = ArrFotosUrls.filter {$0 != ""}
        let countImagens = totalFotos - filteredArray.count
        print("countImagens =>", countImagens)
        if countImagens <= 0 {
            CriarAlertaSemErro(tituloAlerta: "Opa!", mensagemAlerta: "Limite de imagens atingido.", acaoAlerta: "Ok")
            return
        }
        Config.Camera.imageLimit = countImagens
        present(gallery, animated: true, completion: nil)
    }
    
    func showGalleryVideo(ArrFotosUrls: [String]){
        let gallery = GalleryController()
        gallery.delegate = self as! GalleryControllerDelegate
        
        Config.Camera.recordLocation = true
        
        Config.tabsToShow = [.videoTab, .cameraTab]
        
        let filteredArray = ArrFotosUrls.filter {$0 != ""}
        Config.VideoEditor.maximumDuration = 30
        Config.VideoEditor.savesEditedVideoToLibrary = true
        Config.Camera.imageLimit = 1
        present(gallery, animated: true, completion: nil)
    }
    
    func removeFoto(field: String, proposta: Proposta, id_user: String){
        let db = Firestore.firestore()
        let usersReference =  db.collection("ConsultorSeven").document("FotosPropostas").collection("\(id_user)").document("\(proposta.id!)")
        
        var values = ["\(field)": ""] as [String : Any]
        
        usersReference.updateData(values) { (error) in
            if error != nil{
                print("erro ao remover foto", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar foto no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                return
            }else{
                print("foto removida com sucesso")
            }
        }
    }
    
    func removeFotoComprovante(field: String, uuid: String, id_user: String){
        let db = Firestore.firestore()
        let usersReference =  db.collection("ConsultorSeven").document("FotosPropostas").collection("\(id_user)").document("\(uuid)")
        
        var values = ["\(field)": ""] as [String : Any]
        
        usersReference.updateData(values) { (error) in
            if error != nil{
                print("erro ao remover foto", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao remover foto!", acaoAlerta: "OK", erroRecebido: "\(error)")
                return
            }else{
                print("foto removida com sucesso")
            }
        }
    }
    
    @objc func screenShot() {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
        
    }
    
    func hideBottomBorder(textField: UITextField){
        for layer in textField.layer.sublayers! {
            if layer.name == "bottomLine" {
                layer.removeFromSuperlayer()
            }
        }
    }
    func checkWiFi() -> Bool {
        let networkStatus = Reachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            return false
        case .Online(.WWAN):
            print("Connected via WWAN")
            return true
        case .Online(.WiFi):
            print("Connected via WiFi")
            return true
        }
    }
    
    func checkFunilExiste(id: Int, finished: @escaping (Bool) -> Void){
        let db = Firestore.firestore()
        let date = Date()
        let calendar = Calendar.current
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
        
        
        let testeConexao = checkWiFi()
        if testeConexao{
            let usersReference = db.collection("FunilConsultores").document("Agendamentos").collection("\(id)").document("\(anoAux)-\(mesAux)-\(diaAux)")
       
            usersReference.getDocument { (document, erro) in
                if let document = document {
                    if !document.exists{
                       //nao fez funil ainda
                        finished(false)
                    }else{
                        finished(true)
                    }
                    
                }
            }
        }
    }
    
    func registraLogin(id: Int, login: String, senha: String){
        let db = Firestore.firestore()
        let date = Date()
        let calendar = Calendar.current
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
        let hora = calendar.component(.hour, from: date)
        let minuto = calendar.component(.minute, from: date)
        let segundo = calendar.component(.second, from: date)
        
        
        let testeConexao = checkWiFi()
        if testeConexao{
            let usersReference = db.collection("ConsultorSeven").document("LastLogin").collection("\(anoAux)-\(mesAux)-\(diaAux)").document("\(id)")
            var values: [String : Any]!
            usersReference.getDocument { (document, erro) in
                if let document = document {
                    if !document.exists{
                        values = ["firstTime": "\(anoAux)-\(mesAux)-\(diaAux) \(hora):\(minuto):\(segundo)"] as [String : Any]
                        
                        usersReference.setData(values) { (error) in
                            if error != nil{
                                print("erro ao registrar login no firebase", error)
                                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                                return
                            }
                        }
                    }else{
                        values = ["lastTime": "\(anoAux)-\(mesAux)-\(diaAux) \(hora):\(minuto):\(segundo)"] as [String : Any]
                        
                        usersReference.updateData(values) { (error) in
                            if error != nil{
                                print("erro ao registrar login no firebase", error)
                                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                                return
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func setBottomBorder(textField: UITextField){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
        border.name = "bottomLine"
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
 
    func enviaUrlDatabase(nomeImg: String, url: URL, id_user: String, proposta: Proposta){
        let db = Firestore.firestore()
        let usersReference = db.collection("ConsultorSeven").document("FotosPropostas").collection("\(id_user)").document("\(proposta.id!)")
        
        var values = ["\(nomeImg)": "\(url)"] as [String : Any]
        
        usersReference.updateData(values) { (error) in
            if error != nil{
                print("erro ao cadastrar no firebase", error)
                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar foto no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                return
            }else{
                print("url enviada com sucesso")
            }
        }
    }
    
    func showImagePicker(picker: UIImagePickerController){
      //  let azul = UIColor(red: 3, green: 26, blue: 45, alpha: 1)
        
        let alertController = UIAlertController(title: "Selecionar Foto", message: "Por onde deseja selecionar sua foto?", preferredStyle: .alert)
        
        
        let galeriaAction = UIAlertAction(title: "Galeria", style: .default, handler: { alert -> Void in
            if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(picker, animated: true, completion: nil) } else { self.noCamera() }
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { alert -> Void in
            if UIImagePickerController.availableMediaTypes(for: .camera) != nil {picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(picker, animated: true, completion: nil) } else { self.noCamera() }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(cameraAction)
        alertController.addAction(galeriaAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
  
    func mudaSituacaoProposta(status:String, motivo: String, popostaEscolhida: Proposta, id_user: Int){
        let db = Firestore.firestore()
        let usersReference = db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(id_user)").document("\(popostaEscolhida.id!)")
        
        if motivo == "" {
            let values = ["situacao": status, "estaPago": ""]  as [String : Any]
            usersReference.updateData(values) { (error) in
                if error != nil{
                    print("erro ao cadastrar no firebase", error)
                    self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao alterar situação da proposta!", acaoAlerta: "OK", erroRecebido: "\(error)")
                    KRProgressHUD.dismiss()
                }else{
                    KRProgressHUD.dismiss()
                }
            }
        }else{
            let values = ["situacao": status, "motivocancelamento": motivo]  as [String : Any]
            usersReference.updateData(values) { (error) in
                if error != nil{
                    print("erro ao cadastrar no firebase", error)
                    self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao alterar situação da proposta!", acaoAlerta: "OK", erroRecebido: "\(error)")
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
    }
    
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
}

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}

extension UIView {
    func setCellShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 4
    }

    func setAnchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,
                   bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,
                   paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat,
                   paddingRight: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
        // Using a function since `var image` might conflict with an existing variable
        // (like on `UIImageView`)
        func asImage() -> UIImage {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        }
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}



extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    var isValidCPF: Bool {
        
        let numbers = characters.flatMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
    
    var isValidCNPJ: Bool {
        let numbers = characters.flatMap({Int(String($0))})
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[11] * 2 +
            numbers[10] * 3 +
            numbers[9] * 4 +
            numbers[8] * 5 +
            numbers[7] * 6 +
            numbers[6] * 7 +
            numbers[5] * 8 +
            numbers[4] * 9 +
            numbers[3] * 2 +
            numbers[2] * 3 +
            numbers[1] * 4 +
            numbers[0] * 5 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[12] * 2 +
            numbers[11] * 3 +
            numbers[10] * 4 +
            numbers[9] * 5 +
            numbers[8] * 6 +
            numbers[7] * 7 +
            numbers[6] * 8 +
            numbers[5] * 9 +
            numbers[4] * 2 +
            numbers[3] * 3 +
            numbers[2] * 4 +
            numbers[1] * 5 +
            numbers[0] * 6 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[12] && dv2 == numbers[13]
    }
    
    var match: Bool {
        return range(of: "^[A-Z]{3}\\d{4}$", options: .regularExpression) != nil
    }
}


extension UIImage {
    func compressTo(_ expectedSizeInMb:Float) -> UIImage? {
        var actualHeight : CGFloat = self.size.height
        var actualWidth : CGFloat = self.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else{
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = UIImageJPEGRepresentation(img, compressionQuality)else{
            return nil
        }
        return UIImage(data: imageData)
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
extension UIScreen {
    
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 1920.0
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
