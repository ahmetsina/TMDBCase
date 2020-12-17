//
//  ViewController.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import UIKit

final class MainScreenViewController: BaseViewController<MainScreenViewModel> {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getConfig { (errorMessage) in
            if let errorMessage = errorMessage {
                debugPrint(errorMessage)
                return
            }
            debugPrint("Success")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSearchController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    private func setupUI(){
        setupNavigationBar()
        
    }
    
    private func updateSearchController(){
        searchController.searchBar.placeholder = "Search.."
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }else {
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
    private func setupNavigationBar(){
        title = "Popular Movies"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
}


// MARK: - UISearchResultsUpdating

extension MainScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty,
              searchController.isActive  else {
            //viewModel.update(filteredList: [])
            /// - TODO: Reload Data
            return
        }
        
        //filterContentForSearchText(searchText)
        //updateTableViewData()
        debugPrint(searchText)
    }
}
