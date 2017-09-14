//
//  UIViewController+CoreData.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 13/09/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    //var computada
    var appDelegate: AppDelegate {
        //qlqr viu controlet do meu codigo tera acesso a facil ao AppDelegate
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //classe que representa o contexto de um CoreData (regiao em memoria q esta manipulando naquele momento)
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
