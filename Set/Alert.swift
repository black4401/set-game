//
//  Alert.swift
//  Set
//
//  Created by Alexander Angelov on 9.02.23.
//

import UIKit

struct Alert {
    enum Action {
        case cancel
        case ok(style: UIAlertAction.Style = .default, _ handler: ((UIAlertAction) -> ())? = nil)
        case newGame(style: UIAlertAction.Style = .destructive, _ handler: ((UIAlertAction) -> ())? = nil)
    }
    
    static func createAction(_ action: Action) -> UIAlertAction {
        switch action {
        case .cancel:
            return UIAlertAction(title: "Cancel", style: .cancel)
        case let .ok(style, handler):
            return UIAlertAction(title: "OK", style: style, handler: handler)
        case let .newGame(style, handler):
            return UIAlertAction(title: "New game", style: style, handler: handler)
        }
    }
    
    static func create(title: String? = nil,
                       message: String? = nil,
                       preferredStyle: UIAlertController.Style = .alert,
                       actions: [UIAlertAction] = [createAction(.ok())]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            alert.addAction(action)
        }
        return alert
    }
}
