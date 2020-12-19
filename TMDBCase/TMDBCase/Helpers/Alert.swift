//
//  Alert.swift
//  TMDBCase
//
//  Created by AppLogist on 19.12.2020.
//

import UIKit

final class Alert {
    
    static let shared = Alert()
    private var alert = UIAlertController()
    
    func showAlert(for error: PresentableError, on vc: UIViewController) {
        let alertContr = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Done", style: .default, handler: nil)
        alertContr.addAction(action1)
        vc.present(alertContr, animated: true, completion: nil)
    }
}
