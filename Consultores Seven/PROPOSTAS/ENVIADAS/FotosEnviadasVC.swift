//
//  FotosEnviadasVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 24/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Gallery
import CFAlertViewController
import SDWebImage
import Agrume


class FotosEnviadasVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GalleryControllerDelegate {
    
    
    
    @IBOutlet weak var imgBackSemImg: UIImageView!
    @IBOutlet weak var lblSemImg: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var ArrFotosUrls = [String]()
    let db = Firestore.firestore()
    var placaEscolhida = ""
    var propostaEscolhida: Proposta!
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPropostaEscolhida()
     
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ArrFotosUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
       let url: String = self.ArrFotosUrls[indexPath.row]
      
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "celulareuso", for: indexPath as IndexPath) as! CellCollectionPropostas
            myCell.imagem.tag = indexPath.row
            myCell.backgroundColor = UIColor.clear
            myCell.imagem.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "imgLoad"))
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            tapGesture.numberOfTapsRequired = 1
            self.myCollectionView.addGestureRecognizer(tapGesture)
            
            myCell.imagem.clipsToBounds = true
            
            return myCell
        
        
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        
        if let indexPath = self.myCollectionView?.indexPathForItem(at: sender.location(in: self.myCollectionView)) {
            print("indexPath => \(indexPath)")
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
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        print("didSelectVideo")
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print("requestLightbox")
    }
    
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func loadFotos(propostaId: String){
      
        db.collection("ConsultorSeven").document("FotosPropostas").collection("\(self.id_user!)").document("\(propostaId)").getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                KRProgressHUD.dismiss()
            } else {
                self.ArrFotosUrls = []
                
                let dictionary = querySnapshot?.data()
                
                self.ArrFotosUrls.append(dictionary?["proposta_st"] as? String ?? "")
                
                for i in 1...4{
                    self.ArrFotosUrls.append(dictionary?["doc\(i)_st"] as? String ?? "")
                }
                
                self.ArrFotosUrls.append(dictionary?["dut_st"] as? String ?? "")
                
                for i in 1...2{
                    self.ArrFotosUrls.append(dictionary?["fronta\(i)_st"] as? String ?? "")
                }
                
                for i in 1...4{
                    self.ArrFotosUrls.append(dictionary?["lat\(i)_st"] as? String ?? "")
                }
                
                for i in 1...12{
                    self.ArrFotosUrls.append(dictionary?["vidro\(i)_st"] as? String ?? "")
                }
                
                for i in 1...10{
                    self.ArrFotosUrls.append(dictionary?["avaria\(i)_st"] as? String ?? "")
                }
                
                self.ArrFotosUrls.append(dictionary?["traseira_st"] as? String ?? "")
                
                self.ArrFotosUrls.append(dictionary?["p_malas_st"] as? String ?? "")
                
                self.ArrFotosUrls.append(dictionary?["teto_st"] as? String ?? "")
                
                self.ArrFotosUrls.append(dictionary?["motor_st"] as? String ?? "")
                
                self.ArrFotosUrls.append(dictionary?["chassi_st"] as? String ?? "")
                
                self.ArrFotosUrls.append(dictionary?["veloc_st"] as? String ?? "")
                
                for i in 1...4{
                    self.ArrFotosUrls.append(dictionary?["esto\(i)_st"] as? String ?? "")
                }
                
                for i in 1...2{
                    self.ArrFotosUrls.append(dictionary?["lanterna\(i)_st"] as? String ?? "")
                }
                
                for i in 1...2{
                    self.ArrFotosUrls.append(dictionary?["farol\(i)_st"] as? String ?? "")
                }
                
                for i in 1...6{
                    self.ArrFotosUrls.append(dictionary?["pneu\(i)_st"] as? String ?? "")
                }
                
                self.ArrFotosUrls.append(dictionary?["veloc_st"] as? String ?? "")
                
                self.ArrFotosUrls.append(dictionary?["teto_st"] as? String ?? "")
                
                
                self.ArrFotosUrls = self.ArrFotosUrls.filter({ $0 != "" })
               
                self.myCollectionView.reloadData()
                KRProgressHUD.dismiss()
            }
            KRProgressHUD.dismiss()
        }
    }
    
    func loadPropostaEscolhida(){
         KRProgressHUD.show(withMessage: "Carregando imagens...", completion: nil)
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").order(by: "data", descending: true).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                KRProgressHUD.dismiss()
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                   
                    if dictionary["placa"] as? String == self.placaEscolhida{
                        
                        self.imgBackSemImg.isHidden = true
                        self.lblSemImg.isHidden = true
                        self.loadFotos(propostaId: "\(document.documentID)")
                    
                    }
                }
                KRProgressHUD.dismiss()
            }
        }
        
      
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
    }
}
