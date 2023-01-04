# memberList

![Simulator Screen Recording - iPhone 13 Pro Max - 2023-01-04 at 22 38 16](https://user-images.githubusercontent.com/42196410/210567263-ef2c9da4-b6a9-45fd-b775-4c141f5959fb.gif)


## 🧩 개요

회원 리스트를 수정, 작성하기 

## 🤔 배운 내용

### ✔️ MVC 디자인 패턴

### ✔️  Retain Cycle 방지

1) 강한 참조가 일어나는것을 막기 위해, 커스텀 델리게이트 프로퍼티에 `weak` 키워드를 사용하였습니다.
2) `weak` 키워드는 클래스 인스턴스에서 사용될수 있기에 커스텀 델리게이트는 `AnyObject`를 상속받았습니다.

### ✔️ View에서의 상태 관리 

데이터(Member 구조체)의 변화를 감시하는 속성감시자 `didSet`으로 상태를 관리 하였습니다.

### ✔️ 커스텀 델리게이트 패턴

`viewController`가 `detailViewController`의 대리자 역할을 하여

`detailViewController`에서 delegate(커스텀 델리게이트 프로퍼티)의 메소드가 실행되면 `viewController`에서는 데이터(Member 구조체)가 업데이트 된것을 알 수 있습니다.

### ✔️ NotificationCenter for KeyboardAvoidngView

`UITextField`를 탭할때 키보드가 올라오고 내려가는 애니메이션 처리를 하였습니다

### ✔️ 제스쳐 및 피커뷰 

UITapGestureRecognizer로 이미지가 탭된것을 인식하고 PHPicker로 피커를 띄우고 사진을 선택하는 작업을 처리 하였습니다







