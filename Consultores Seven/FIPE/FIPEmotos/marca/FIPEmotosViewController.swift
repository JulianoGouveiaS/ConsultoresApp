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

class FIPEmotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableFIPEmotos: UITableView!
    
    var cpf: String! = KeychainWrapper.standard.string(forKey: "CPF")
    var id: Int! = KeychainWrapper.standard.integer(forKey: "ID")
    var alamofireManager : Alamofire.SessionManager?
    var motosArray = [FIPEmotosInfo]()
    @IBOutlet weak var searchBar: UISearchBar!
    var searchedList = [FIPEmotosInfo]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
       
        KRProgressHUD.show(withMessage: "Carregando...", completion: nil)

        downloadJSON {
           self.tableFIPEmotos.reloadData()
           KRProgressHUD.showSuccess()
            
        }
        
     tableFIPEmotos.delegate = self
        tableFIPEmotos.dataSource = self
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedList.count
        } else {
           return motosArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula_reuso", for: indexPath) as! celulaInfoFIPEmotos
        if searching {
            celula.nomeLabel.text = searchedList[indexPath.row].name.capitalized
            
            return celula
        }else{
            celula.nomeLabel.text = motosArray[indexPath.row].name.capitalized
            
            return celula
        }
        
        return celula
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(motosArray[indexPath.row].id)
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CodigoFipeVCmotos") as! CodigoFipeVCmotos
        view.id = self.motosArray[indexPath.row].id
        self.navigationController!.pushViewController(view, animated: true)
    }
 
    func downloadJSON(completed: @escaping () -> ()) {
       
        let url = URL(string: "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/motos")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
       
                if error == nil {
                    do {
                       
                        self.motosArray = try JSONDecoder().decode([FIPEmotosInfo].self, from: data!)
                        
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


extension FIPEmotosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedList = motosArray.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableFIPEmotos.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableFIPEmotos.reloadData()
    }
    
}
