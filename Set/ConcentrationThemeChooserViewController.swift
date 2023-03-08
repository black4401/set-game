//
//  ConcentrationThemeChooserViewController.swift
//  Set
//
//  Created by Alexander Angelov on 27.02.23.
//

import UIKit

private var concentrationSegue = "ConcentrationSegue"
private var themeCellIdentifier = "ThemeCellIdentifier"

class ConcentrationThemeChooserViewController: UITableViewController {
    
    private let themes = Theme.getAllThemes()
    private var concentrationVC: ConcentrationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: themeCellIdentifier, for: indexPath)
        
        var configutaion = cell.defaultContentConfiguration()
        configutaion.text = themes[indexPath.row].name
        configutaion.textProperties.font = .systemFont(ofSize: 30)
        configutaion.textProperties.alignment = .center
        cell.contentConfiguration = configutaion
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTheme = themes[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if let cvc = splitViewController?.viewControllers.last as? ConcentrationViewController {
            cvc.theme = selectedTheme
        } else if let cvc = concentrationVC {
            cvc.theme = selectedTheme
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: concentrationSegue, sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == concentrationSegue,
           let vc = segue.destination as? ConcentrationViewController,
           let selectedCell = sender as? UITableViewCell {
            let theme = themes[tableView.indexPath(for: selectedCell)?.row ?? 0]
            vc.theme = theme
            concentrationVC = vc
        }
    }
}
