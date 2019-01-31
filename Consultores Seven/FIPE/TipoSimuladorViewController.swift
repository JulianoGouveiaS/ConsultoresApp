//
//  TipoSimuladorViewController.swift
//  SevenPV
//
//  Created by Juliano Gouveia on 26/02/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Static
import CFAlertViewController


class TipoSimuladorViewController: UIViewController {
    
  @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initializers
    var dataSource = DataSource()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = false
        dataSource.tableView = tableView
        
        tableView.rowHeight = 50
        
        // Note:
        // Required to be set pre iOS11, to support autosizing
        tableView.estimatedSectionHeaderHeight = 13.5
        tableView.estimatedSectionFooterHeight = 13.5
        
        dataSource.sections = [
            Section(header: "ESCOLHA", rows: [
                Row(text: "Carro", detailText: "", selection: { [unowned self] in
                    let vc = UIStoryboard(name: "FIPEStoryboard", bundle: nil).instantiateViewController(withIdentifier: "FIPEcarrosViewController") as? FIPEcarrosViewController
                    self.navigationController!.pushViewController(vc!, animated: true)
                    }, cellClass: ButtonCell.self),
                Row(text: "Moto", detailText: "", selection: { [unowned self] in
                    let vc = UIStoryboard(name: "FIPEStoryboard", bundle: nil).instantiateViewController(withIdentifier: "FIPEmotosViewController") as? FIPEmotosViewController
                    self.navigationController!.pushViewController(vc!, animated: true)
                    }, cellClass: ButtonCell.self),
                Row(text: "Caminhão", detailText: "", selection: { [unowned self] in
                    let vc = UIStoryboard(name: "FIPEStoryboard", bundle: nil).instantiateViewController(withIdentifier: "FIPEcaminhoesViewController") as? FIPEcaminhoesViewController
                    self.navigationController!.pushViewController(vc!, animated: true)
                    }, cellClass: ButtonCell.self),
                ])
        ]
        
    }
    @objc func voltarMain() {
      
        if let tabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as? TabBarPrincipal {
            tabViewController.selectedIndex = 3
            navigationController?.pushViewController(tabViewController, animated: true)
        }

    }

   
}
