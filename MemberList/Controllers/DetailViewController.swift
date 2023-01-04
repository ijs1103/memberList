//
//  DetailViewController.swift
//  MemberList
//
//  Created by Allen H on 2022/02/04.
//

import UIKit
import PhotosUI

final class DetailViewController: UIViewController {
    
    // MVC패턴을 위한 따로만든 뷰
    private let detailView = DetailView()
    
    // 전화면에서 Member데이터를 전달 받기 위한 변수
    var member: Member?
    
    // 대리자설정을 위한 변수(델리게이트)
    // 약한 순환 참조를 위해 weak 키워드를 사용함.
    // 또한, weak 키워드가 클래스에서만 사용이 가능하기 때문에 MemberDelegate는 AnyObject를 상속해야함.
    weak var delegate: MemberDelegate?
    
    // MVC패턴을 위해서 view를 갈아끼움
//    1. loadView()는 뷰 컨트롤러에서 루트 뷰를 그리는 메서드이고, viewDidLoad() 보다도 더 먼저 실행된다.
//
//    2. loadView()에서는 뷰를 직접! 초기화 해주어야 한다. (super.loadView 사용금지)
//    3. loadView()는 코드로 직접 뷰 컨트롤러를 그리는 경우에만 사용해야 한다.
    override func loadView() {
        view = detailView
    }
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupButtonAction()
        setupTapGestures()
    }
    
    // 멤버를 뷰에 전달⭐️ (뷰에서 알아서 화면 셋팅)
    private func setupData() {
        detailView.member = member
    }
    
    // 뷰에 있는 버튼의 타겟 설정
    func setupButtonAction() {
        detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - 이미지뷰가 눌렸을때의 동작 설정
    
    // 제스쳐 설정 (이미지뷰가 눌리면, 실행)
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTapped))
        detailView.mainImageView.addGestureRecognizer(tapGesture)
        // 이미지의 터치 이벤트가 가능하게 설정
        detailView.mainImageView.isUserInteractionEnabled = true
    }

    @objc func handleImageTapped() {
        print("이미지뷰 터치")
        // 기본설정 셋팅
        var configuration = PHPickerConfiguration()
        // 앨범에서 이미지 선택할수 있는 개수 , 0개면 무제한
        configuration.selectionLimit = 0
        // 선택하는 필터 (이미지, 비디오만 선택)
        configuration.filter = .any(of: [.images, .videos])
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
    }
   
    
    //MARK: - SAVE버튼 또는 UPDATE버튼이 눌렸을때의 동작
    
    @objc func saveButtonTapped() {
        print("버튼 눌림")
        
        // [1] 멤버가 없다면 (새로운 멤버를 추가하는 화면)
        if member == nil {
            // 입력이 안되어 있다면.. (일반적으로) 빈문자열로 저장
            let name = detailView.nameTextField.text ?? ""
            let age = Int(detailView.ageTextField.text ?? "")
            let phoneNumber = detailView.phoneNumberTextField.text ?? ""
            let address = detailView.addressTextField.text ?? ""
            
            // 새로운 멤버 (구조체) 생성
            var newMember =
            Member(name: name, age: age, phone: phoneNumber, address: address)
            newMember.memberImage = detailView.mainImageView.image
            
//            // 1) 델리게이트 방식이 아닌 구현⭐️
//            let index = navigationController!.viewControllers.count - 2
//            // 전 화면에 접근하기 위함
//            let vc = navigationController?.viewControllers[index] as! ViewController
//            // 전 화면의 모델에 접근해서 멤버를 추가
//            vc.memberListManager.makeNewMember(newMember)
            
            // 2) 델리게이트 방식으로 구현⭐️
            delegate?.addNewMember(newMember)
            
            
        // [2] 멤버가 있다면 (멤버의 내용을 업데이트 하기 위한 설정)
        } else {
            // 이미지뷰에 있는 것을 그대로 다시 멤버에 저장
            member!.memberImage = detailView.mainImageView.image
            
            let memberId = Int(detailView.memberIdTextField.text!) ?? 0
            member!.name = detailView.nameTextField.text ?? ""
            member!.age = Int(detailView.ageTextField.text ?? "") ?? 0
            member!.phone = detailView.phoneNumberTextField.text ?? ""
            member!.address = detailView.addressTextField.text ?? ""
            
            // 뷰에도 바뀐 멤버를 전달 (뷰컨트롤러 ==> 뷰)
            detailView.member = member
            
            // 1) 델리게이트 방식이 아닌 구현⭐️
            // viewControllers => 모든 viewController
//            let index = navigationController!.viewControllers.count - 2
//            // 전 화면(viewControllers[0])에 접근하기 위함
//            let vc = navigationController?.viewControllers[index] as! ViewController
//            // navigationController가 ViewController의 정보를 가지고 있기 때문에
//            // 전 화면의 모델에 접근해서 멤버를 업데이트
//            vc.memberListManager.updateMemberInfo(index: memberId, member!)
            
            // 델리게이트 방식으로 구현⭐️
            delegate?.update(index: memberId, member!)
        }
        
        // (일처리를 다한 후에) 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("디테일 뷰컨트롤러 해제")
    }
}

//MARK: - 피커뷰 델리게이트 설정

extension DetailViewController: PHPickerViewControllerDelegate {
    
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커뷰 창끄기
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    // 이미지뷰에 선택한 이미지를 표시
                    self.detailView.mainImageView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}

