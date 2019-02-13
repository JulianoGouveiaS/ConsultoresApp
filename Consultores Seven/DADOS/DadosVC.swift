//
//  DadosVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Static
import CFAlertViewController

class DadosVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    
    private let customAccessory: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    
    // MARK: - Initializers
    var dataSource = DataSource()
    
    
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
            Section(header: "Extras", rows: [
                Row(text: "FIPE", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Fipe", bundle: nil).instantiateViewController(withIdentifier: "FipeVC") as? FipeVC
                    self.navigationController!.pushViewController(vc!, animated: true)
                    }),
                Row(text: "Meus Pagamentos", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TablePagamentosVC") as? TablePagamentosVC
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                    }),
                Row(text: "Suporte", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuporteVC") as? SuporteVC
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                    }),
                Row(text: "Telefones Úteis", detailText: "", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TelefonesUteisVC") as? TelefonesUteisVC
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                    })
                ]),
            Section(header: "Ajuda", rows: [
                Row(text: "Sobre o Aplicativo", detailText: "Informações gerais.", selection: { [unowned self] in
                    
                    let vc = UIStoryboard(name: "SobreConsultor", bundle: nil).instantiateViewController(withIdentifier: "SobreVC") as? SobreVC
                    self.navigationController!.pushViewController(vc!, animated: true)
                    
                    
                    }, cellClass: SubtitleCell.self),
              /*  Row(text: "Manual", detailText: "Informações detalhadas.", selection: { [unowned self] in
                    
                    //     let vc = UIStoryboard(name: "InfoEvento", bundle: nil).instantiateViewController(withIdentifier: "InfoEventoVC") as? InfoEventoVC
                    //     self.navigationController!.pushViewController(vc!, animated: true)
                    
                    }, cellClass: SubtitleCell.self),
                Row(text: "Vídeo Tutorial", detailText: "Vídeo explicativo sobre uso do app.", selection: { [unowned self] in
                    
                 //   let vc = UIStoryboard(name: "InfoEvento", bundle: nil).instantiateViewController(withIdentifier: "InfoEventoVC") as? InfoEventoVC
                //     self.navigationController!.pushViewController(vc!, animated: true)
                    
                    }, cellClass: SubtitleCell.self),
                Row(text: "Manual do Associado", detailText: "Manual de uso em PDF.", selection: { [unowned self] in
                    
                    //     let vc = UIStoryboard(name: "InfoEvento", bundle: nil).instantiateViewController(withIdentifier: "InfoEventoVC") as? InfoEventoVC
                    //     self.navigationController!.pushViewController(vc!, animated: true)
                    
                    }, cellClass: SubtitleCell.self) */
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

extension TableViewController: UITableViewDelegate {
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

class LargeAutoSizedExtremityView: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Is this the real life?\nIs this just fantasy?\nCaught in a landslide,\nNo escape from reality."
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
