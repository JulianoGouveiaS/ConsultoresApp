//
//  Oficina.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 19/02/2019.
//  Copyright © 2019 Juliano Gouveia. All rights reserved.
//

import Foundation
import UIKit

class Oficina {
    var id: Int?
    var uf: String?
    var nm_fantasia: String?
    var cidade: String?
    var bairro: String?
    var telefone: String?
    
    
    init(dictionary: [String:Any]) {
        
        self.id = dictionary["id"] as! Int?
        self.uf = dictionary["uf"] as! String?
        self.nm_fantasia = dictionary["nm_fantasia"] as! String?
        self.cidade = dictionary["cidade"] as! String?
        self.bairro = dictionary["bairro"] as! String?
        self.telefone = dictionary["telefone"] as! String?
        
    }
}
