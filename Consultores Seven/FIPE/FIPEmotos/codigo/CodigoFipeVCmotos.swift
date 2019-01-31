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


class CodigoFipeVCmotos: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableFIPEmotos: UITableView!
    
    var cpf: String! = KeychainWrapper.standard.string(forKey: "CPF")
    var id: Int!
    var alamofireManager : Alamofire.SessionManager?
    var motosArray = [FIPEmotosInfo2]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
        return motosArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula_reuso", for: indexPath) as! celulaInfoFIPEmotos2
       
        celula.nomeLabel.text = motosArray[indexPath.row].name.capitalized
        
        return celula
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ModeloFipeVCmotos") as! ModeloFipeVCmotos
        view.id = self.id
        view.modelo = self.motosArray[indexPath.row].id
        self.navigationController!.pushViewController(view, animated: true)
        
    }
    
    func downloadJSON(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/motos/\(self.id!)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    
                    self.motosArray = try JSONDecoder().decode([FIPEmotosInfo2].self, from: data!)
                    
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

