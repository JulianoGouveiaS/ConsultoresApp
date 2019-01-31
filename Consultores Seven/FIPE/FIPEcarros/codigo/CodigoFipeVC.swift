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


class CodigoFipeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableFIPEcarros: UITableView!
    
    var cpf: String! = KeychainWrapper.standard.string(forKey: "CPF")
    var id: Int!
    var alamofireManager : Alamofire.SessionManager?
    var carrosArray = [FIPEcarrosInfo2]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
        return carrosArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula_reuso", for: indexPath) as! celulaInfoFIPEcarros2
        let dadoCelula = carrosArray[indexPath.row]
        celula.nomeLabel.text = carrosArray[indexPath.row].name.capitalized
        
        return celula
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ModeloFipeVC") as! ModeloFipeVC
        view.id = self.id
        view.modelo = self.carrosArray[indexPath.row].id
        self.navigationController!.pushViewController(view, animated: true)
        
    }
    
    func downloadJSON(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/carros/\(self.id!)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    
                    self.carrosArray = try JSONDecoder().decode([FIPEcarrosInfo2].self, from: data!)
                    
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

