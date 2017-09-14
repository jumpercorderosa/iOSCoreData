//
//  MovieRegisterViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 13/09/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

//classe que vou utilizar para cadastrar o filme
class MovieRegisterViewController: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var ivPosters: UIImageView!
    @IBOutlet weak var btAddUpdate: UIButton!
    
    //ja pegou as entidades criadas no CoreData
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movie != nil {
            tfTitle.text = movie.title
            tfRating.text = "\(movie.rating)"
            tfDuration.text = movie.duration
            tvSummary.text = movie.summary
            btAddUpdate.setTitle("Atualizar", for: .normal)
        }
    }
    
    @IBAction func addUpdateMovie(_ sender: UIButton) {
        if movie == nil {
            //instanciando a classe que representa uma entidade
            movie = Movie(context: context)
        }
        
        //populando a base com os campos da tela
        movie.title = tfTitle.text
        movie.rating = Double(tfRating.text!)!
        movie.summary = tvSummary.text
        movie.duration = tfDuration.text
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        close(nil)
    }

    @IBAction func close(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
}
