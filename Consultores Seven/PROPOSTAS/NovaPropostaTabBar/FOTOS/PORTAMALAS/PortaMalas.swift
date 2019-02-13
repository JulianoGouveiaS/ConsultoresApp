//
//  PortaMalas.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 17/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Gallery
import CFAlertViewController
import SDWebImage
import Agrume


class PortaMalas: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GalleryControllerDelegate {
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var ArrFotosUrls = [String]()
    let db = Firestore.firestore()
    
    var propostaEscolhida: Proposta!
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    var permissao = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFotos()
        getPermissao(id_user: "\(self.id_user!)", propostaEscolhida: self.propostaEscolhida)
        MakeButtonsNav()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
    }
    
    func MakeButtonsNav(){
        
        let Plusbutton: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        Plusbutton.setImage(UIImage(named: "add"), for: UIControlState.normal)
        Plusbutton.addTarget(self, action: "addFoto", for: UIControlEvents.touchUpInside)
        Plusbutton.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonPlus = UIBarButtonItem(customView: Plusbutton)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButtonPlus
    }
    
    @objc func addFoto(){
     self.showGallery(ArrFotosUrls: self.ArrFotosUrls, totalFotos: 1, permissao: self.permissao)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ArrFotosUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let url: String = self.ArrFotosUrls[indexPath.row]{
            if url == ""{
                let myCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "celulareuso2", for: indexPath as IndexPath)
                return myCell2
                
            }else{
                let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "celulareuso", for: indexPath as IndexPath) as! CellCollectionPropostas
                myCell.imagem.tag = indexPath.row
                myCell.backgroundColor = UIColor.clear
                myCell.imagem.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "imgLoad"))
                let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
                tapGesture.numberOfTapsRequired = 1
                self.myCollectionView.addGestureRecognizer(tapGesture)
                
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
                self.myCollectionView.addGestureRecognizer(longPressRecognizer)
                
                myCell.imagem.clipsToBounds = true
                
                return myCell
            }
        }
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if let indexPath = self.myCollectionView?.indexPathForItem(at: sender.location(in: self.myCollectionView)) {
            let cell = self.myCollectionView?.cellForItem(at: indexPath) as! CellCollectionPropostas
            if cell.imagem.image != nil{
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
                                                    
                                                    self.removeFoto(field: "p_malas_st", proposta: self.propostaEscolhida!, id_user: "\(self.id_user!)")
                                                    self.ArrFotosUrls[indexPath.row] = ""
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
                
            } else {
                print("collection view was long pressed")
            }
            
        }
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        
        if let indexPath = self.myCollectionView?.indexPathForItem(at: sender.location(in: self.myCollectionView)) {
            let cell = self.myCollectionView?.cellForItem(at: indexPath) as! CellCollectionPropostas
            if cell.imagem.image != nil{
                let agrume = Agrume(image: cell.imagem.image!)
                agrume.show(from: self)
            }
        } else {
            print("collection view was tapped")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
    }
    
    func loadFotos(){
        KRProgressHUD.show()
        
        db.collection("ConsultorSeven").document("FotosPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ArrFotosUrls = []
                
                let dictionary = querySnapshot?.data()
                if (dictionary?["p_malas_st"] as? String ?? "").contains(".jpg"){
                    self.ArrFotosUrls.append("https://firebasestorage.googleapis.com/v0/b/seven-app-61ea3.appspot.com/o/\(dictionary?["p_malas_st"] as? String ?? "")?alt=media")
                }else{
                self.ArrFotosUrls.append(dictionary?["p_malas_st"] as? String ?? "")
                }
                
                self.myCollectionView.reloadData()
            }
            KRProgressHUD.dismiss()
        }
    }
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
        images[0].resolve(completion: { (imagem) in
            let data = UIImagePNGRepresentation(imagem!)
            
            let fotoComprimida = self.colocaLogo(imgData: data!).compressTo(0.2)
            print("data1.count => \(data!.count) \n fotoComprimida.count => \(String(describing: UIImagePNGRepresentation(fotoComprimida!)))" )
            
            self.enviaFotoStorage(nomeImg: "p_malas_st", imagem: fotoComprimida!, id_user: "\(self.id_user!)", proposta: self.propostaEscolhida)
           
            
        })
        controller.dismiss(animated: true, completion: nil)
         self.myCollectionView.reloadData()
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
}
