//
//  WideCollectionViewCell.swift
//  TMDBCase
//
//  Created by AppLogist on 18.12.2020.
//

import UIKit
import SnapKit

final class WideCollectionViewCell: UICollectionViewCell {
    
    private let stackView = UIStackView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 9)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        initConstraints()
    }
    
    private func initConstraints(){
        stackView.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview().inset(16)
            make.bottom.top.equalToSuperview().inset(4)
        }
    }
    private func addViews(){
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
    }
    
    func updateUI(with viewModel: WideCollectionCellViewModel) {
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
