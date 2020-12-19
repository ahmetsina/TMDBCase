//
//  BaseViewController.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController<U>: UIViewController, BaseViewControllerViewModel, NVActivityIndicatorViewable {
    
    typealias T = U
    var viewModel : T
    
    convenience init() {
        fatalError("\(#function) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    
    required init(viewModel: U) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
