//
//  ConcentrationThemeChooserViewController.swift
//  Set
//
//  Created by Alexander Angelov on 27.02.23.
//

import UIKit

class ConcentrationThemeChooserViewController: UITableViewController {
    
    private let themes = Theme.getAllThemes()
    
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Theme Cell", for: indexPath) as? ThemeChooserTableViewCell else {
            return UITableViewCell()
        }
        
        var configutaion = cell.defaultContentConfiguration()
        configutaion.text = themes[indexPath.row].name
        configutaion.textProperties.font = .systemFont(ofSize: 30)
        configutaion.textProperties.alignment = .center
        cell.contentConfiguration = configutaion
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Concentration", sender: themes[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Concentration" else {
            return }
        
        guard let vc = segue.destination as? ConcentrationViewController else {
            return
        }
        guard let selectedTheme = sender as? Theme else {
            return
        }
        vc.theme = selectedTheme
        print(selectedTheme)
    }
}
