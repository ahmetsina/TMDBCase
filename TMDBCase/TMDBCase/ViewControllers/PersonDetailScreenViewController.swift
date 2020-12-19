//
//  PersonDetailScreenViewController.swift
//  TMDBCase
//
//  Created by AppLogist on 19.12.2020.
//

import UIKit

final class PersonDetailScreenViewController: BaseViewController<PersonDetailScreenViewModel> {
    
    private var previousStatusBarHidden = false
    private let scrollView = UIScrollView()
    private let imageContainer = UIView()
    private let imageView = UIImageView()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        return label
    }()
    private let topInfoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let summaryLabel = UILabel()
    private let stackView = UIStackView()
    
    private var collectionView: UICollectionView?
    private var cellID = "MovieCollectionCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPersonDetail { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                Alert.shared.showAlert(for: error, on: self)
                return
            }
            if let movie = self.viewModel.person {
                DispatchQueue.main.async {
                    self.updateUI(with: movie)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configInsets()
    }
    
    
    // MARK: - Setup UI
    private func setupUI(){
        initConstraints()
        scrollView.showsVerticalScrollIndicator = false
        stackView.axis = .vertical
        stackView.spacing = 10
        imageView.contentMode = .scaleAspectFit
        summaryLabel.numberOfLines = 0
    }
    
    private func updateUI(with person: Person){
        if let imageURL = person.profileURL {
            imageView.kf.setImage(with: imageURL)
        }
        titleLabel.text = person.name
        summaryLabel.text = person.biography
        
        if let birthday = person.birthday {
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .medium
            let birthdayString = formatter1.string(from: birthday)
            topInfoLabel.text = "\(birthdayString)" // Formatlanabilir
        }
        if let placeOfBirth = person.placeOfBirth {
            topInfoLabel.text = "\(topInfoLabel.text ?? ""), \(placeOfBirth)"
        }
        
        if let cast = viewModel.person?.credits?.cast,
           !cast.isEmpty,
           collectionView == nil {
            addCastsSection(cast: cast)
        }
    }
    
    private func initConstraints(){
        view.addSubview(scrollView)
        scrollView.addSubview(imageContainer)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        imageContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(imageContainer.snp.width).multipliedBy(0.5)
        }
        
        
        scrollView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.left.right.equalTo(imageContainer)
            //** Note the priorities
            make.top.equalTo(view).priority(.high)
            //** We add a height constraint too
            make.height.greaterThanOrEqualTo(imageContainer.snp.height).priority(.required)
            //** And keep the bottom constraint
            make.bottom.equalTo(imageContainer.snp.bottom)
        }
        
        
        scrollView.addSubview(stackView)
        //Pin the backing view below the image view and to the
        // bottom of the scroll view
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.right.equalTo(view).inset(16)
            make.bottom.equalTo(scrollView).inset(16)
        }
        stackView.addArrangedSubview(topInfoLabel)
        stackView.addArrangedSubview(titleLabel)
        addSeperator()
        stackView.addArrangedSubview(summaryLabel)
    }
    
    private func addCastsSection(cast: [Movie]){
        setupCastTitleLabel()
        addSeperator()
        setupCastCollectionView()
    }
    
    private func setupCastTitleLabel(){
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = "Credits"
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func addSeperator(){
        let seperatorView = UIView(frame: .zero)
        seperatorView.backgroundColor = .init(white: 0.5, alpha: 0.5)
        stackView.addArrangedSubview(seperatorView)
        seperatorView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
        }
    }
    
    private func setupCastCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionViewHeight: CGFloat = 200
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 25
        layout.itemSize = CGSize(width: 130, height: collectionViewHeight - 20)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(OverviewCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = .clear
        collectionView?.clipsToBounds = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.reloadData()
        if let collectionView = collectionView {
            stackView.addArrangedSubview(collectionView)
        }
        collectionView?.snp.makeConstraints({ (make) in
            make.height.equalTo(collectionViewHeight)
        })
    }
    
    private func configInsets(){
        if #available(iOS 11.0, *) {
            // We want the scroll indicators to use all safe area insets
            scrollView.scrollIndicatorInsets = view.safeAreaInsets
            // But we want the actual content inset to just respect the bottom safe inset
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension PersonDetailScreenViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //** We keep the previous status bar hidden state so that
        // we’re not triggering an implicit animation block for every frame
        // in which the scroll view scrolls
        if previousStatusBarHidden != shouldHideStatusBar {
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
    
    //MARK: — Status Bar Appearance
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        //** We use the slide animation because it works well with scrolling
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    private var shouldHideStatusBar: Bool {
        //** Here’s where we calculate if our text container
        // is going to hit the top safe area
        let frame = stackView.convert(stackView.bounds, to: nil)
        if #available(iOS 11.0, *) {
            return frame.minY < view.safeAreaInsets.top
        }
        return false
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension PersonDetailScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.castCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                            for: indexPath) as? OverviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let cast = viewModel.cast(at: indexPath.row) else { return cell }
        let viewModel = OverviewCollectionCellViewModel(imageURL: cast.posterURL,
                                                        title: cast.title,
                                                        subTitle: cast.genresStringWithComma)
        
        cell.updateUI(with: viewModel)
        cell.shadowDecorate()
        return cell
    }
}

extension PersonDetailScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cast = viewModel.cast(at: indexPath.row) else { return }
        let movieDetailVC = MovieDetailScreenViewController(viewModel: MovieDetailScreenViewModel(movieID: cast.id))
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
