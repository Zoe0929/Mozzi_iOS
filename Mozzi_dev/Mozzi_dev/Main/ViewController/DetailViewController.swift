//
//  DetailViewController.swift
//  Mozzi_dev
//
//  Created by 지희의 MAC on 2023/05/16.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    let detailView = DetailView()
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
