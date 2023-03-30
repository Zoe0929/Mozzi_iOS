//
//  HorizontalScrollView.swift
//  Mozzi_dev
//
//  Created by 지희의 MAC on 2023/03/14.
//


import Foundation
import SnapKit


class BaseScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }

    func configure() {}
    func bind() {}
}


class HorizontalScrollView: BaseScrollView {
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 30.0
        return view
    }()
    
    var dataSource: [SomeDataModel]? {
         didSet { bind() }
     }
    
    override func configure() {
            super.configure()

            showsHorizontalScrollIndicator = false
            bounces = false

            addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview() /// 이 값이 없으면 scroll 안되는 것 주의
                make.height.equalToSuperview()
            }
        }
    override func bind() {
        super.bind()

        dataSource?.forEach { data in
            let button = UIButton()
            button.layer.cornerRadius = 30
            button.setTitleColor(.darkGray, for: .normal)
            button.setTitle(data.name, for: .normal)
            button.backgroundColor = UIColor(named: "Dark Color")

            stackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo(240)
                make.height.equalTo(80)
               // make.bottom.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(15)
            }
        }
    }
}