//
//  loadingView.swift
//  Mozzi
//
//  Created by 지희의 MAC on 2023/04/18.
//

import UIKit
import SnapKit

class LoadingView: BaseView {
    
    private let backgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.makeCornerRound(radius: 20)
        view.alpha = 0.5
        return view
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "영수증 읽는 중..."
        label.font = .pretendardThin(ofSize: 14)
        return label
    }()
    
    private let loadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.loadingHamImage
        return imageView
    }()
    
    private lazy var loadingStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangeSubViews(loadingImageView,loadingLabel)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    func viewIsHideen() {
        self.backgroundView.isHidden = true
    }
    
    func setViewHierarchy() {
        self.addSubviews(backgroundView,loadingStackView)
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints{
            $0.width.equalTo(270)
            $0.height.equalTo(300)
            $0.edges.equalToSuperview()
        }
        
        loadingImageView.snp.makeConstraints{
            $0.height.width.equalTo(200)
        }
        
        loadingStackView.snp.makeConstraints{
            $0.center.equalTo(backgroundView.snp.center)
        }
    }
    
}
