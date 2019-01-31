//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

//
// MARK: - View Controller
//
class CollapsibleViewController: UITableViewController {
    var placaEscolhida = ""
    var sections = sectionsData
    var dataProposta = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataProposta)
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = "Detalhes"
        
        let imgbutton: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        imgbutton.setTitle("Fotos", for: .normal)
        imgbutton.setTitleColor(UIColor.blue, for: .normal)
        imgbutton.addTarget(self, action: "VerImagens", for: UIControlEvents.touchUpInside)
        imgbutton.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonImg = UIBarButtonItem(customView: imgbutton)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButtonImg
    }
    
    @objc func VerImagens(){
        self.CriarAlertaSemErro(tituloAlerta: "Atenção", mensagemAlerta: "A visualização de fotos foi desabilitada por questões de segurança. Permanecerão ocultas até segunda ordem.", acaoAlerta: "Ok")
     //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "FotosEnviadasVC") as! FotosEnviadasVC
      //  vc.placaEscolhida = self.placaEscolhida
      //  self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//
// MARK: - View Controller DataSource and Delegate
//
extension CollapsibleViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    
    // Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item: Item = sections[indexPath.section].items[indexPath.row]
        
        cell.nameLabel.text = item.name
        if sections[indexPath.section].name == "Informações do cliente"{
            cell.detailLabel.text = "\(dataProposta[indexPath.row])"
        }else{
            cell.detailLabel.text = "\(dataProposta[indexPath.row + 15] )"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

}

//
// MARK: - Section Header Delegate
//
extension CollapsibleViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
