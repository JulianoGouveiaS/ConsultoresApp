//
//  PerfilViewController.swift
//  EventosApp
//
//  Created by Juliano Gouveia on 02/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Static
import KRProgressHUD
import FirebaseStorage
import FirebaseFirestore
import Agrume
import Gallery

class PerfilViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, GalleryControllerDelegate {
   
  var ArrFotosUrls = [String]()
      @IBOutlet weak var tableView: UITableView!
      @IBOutlet weak var imageUser: UIImageView!
    let dataSource = DataSource()
     let picker = UIImagePickerController()
    var id_user = KeychainWrapper.standard.integer(forKey: "ID")
    var nivel_id = KeychainWrapper.standard.string(forKey: "NIVEL_ID")
    var nome = KeychainWrapper.standard.string(forKey: "NOME")
    var cpf = KeychainWrapper.standard.string(forKey: "CPF")
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgTapped(sender:)))
        imageUser.addGestureRecognizer(tapGesture)
        dataSource.tableView = tableView
         picker.delegate = self
        self.loadDadosUser()
        
        imageUser.layer.borderWidth = 0
        imageUser.layer.masksToBounds = true
        imageUser.layer.cornerRadius = imageUser.frame.height/2
        imageUser.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    func imgTapped(sender: UITapGestureRecognizer) {
        
        if imageUser.image != nil{
            let agrume = Agrume(image: imageUser.image!)
            agrume.show(from: self)
        }
        
    }
    func loadDadosUser(){
        KRProgressHUD.show()
        let db = Firestore.firestore()
        db.collection("ConsultorSeven").document("Perfil").collection("\(self.id_user!)").document("Dados").addSnapshotListener { (doc, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                print("\(doc!.documentID) => \(doc!.data())")
                let dictionary = doc!.data()
                
                
                let avaliacao_media = dictionary!["avaliacao_media"] as? String ?? ""
                let cpf = dictionary!["cpf"] as? String ?? ""
                let id = dictionary!["id"] as? String ?? ""
                let conquistas_totais = dictionary!["conquistas_totais"] as? String ?? ""
                let nivel_id = dictionary!["nivel_id"] as? String ?? ""
                let nome = dictionary!["nome"] as? String ?? ""
                let recado = dictionary!["recado"] as? String ?? ""
                let vendas_totais = dictionary!["vendas_totais"] as? String ?? ""
                let imgUser = dictionary!["fotoperfil"] as? String ?? ""
                
                
                self.dataSource.sections = [
                    Section(header: "", rows: [
                        
                        Row(text: "Nome", detailText: nome, cellClass: SubtitleCell.self),
                        Row(text: "CPF", detailText: cpf, cellClass: SubtitleCell.self),
                        Row(text: "ID", detailText: id, cellClass: SubtitleCell.self),
                        Row(text: "Alterar foto de perfil", detailText: "", selection: { [unowned self] in
                            
                            let gallery = GalleryController()
                            gallery.delegate = self as! GalleryControllerDelegate
                            Config.Camera.recordLocation = true
                                Config.tabsToShow = [.imageTab, .cameraTab]
                            
                            let filteredArray = self.ArrFotosUrls.filter {$0 != ""}
                            let countImagens = 1 - filteredArray.count
                            print("countImagens =>", countImagens)
                            if countImagens <= 0 {
                                self.CriarAlertaSemErro(tituloAlerta: "Opa!", mensagemAlerta: "Limite de imagens atingido.", acaoAlerta: "Ok")
                                return
                            }
                            Config.Camera.imageLimit = countImagens
                            self.present(gallery, animated: true, completion: nil)
                        }, cellClass: ButtonCell.self)
                        ])
                ]
                
                if imgUser != ""{
                    self.loadImageUser(urlStr: imgUser, imgView: self.imageUser)
                }
               
                
                KRProgressHUD.dismiss()
                
            }
        }
    }
    fileprivate func extractedFunc(_ image: Image) {
       
            //string apenas para ocupar o array e nao entrar no mesmo if duas vezes
        
            image.resolve(completion: { (imagem) in
                let data = UIImagePNGRepresentation(imagem!)
                self.imageUser.image = imagem
                if let fotoComprimida = self.colocaLogo(imgData: data!).compressTo(0.2) {
                    print("data.count => \(data!.count) \n fotoComprimida.count => \(fotoComprimida)" )
                    
                    self.enviaFotoPerfil(nomeImg: "fotoperfil", imagemDados: UIImagePNGRepresentation(fotoComprimida)!, id_user: "\(self.id_user!)")
                    }
                
            })
        }
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        print("didSelectVideo")
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        print("DidCancel")
    }
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print("requestLightbox")
    }
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        for image in images{
            
            extractedFunc(image)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func loadImageUser(urlStr: String!,imgView: UIImageView){
        let url = URL(string: urlStr)
        imgView.sd_setImage(with: url, completed: { (imagem, erro, cache, url) in
            imgView.image = imagem
        })
    }
    
   
}
