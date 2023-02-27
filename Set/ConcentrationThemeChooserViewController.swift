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
        for theme in themes {
            print( theme)
        }
        // Do any additional setup after loading the view.
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
        
        var theme = themes[indexPath.row]
        cell.nameLabel.text = theme.name
        
        
        return cell
    }

}
