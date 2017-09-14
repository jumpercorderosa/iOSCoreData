//
//  MoviesTableViewController.swift
//  MoviesLib
//
//  Created by Eric on 24/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData

//tela de listagem
class MoviesTableViewController: UITableViewController {

    //Criando nossa label que será a backgroundView da tabela
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    
    //essa clase faz a requisicao e devolve a lista de tudo oq ela pesquisou
    var fetchedResultController: NSFetchedResultsController<Movie>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 106  //Definindo um tamanho base para o cálculo do tamanho final
        tableView.rowHeight = UITableViewAutomaticDimension //Definindo que o tamanho será dinâmico

        //Definindo os valores das propriedades da lavel
        label.text = "Sem filmes"
        label.textAlignment = .center
        label.textColor = .white
        
        loadMovies()
    }
    
    
    func loadMovies() {

        //Clase que vai fazer uma requisicao do tipo movie
        //objeto que contem a requisao
        let fetchRequest:NSFetchRequest<Movie> = Movie.fetchRequest()
        
        //ordena a lista de filme por algum campo
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        //alimento uma propriedado do fetched
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //cara que executa a requisao e digo de onde ele vai buscar as informacoes
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)


        
        //tenho que falar qual eh o delegate
        fetchedResultController.delegate = self
        
        //requisicao eh feita aqui
        //! assumo que essa bagaca nao vai dar erro
        try! fetchedResultController.performFetch()
        
    }
    
    //prepared for segue
    //mudando de tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*
        if let vc = segue.destination as? MovieViewController, let indexPath = tableView.indexPathsForSelectedRows{
            vc.movie = fetchedResultController.object(at: indexPath)
        }
         */
        
        if let vc = segue.destination as? MovieViewController{
            vc.movie = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
        }
    }
    

    // MARK: - Table view data source

    //Método que define a quantidade de seções de uma tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Método que define a quantidade de células para cada seção de uma tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        //Caso nosso dataSource seja 0, teremos a label aparecendo.
        //tableView.backgroundView = dataSource.count == 0 ? label : nil
        //return dataSource.count //Retornamos o total de itens no nosso dataSource
        
        if let count = fetchedResultController.fetchedObjects?.count {
            return count
        } else {
            return 0
        }
    }
    
    //Método que define a célula que será apresentada em cada linha
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Definimos o identifier que usamos em nossa célula (movieCell)
        //Fazemos o cast para MovieTableViewCell para que possamos acessar os
        //IBOutlets criados
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        //ofetech tem um metodo especifico para recuperar
        //uma maneira mais imediata para recupar
        let movie = fetchedResultController.object(at: indexPath)
        cell.lbTitle.text = movie.title
        cell.lbSummary.text = movie.summary
        cell.lbRating.text = "\(movie.rating)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //vou recuperar o filme q eu desejo excluir
            let movie = fetchedResultController.object(at: indexPath)
            context.delete(movie)
            
            //agora persisto o context
            try! context.save()
            
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//delegate
extension MoviesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //sempre que houve alteracao no conteudo, recarrega a tela
        tableView.reloadData()
    }
}