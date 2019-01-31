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


class ModeloFipeVCcaminhoes: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableFIPEcaminhoes: UITableView!
    var codigo: Int!
    var cpf: String! = KeychainWrapper.standard.string(forKey: "CPF")
    var modelo: Int!
    var alamofireManager : Alamofire.SessionManager?
    var caminhoesArray = [FIPEcaminhoesInfo3]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        KRProgressHUD.show(withMessage: "Carregando...", completion: nil)
      
        downloadJSON {
            print("sucesso")
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
        return caminhoesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula_reuso", for: indexPath) as! celulaInfoFIPEcaminhoes3
      
        celula.nomeLabel.text = caminhoesArray[indexPath.row].name.capitalized
        
        return celula
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(caminhoesArray[indexPath.row].id)
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "TabelaViewControllercaminhoes") as! TabelaViewControllercaminhoes
        view.codigo = self.codigo
        view.modelo = self.modelo
        view.id = self.caminhoesArray[indexPath.row].id
self.navigationController!.pushViewController(view, animated: true)
 }
 
    func downloadJSON(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/motos/\(self.codigo!)/\(self.modelo!)")
        print(url!)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
       
                if error == nil {
                    do {
                       
                        self.caminhoesArray = try JSONDecoder().decode([FIPEcaminhoesInfo3].self, from: data!)
                        
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
