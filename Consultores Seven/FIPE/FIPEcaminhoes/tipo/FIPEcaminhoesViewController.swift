//
//  FIPEcarrosViewController.swift
//  SevenPV
//
//  Created by Juliano Gouveia on 22/02/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD


class FIPEcaminhoesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableFIPEcaminhoes: UITableView!
    
    var cpf: String! = KeychainWrapper.standard.string(forKey: "CPF")
    var id: Int! = KeychainWrapper.standard.integer(forKey: "ID")
    var alamofireManager : Alamofire.SessionManager?
    var caminhoesArray = [FIPEcaminhoesInfo]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchedList = [FIPEcaminhoesInfo]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchBar.delegate = self
        KRProgressHUD.show(withMessage: "Carregando...", completion: nil)

        downloadJSON {
           self.tableFIPEcaminhoes.reloadData()
           KRProgressHUD.showSuccess()
            
        }
        
     tableFIPEcaminhoes.delegate = self
        tableFIPEcaminhoes.dataSource = self
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if searching {
            return searchedList.count
        } else {
             return caminhoesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula_reuso", for: indexPath) as! celulaInfoFIPEcaminhoes
        if searching {
            celula.nomeLabel.text = searchedList[indexPath.row].name.capitalized
            
            return celula
        }else{
            celula.nomeLabel.text = caminhoesArray[indexPath.row].name.capitalized
            
            return celula
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(caminhoesArray[indexPath.row].id)
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CodigoFipeVCcaminhoes") as! CodigoFipeVCcaminhoes
        let codigo = self.caminhoesArray[indexPath.row].id
        view.codigo = codigo
        self.navigationController!.pushViewController(view, animated: true)
    }
 
    func downloadJSON(completed: @escaping () -> ()) {
       
        let url = URL(string: "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/caminhoes")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
       
                if error == nil {
                    do {
                       
                        self.caminhoesArray = try JSONDecoder().decode([FIPEcaminhoesInfo].self, from: data!)
                        
                        DispatchQueue.main.async {
                            completed()
                        }
                    }catch{
                        print("JSON Error")
                    }
                }
            }.resume()
            
        }
      
}
extension FIPEcaminhoesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedList = caminhoesArray.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableFIPEcaminhoes.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableFIPEcaminhoes.reloadData()
    }
    
}
