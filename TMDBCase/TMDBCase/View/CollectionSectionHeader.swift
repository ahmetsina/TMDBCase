//
//  CollectionSectionHeader.swift
//  TMDBCase
//
//  Created by AppLogist on 19.12.2020.
//

import UIKit
import SnapKit

class SectionHeader: UICollectionReusableView {
     var label: UILabel = {
         let label: UILabel = UILabel()
         label.textColor = .darkGray
         label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
         label.sizeToFit()
         return label
     }()

     override init(frame: CGRect) {
         super.init(frame: frame)
         addSubview(label)
         label.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
         }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
