//
//  OCRViewController.swift
//  Mozzi
//
//  Created by 지희의 MAC on 2023/04/18.
//

import UIKit
import SnapKit
import Alamofire


class OCRViewController: UIViewController {
    
    private var image: UIImage?
    
    private var data: UploadRes?
  
    private let loadingView = LoadingView()
    private let importView = OCRImportView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        // 옵져버를 등록
        // 옵저버 대상 self
        // 옵져버 감지시 실행 함수
        // 옵져버가 감지할 것
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
     

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    func updateImage(_ image: UIImage){
        
        importView.ocrImageView.image = image
        
        // 여기부터 서버 이미지 전송 코드
        let imageData = image.jpegData(compressionQuality: 1)!
        let formData = MultipartFormData()
        formData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, to: "https://port-0-server-mozzi-e9btb72blgv08nbr.sel3.cloudtype.app/upload").responseDecodable(of: UploadRes.self) { response in
            switch response.result {
            case .success(let uploadRes):
                self.image = image
                self.data = UploadRes(name: uploadRes.name, price: uploadRes.price, date: uploadRes.date, address: uploadRes.address, itemName: uploadRes.itemName, itemCount: uploadRes.itemCount, itemPrice: uploadRes.itemPrice)
                self.loadingView.isHidden = true
                print(uploadRes.itemName)
                self.setInfomation()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // ______________여기까지 _______________________________
    }
    
    private func setUI(){
        view.backgroundColor = .white
        view.addSubviews(loadingView, importView)
        view.bringSubviewToFront(loadingView)
        navigationController?.navigationBar.tintColor = .mozziDark
        navigationItem.backButtonTitle = "이전"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(nextButtonDidTap))
        setLayout()
    }
    
    private func setLayout(){
        
        loadingView.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        importView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setInfomation(){
        guard let data else { return }
        importView.setInformation(data.name, data.address, data.itemName, data.itemCount, data.itemPrice, data.price, data.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func nextButtonDidTap() {
        let nextVC = WritingPageViewController()
        print("클릭됨")
        guard let image else { return }
        guard let data else { return }
        nextVC.updateInfomation(image: image, item: importView.itemtextField.text! , place: importView.placetextField.text!, address: importView.addresstextField.text! , price: importView.pricetextField.text!, date: importView.dateTextField.text!)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }


}
