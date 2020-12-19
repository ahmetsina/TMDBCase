//
//  ViewController.swift
//  TMDBCase
//
//  Created by AppLogist on 16.12.2020.
//

import UIKit
import EmptyDataSet

final class MainScreenViewController: BaseViewController<MainScreenViewModel> {
    
    private var collectionView: UICollectionView!
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
        viewModel.reloadHandler = { [weak self] in
            guard let self = self else { return }
            self.updateNotFoundMessage()
            self.collectionView.reloadData()
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
                self.startAnimating()
                self.viewModel.getPopularMovies { [weak self] (errorMessage) in
                    guard let self = self else { return }
                    self.stopAnimating()
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
        collectionView.register(OverviewCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "emptyHeader")
        updateNotFoundMessage()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        if let collectionView = collectionView {
            view.addSubview(collectionView)
        }
    }

    func updateNotFoundMessage() {
        if viewModel.isSearchActive {
            collectionView.emptyDataSetView({ [weak self] (view) in
                guard let self = self else { return }
                view.titleLabelString(NSAttributedString(string: "No Movies"))
                    .detailLabelString(NSAttributedString(string: "No Data Found with \(self.searchController.searchBar.text ?? "")"))
                    .shouldDisplay(true)
                    .shouldFadeIn(true)
            })
            return
        }
        collectionView.emptyDataSetView({ [weak self] (view) in
            guard let self = self else { return }
            view.titleLabelString(NSAttributedString(string: "No Movies"))
                .detailLabelString(NSAttributedString(string: "No Data Found"))
                .buttonTitle(NSAttributedString(string: "Tap to Refresh"), for: .normal)
                .shouldDisplay(true)
                .shouldFadeIn(true)
                .isTouchAllowed(true)
                .isScrollAllowed(true)
                .didTapContentView {
                    self.callViewModelActions()
                }
        })
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
            viewModel.searchQuery = ""
            return
        }
        viewModel.searchQuery = searchText
    }
}


// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension MainScreenViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsinSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                            for: indexPath) as? OverviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = viewModel.movie(at: indexPath)

        let viewModel = OverviewCollectionCellViewModel(imageURL: movie.posterURL,
                                                     title: movie.title,
                                                     subTitle: movie.genresStringWithComma ?? "")
    
        cell.updateUI(with: viewModel)
        cell.shadowDecorate()
        return cell
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movie(at: indexPath)
        let movieDetailVC = MovieDetailScreenViewController(viewModel: MovieDetailScreenViewModel(movieID: movie.id))
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind != UICollectionView.elementKindSectionHeader || searchController.searchBar.text == "" {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: "emptyHeader",
                                                                                   for: indexPath)
            headerView.frame.size.height = 0
            headerView.frame.size.width = 0
            return headerView
        }
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                  withReuseIdentifier: "header",
                                                                                  for: indexPath) as? SectionHeader else {
            return UICollectionReusableView()
        }
        sectionHeader.label.text = viewModel.searchResults[indexPath.section].title
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if !viewModel.isSearchActive {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
}
