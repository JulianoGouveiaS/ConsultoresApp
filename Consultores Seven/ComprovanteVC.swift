//
//  ComprovanteVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 24/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD

class ComprovanteVC: UIViewController {

    @IBOutlet weak var comprovanteViewMenor: UIView!
    @IBOutlet weak var idVendaLbl: UILabel!
    @IBOutlet weak var nomeLbl: UILabel!
    @IBOutlet weak var cartaoLbl: UILabel!
    @IBOutlet weak var placaLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var parcelasLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    var idVendaRecebido = ""
    var nomeRecebido = ""
    var cartaoRecebido = ""
    var placaRecebido = ""
    var dataRecebido = ""
    var parcelasRecebido = ""
    var totalRecebido = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.idVendaLbl.text = idVendaRecebido
        self.nomeLbl.text = nomeRecebido
        self.cartaoLbl.text = cartaoRecebido
        self.placaLbl.text = placaRecebido
        self.dataLbl.text = dataRecebido
        self.parcelasLbl.text = parcelasRecebido
        self.totalLbl.text = totalRecebido
        
        let salvarComprovante: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        salvarComprovante.setTitle("Salvar", for: .normal)
        salvarComprovante.setTitleColor(UIColor.blue, for: .normal)
        salvarComprovante.addTarget(self, action: "salvarComprovante", for: UIControlEvents.touchUpInside)
        salvarComprovante.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonSave = UIBarButtonItem(customView: salvarComprovante)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButtonSave
        
    }
    
    @objc func salvarComprovante(){
        let imgComprovante = self.comprovanteViewMenor.asImage()
        UIImageWriteToSavedPhotosAlbum(imgComprovante, self, nil, nil)
        KRProgressHUD.showMessage("Comprovante Salvo")
    }

  
}
