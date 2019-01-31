//
//  MenuClienteVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Static
import CFAlertViewController

class MenuClienteVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initializers
    var dataSource = DataSource()
    
    
    private let faceAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = UIColor.clear
        let imageView = UIImageView(image: UIImage(named: "facebook"))
        imageView.frame = view.frame
        view.addSubview(imageView)
        return view
    }()
    private let instaAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = UIColor.clear
        let imageView = UIImageView(image: UIImage(named: "instagram"))
        imageView.frame = view.frame
        view.addSubview(imageView)
        return view
    }()
    private let ytAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = UIColor.clear
        let imageView = UIImageView(image: UIImage(named: "youtube"))
        imageView.frame = view.frame
        view.addSubview(imageView)
        return view
    }()
    private let twitterAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = UIColor.clear
        let imageView = UIImageView(image: UIImage(named: "twitter"))
        imageView.frame = view.frame
        view.addSubview(imageView)
        return view
    }()
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
        
        tableView.rowHeight = 50
        
        // Note:
        // Required to be set pre iOS11, to support autosizing
        tableView.estimatedSectionHeaderHeight = 13.5
        tableView.estimatedSectionFooterHeight = 13.5
        
        dataSource.sections = [
            Section(header: "Seven Proteção Veicular", rows: [
                Row(text: "FIPE", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "FIPEStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TipoSimuladorViewController") as? TipoSimuladorViewController
                    self.navigationController!.pushViewController(vc!, animated: true)
                }),
                Row(text: "Suporte", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuporteVC") as? SuporteVC
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                }),
                Row(text: "Telefones Úteis", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TelefonesUteisVC") as? TelefonesUteisVC
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                }),
                Row(text: "Sobre o App", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "SobreCliente", bundle: nil).instantiateViewController(withIdentifier: "SobreClienteVC") as? SobreClienteVC
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                }),
                Row(text: "Meus Benefícios", detailText: "", selection: { [unowned self] in
                    
                    if let url = URL(string: "https://seven.convenia.com.br/") {
                        UIApplication.shared.open(url, options: [:])
                    }else{
                        self.CriarAlertaSemErro(tituloAlerta: "Opa!", mensagemAlerta: "Página temporiariamente indisponível", acaoAlerta: "OK")
                    }
                }),
            ]),
            Section(header: "Nos Siga", rows: [
                Row(text: "/sevenpveicular", accessory: .view(faceAccessory)),
                
                Row(text: "/Seven Proteção Veicular", accessory: .view(ytAccessory)),
                
                Row(text: "@sevenprotecaoveicular", accessory: .view(instaAccessory)),
                
                Row(text: "@SevenpvUdia", accessory: .view(twitterAccessory)),
 
                ]),
                
            Section(header: "", rows: [
                Row(text: "Deslogar", detailText: "", selection: { [unowned self] in
                    
                    self.logoutApp()
                    
                    }, cellClass: ButtonCell.self),
                ])
        ]
    }
    
    
    
    // MARK: - Private
    
    private func showAlert(title: String? = nil, message: String? = "You tapped it. Good work.", button: String = "Thanks") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
