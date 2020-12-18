//
//  MovieCollectionViewCell.swift
//  TMDBCase
//
//  Created by AppLogist on 18.12.2020.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class OverviewCollectionViewCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 1, alpha: 0.6)
        label.font = UIFont.boldSystemFont(ofSize: 9)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        initConstraints()
    }
    
    private func initConstraints(){
        imageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.trailing.lessThanOrEqualToSuperview().inset(10)
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(self.snp.bottom).inset(5)
        }
    }
    private func addViews(){
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        showAnimation()
    }
    
    func showAnimation() {
        [imageView, titleLabel, subTitleLabel].forEach({
                                                        $0.isSkeletonable = true
                                                        $0.showAnimatedSkeleton() })
    }
    
    func hideAnimation() {
        [imageView, titleLabel, subTitleLabel].forEach({ $0.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(3000)) })
    }
    
    func updateUI(with viewModel: OverviewCollectionCellViewModel) {
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        if let imageURL = viewModel.imageURL {
            imageView.kf.setImage(with: imageURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        imageView.image = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
