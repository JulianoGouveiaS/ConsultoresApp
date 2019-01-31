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


class FIPEcarrosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableFIPEcarros: UITableView!
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cpf: String! = KeychainWrapper.standard.string(forKey: "CPF")
    var id: Int! = KeychainWrapper.standard.integer(forKey: "ID")
    var alamofireManager : Alamofire.SessionManager?
    var carrosArray = [FIPEcarrosInfo]()
    var searchedList = [FIPEcarrosInfo]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchBar.delegate = self
        tableFIPEcarros.keyboardDismissMode = .interactive
        KRProgressHUD.show(withMessage: "Carregando...", completion: nil)

        downloadJSON {
           self.tableFIPEcarros.reloadData()
           KRProgressHUD.showSuccess()
            
        }
        
     tableFIPEcarros.delegate = self
        tableFIPEcarros.dataSource = self
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedList.count
        } else {
             return carrosArray.count
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula_reuso", for: indexPath) as! celulaInfoFIPEcarros
        if searching {
        celula.nomeLabel.text = searchedList[indexPath.row].name.capitalized
        
        return celula
        }else{
            celula.nomeLabel.text = carrosArray[indexPath.row].name.capitalized
            
            return celula
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(carrosArray[indexPath.row].id)
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CodigoFipeVC") as! CodigoFipeVC
        view.id = self.carrosArray[indexPath.row].id
        
        self.navigationController!.pushViewController(view, animated: true)
    }
 
    func downloadJSON(completed: @escaping () -> ()) {
       
        let url = URL(string: "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/carros")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
       
                if error == nil {
                    do {
                       
                        self.carrosArray = try JSONDecoder().decode([FIPEcarrosInfo].self, from: data!)
                        
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
extension FIPEcarrosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedList = carrosArray.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableFIPEcarros.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableFIPEcarros.reloadData()
    }
    
}
