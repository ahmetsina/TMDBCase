//
//  ViewController.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        API().movie.process(target: .popular) { (error) in
            debugPrint(error?.message ?? "")
        } success: { (result: PaginableResults<[Movie]>) in
            debugPrint(result)
        }
    }
}

