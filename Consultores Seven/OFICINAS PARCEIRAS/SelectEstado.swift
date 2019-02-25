//
//  TableOficinasVCViewController.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 19/02/2019.
//  Copyright © 2019 Juliano Gouveia. All rights reserved.
//

import UIKit
import Static
import CFAlertViewController

class SelectEstado: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    
    private let customAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    
    // MARK: - Initializers
    var dataSource = DataSource()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
        
        self.navigationController?.isNavigationBarHidden = false
        tableView.rowHeight = 50
        
        // Note:
        // Required to be set pre iOS11, to support autosizing
        tableView.estimatedSectionHeaderHeight = 13.5
        tableView.estimatedSectionFooterHeight = 13.5
        
        dataSource.sections = [
            Section(header: "Escolha o Estado", rows: [
                Row(text: "Distrito Federal", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Oficinas", bundle: nil).instantiateViewController(withIdentifier: "TabelaOficinasVC") as? TabelaOficinasVC
                    vc?.estadoSelecionado = 0
                    self.navigationController!.pushViewController(vc!, animated: true)
                }),
                Row(text: "Goiás", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Oficinas", bundle: nil).instantiateViewController(withIdentifier: "TabelaOficinasVC") as? TabelaOficinasVC
                    vc?.estadoSelecionado = 1
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                }),
                Row(text: "Mato Grosso", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Oficinas", bundle: nil).instantiateViewController(withIdentifier: "TabelaOficinasVC") as? TabelaOficinasVC
                    vc?.estadoSelecionado = 2
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                }),
                Row(text: "Mato Grosso do Sul", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Oficinas", bundle: nil).instantiateViewController(withIdentifier: "TabelaOficinasVC") as? TabelaOficinasVC
                    vc?.estadoSelecionado = 3
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                }),
                Row(text: "Minas Gerais", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Oficinas", bundle: nil).instantiateViewController(withIdentifier: "TabelaOficinasVC") as? TabelaOficinasVC
                    vc?.estadoSelecionado = 4
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                }),
                Row(text: "Paraná", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Oficinas", bundle: nil).instantiateViewController(withIdentifier: "TabelaOficinasVC") as? TabelaOficinasVC
                    vc?.estadoSelecionado = 5
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                }),
                Row(text: "São Paulo", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Oficinas", bundle: nil).instantiateViewController(withIdentifier: "TabelaOficinasVC") as? TabelaOficinasVC
                    vc?.estadoSelecionado = 6
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                })
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

extension SelectEstado: UITableViewDelegate {
    // MARK: - UIScrollViewDelegate example functions
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // You can get UIScrollViewDelegate functions forwarded, even though the `DataSource` instance is the true delegate
        // ...
    }
    
    // MARK: - UITableViewDelegate example functions
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // You can get UITableViewDelegate functions forwarded, even though the `DataSource` instance is the true delegate
        // ...
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The Row object's `selection` property will handle most of your use cases, but
        // if you need to do something additional you can still implement this function.
    }
}

