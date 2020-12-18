//
//  ViewController.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import UIKit
import SkeletonView

final class MainScreenViewController: BaseViewController<MainScreenViewModel> {
    
    private var collectionView: UICollectionView?
    private var cellID = "MovieCollectionCellID"
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - VC Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSearchController()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    fileprivate func callViewModelActions() {
        viewModel.moviesReloadHandler = { [weak self] in
            guard let self = self else { return }
            self.collectionView?.reloadData()
        }
        viewModel.getConfig { [weak self] (errorMessage) in
            guard let self = self else { return }
            if let errorMessage = errorMessage {
                debugPrint(errorMessage)
                return
            }
            self.viewModel.getGenres { [weak self] (errorMessage) in
                guard let self = self else { return }
                if let errorMessage = errorMessage {
                    debugPrint(errorMessage)
                    return
                }
                self.viewModel.getPopularMovies { (errorMessage) in
                    if let errorMessage = errorMessage {
                        debugPrint(errorMessage)
                        return
                    }
                }
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI(){
        setupNavigationBar()
        setupCollectionView()
        callViewModelActions()
    }
    
    private func setupNavigationBar(){
        title = "Popular Movies"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func setupCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: ((self.view.frame.width - 60) / 2), height: 250)
        layout.scrollDirection = .vertical
                
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.register(OverviewCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = .clear
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.reloadData()
        if let collectionView = collectionView {
            view.addSubview(collectionView)
        }
    }

    
    // MARK: - Update UI
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


// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension MainScreenViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        cellID
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movieCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                            for: indexPath) as? OverviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = viewModel.movie(at: indexPath.row)
        let viewModel = OverviewCollectionCellViewModel(imageURL: movie.posterURL,
                                                     title: movie.title,
                                                     subTitle: movie.genresStringWithComma ?? "")
    
        cell.updateUI(with: viewModel)
        cell.shadowDecorate()
        cell.hideAnimation()
        return cell
    }
}

extension MainScreenViewController: SkeletonCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movie(at: indexPath.row)
        let movieDetailVC = MovieDetailScreenViewController(viewModel: MovieDetailScreenViewModel(movieID: movie.id))
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
