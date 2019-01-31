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


class CodigoFipeVCcaminhoes: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableFIPEcaminhoes: UITableView!
    
    var cpf: String! = KeychainWrapper.standard.string(forKey: "CPF")
    var codigo: Int!
    var alamofireManager : Alamofire.SessionManager?
    var caminhoesArray = [FIPEcaminhoesInfo2]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
        return caminhoesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula_reuso", for: indexPath) as! celulaInfoFIPEcaminhoes2
       
        celula.nomeLabel.text = caminhoesArray[indexPath.row].name.capitalized
        
        return celula
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ModeloFipeVCcaminhoes") as! ModeloFipeVCcaminhoes
        view.codigo = self.codigo
        let modelo = self.caminhoesArray[indexPath.row].id
        view.modelo = modelo
        self.navigationController!.pushViewController(view, animated: true)
        
    }
    
    func downloadJSON(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/caminhoes/\(self.codigo!)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    
                    self.caminhoesArray = try JSONDecoder().decode([FIPEcaminhoesInfo2].self, from: data!)
                    
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

