//
//  VideoVistoriaVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 25/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import AVFoundation
import Static
import KRProgressHUD
import FirebaseFirestore
import CFAlertViewController
import MobileCoreServices
import FirebaseStorage
import SwiftyPickerPopover

class VideoVistoriaVC: UIViewController {
    let db = Firestore.firestore()
    var player: AVPlayer!
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    var propostaEscolhida: Proposta!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MakeButtonsNav()
        
       loadVideo()
 
        // Do any additional setup after loading the view.
    }
    func loadVideo(){
        
        KRProgressHUD.show()
        db.collection("ConsultorSeven").document("FotosPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let dictionary = querySnapshot?.data()
                
                if let videoURL = URL(string: (dictionary?["video_vistoria"] as? String ?? "")){
                    self.player = AVPlayer(url: videoURL)
                    let playerLayer = AVPlayerLayer(player: self.player)
                    playerLayer.frame = self.view.bounds
                    self.view.layer.addSublayer(playerLayer)
                    KRProgressHUD.dismiss()
                    self.player.play()
                }
                KRProgressHUD.dismiss()
            }
            KRProgressHUD.dismiss()
        }
    }
    
    
    deinit {
        self.player = nil
    }
    
    
    @objc func record() {
        if self.player != nil{
            self.player.isMuted = true
        }
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    func MakeButtonsNav(){
        
        let Plusbutton: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        Plusbutton.setImage(UIImage(named: "add"), for: UIControlState.normal)
        Plusbutton.addTarget(self, action: "record", for: UIControlEvents.touchUpInside)
        Plusbutton.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonPlus = UIBarButtonItem(customView: Plusbutton)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButtonPlus
    }
    
   
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        if self.player != nil{
            self.player.isMuted = false
        }
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video salvo com sucesso" : "Falha ao enviar video"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension VideoVistoriaVC: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        if self.player != nil{
            self.player.isMuted = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if self.player != nil{
            self.player.isMuted = false
        }
        KRProgressHUD.show()
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerControllerMediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            
            else { return }
        
        
        if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
            // we selected a video
            print("Here's the file URL: ", videoURL)
            let nomeVideo = NSDate().timeIntervalSince1970 * 1000
            // Where we'll store the video:
            let storageReference = Storage.storage().reference().child("\(nomeVideo).MOV")
            
            // Start the video storage process
            storageReference.putFile(from: videoURL as URL, metadata: nil, completion: { (metadata, error) in
                if error == nil {
                    print("Successful video upload")
        
                    storageReference.downloadURL(completion: { (url, erro) in
                        print(url)
                        
                        let db = Firestore.firestore()
                        let usersReference = db.collection("ConsultorSeven").document("FotosPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)")
                        
                        var values = ["video_vistoria": "\(url!)"] as [String : Any]
                        
                        usersReference.updateData(values) { (error) in
                            if error != nil{
                                print("erro ao cadastrar no firebase", error)
                                self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar video!", acaoAlerta: "OK", erroRecebido: "\(error)")
                                KRProgressHUD.dismiss()
                                return
                            }else{
                                print("url enviada com sucesso")
                                KRProgressHUD.dismiss()
                            }
                        }
                    })
                    
                    KRProgressHUD.dismiss()
                } else {
                    self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao enviar video!", acaoAlerta: "OK", erroRecebido: "\(error)")
                    print(error?.localizedDescription)
                    KRProgressHUD.dismiss()
                }
            })
            
        }
        //Dismiss the controller after picking some media
        dismiss(animated: true, completion: nil)
        
        
        // Handle a movie capture
        
        // Handle a movie capture
        UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        KRProgressHUD.dismiss()
    }
    
    
    
}

// MARK: - UINavigationControllerDelegate

extension VideoVistoriaVC: UINavigationControllerDelegate {
}


