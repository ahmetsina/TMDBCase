//
//  ViewController.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import UIKit

final class MainScreenViewController: BaseViewController<MainScreenViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        title = "Popular Movies"
    }
}

