//
//  SettingsViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 7. 1..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

/* 섹션 헤더 설정
class SupplementaryView: UICollectionReusableView {
    var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/

class SettingsCell: UICollectionViewCell {
    var imageView = UIImageView()
    var cellLabel = UILabel()
    var textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SettingsViewController: UIViewController {
    
    // 키보드 처리를 위한 변수
    var keyboardScrollYN = true
    var rectKeyboard: CGRect!
    var activeField: UITextField?
    
    // realm용 변수
    var name = ""
    var age = 0
    var results: Results<TB_SETTINGS>!
    
    let util = Util()
    let uidesign = UIDesign()
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    var dismissTap: UITapGestureRecognizer!
    
    let reuseIdentifier = "reuseIdentifier"
    let headerIdentifier = "headerIdentifier"
    var items: [[String]] = []
    var sections: [String] = []
    var desc: [String] = []
    
    var collectionViewWidth: CGFloat = 0
    var currentSection: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 이벤트 등록
        self.performSelector(#selector(registerKeyboardEvent))
        
        // Data 준비
        setupData()
        
        
        setupUI()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 키보드 dismiss를 위한 collectionView의 터치 감지
        dismissTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(dismissTap)

        //self.collectionView.scrollEnabled = false
    }
    
    //
    // dismiss keyboard를 위해 호출되는 메소드
    // 본 클래스의 viewDidLoad 마지막 부분에 두 줄 추가
    // let dismissTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    // self.view.addGestureRecognizer(dismissTap)
    //
    func handleTap(sender: UITapGestureRecognizer) {
            
        // 제스쳐가 끝났는지 확인 후 코드 진행
        if sender.state == .Ended {
            debugPrint("touchesBegan")
            if let af = activeField {
                af.endEditing(true)
            }
        }
        
    }
    
    func showAlert(section: Int, message: String) {
        self.presentViewController(util.alert("알림", message: message, ok: "확인", cancel: nil), animated: true, completion: {
            let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 2, inSection: section)) as! SettingsCell
            cell.textField.becomeFirstResponder()
            cell.textField.text = ""
        })
    }
    
    func handleNextTap(sender: UITapGestureRecognizer) {
        // 제스쳐가 끝났는지 확인 후 코드 진행
        if sender.state == .Ended {
            if let imageView = sender.view as? UIImageView {
                debugPrint("next")
                if let section = imageView.layer.valueForKey("section")?.integerValue {
                    let activeText = activeField?.text
                    switch section {
                    case 0:
                        if let text = activeText where text != "" {
                            name = text.trim()
                            // 이름이 pk이므로 이미 같은 이름이 있는지 확인한다.
                            let realm = try! Realm()
                            if realm.objects(TB_USER.self).filter("userName == %@", name).count > 0 {
                                showAlert(section, message: "같은 이름이 있습니다.\n다른 이름을 적어주세요.")
                                break
                            }
                            activeField?.endEditing(true)
                            let indexPath = NSIndexPath(forRow: 0, inSection: section + 1)
                            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                        }
                        else {
                            showAlert(section, message: "이름을 적어주세요.")
                        }
                        break
                    case 1:
                        if let text = activeText where text != "" {
                            age = Int(text)!
                            activeField?.endEditing(true)
                            let indexPath = NSIndexPath(forRow: 0, inSection: section + 1)
                            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                        }
                        else {
                            showAlert(section, message: "나이를 적어주세요.")                        }
                        break
                    case 2:
                        // realm에 저장
                        debugPrint("realm에 저장: \(self.name)  \(self.age)")
                        let realm = try! Realm()
                        let users = realm.objects(TB_USER.self).filter("currentYN == true")
                        try! realm.write {

                            // 기존 currentYN = true 인 애들을 false로 변경한다.
                            for user in users {
                                user.currentYN = false
                            }
                            realm.create(TB_USER.self, value: ["userName": self.name, "age": self.age, "regidt": NSDate(), "currentYN": true], update: false)
                            
                        }
                        
                        // icloud에 저장djdddj
                        
                        // 처음으로 화면 이동
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        break
                    default:
                        debugPrint("default")
                        break
                    }
                }
                
            }
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.performSelector(#selector(unregisterKeyboardEvent))
    }
    
    func setupData() {
        let realms = Realms()
        results = realms.retreiveTB_SETTINGS()
        
        var row: [String] = []
        for result in results {
            if sections.count == 0 {
                sections.append(result.section)
                row.append(result.cellType)
            }
            else if sections.last != result.section {
                items.append(row)
                row.removeAll()
                sections.append(result.section)
                row.append(result.cellType)
            }
            else {
                row.append(result.cellType)
            }
            if result.desc != "" {
                desc.append(result.desc)
            }
        }
        items.append(row)
    }
    
    
    func setupUI() {
        
        //  Navi Bar
        self.title = "Math Avengers - Settings"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전 단계로", style: .Plain, target: self, action: #selector(self.leftBarButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음 단계로", style: .Plain, target: self, action: #selector(self.nextButtonPressed))
        
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        // 섹션 사이의 거리를 많이 두어 다른 페이지처럼 느끼게 만들고, cell이 미리 준비되는 것을 막음(?)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, self.view.frame.size.height, 0)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.registerClass(SettingsCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
/* 섹션 헤더 설정
         layout.headerReferenceSize = (UIImage(named: "name")?.size)!
         layout.sectionHeadersPinToVisibleBounds = true
         collectionView.registerClass(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
*/
        
        collectionViewWidth = collectionView.frame.size.width
        
        let viewsDictionary = ["collectionView": collectionView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|",
            options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|",
            options: .AlignAllCenterY, metrics: nil, views: viewsDictionary))
        
    }
    
    // 텍스트필드말고 다른 곳 터치하면 키보드를 가리도록 한다.
    // 고대로부터 전해져 내려오는 얘기로는 UITableView, UICollectionView는 이 메소드가 먹지 않는다고 한다.
    // 물론 toucheBegan을 Cell에 장착하면 이벤트가 발생한다. 하지만 Cell과 Cell사이를 탭하거나 Section Header를 탭할 때는 역시 이벤트가 발생하지 않는다.
    // http://stackoverflow.com/a/5382784/6291225
    // 뭐 하려면 UITableView나 UICollectionView를 subclassing해야 한다나 뭐라나..
    // 하지만 이게 쉬운 것이 아니니 그냥 UIGestureRecognizer를 구현하라고 한다.
    // 그래서 이 소스에서는 이 가이드를 따라 ViewDidLoad에서 UIGestureRecognizer를 구현했다.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        debugPrint("touchesBegan")
        super.touchesBegan(touches, withEvent: event)
        activeField!.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch currentSection! {
        case 0:
            // name
            let length = prospectiveText.characters.count
            if length > 10 {
                // label에 경고 문구를 띄운다.
                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 1, inSection: currentSection!)) as! SettingsCell
                cell.cellLabel.text = "\((cell.cellLabel.text)!)\n(이름은 10글자를 넘으면 안되요~)"
                
            }
            return prospectiveText.characters.count <= 10
        case 1:
            // age
            if !prospectiveText.containsOnlyCharactersIn("0123456789") {
                // label에 경고 문구를 띄운다.
                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 1, inSection: currentSection!)) as! SettingsCell
                cell.cellLabel.text = "\((cell.cellLabel.text)!)\n(나이는 숫자만 적어주세요~)"
                
            }
            return prospectiveText.containsOnlyCharactersIn("0123456789") && prospectiveText.characters.count <= 3
        default:
            return true
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func leftBarButtonPressed() {
        // 한 스크롤 씩 앞으로
    }
    
    func nextButtonPressed() {
        self.presentViewController(util.alert("앗!", message: "이름을 입력하지 않으셨네요~", ok: "네, 입력할게요", cancel: nil), animated: true, completion: nil)
        let indexPath = NSIndexPath(forRow: 0, inSection: 1)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    
}


extension SettingsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SettingsCell
        
        switch items[indexPath.section][indexPath.row] {
        case "label":
            
            cell.cellLabel.text = desc[indexPath.section]
            uidesign.setLabelLayout(cell.cellLabel, fontsize: 40)
            cell.cellLabel.lineBreakMode = .ByWordWrapping
            cell.cellLabel.numberOfLines = 2
            
            let viewsDictionary = ["cellLabel": cell.cellLabel]
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[cellLabel]-|", options: [], metrics: nil, views: viewsDictionary))
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cellLabel]-|", options: [], metrics: nil, views: viewsDictionary))
            
            break
            
        case "textField":
            
            cell.textField.text = ""
            uidesign.setTextFieldLayout(cell.textField, fontsize: 40)
            cell.textField.delegate = self
            
            let viewsDictionary = ["textField": cell.textField]
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textField]-|", options: [], metrics: nil, views: viewsDictionary))
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[textField]-|", options: [], metrics: nil, views: viewsDictionary))
            
            break
            
        case "imageButton":
            
            let image = UIImage(named: "next")
            cell.imageView.image = image
            //cell.imageView.backgroundColor = UIColor.redColor()
            cell.imageView.contentMode = .ScaleAspectFit
            cell.imageView.layer.setValue(indexPath.section, forKey: "section")
            debugPrint("sections[indexPath.section]=\(sections[indexPath.section])")
            
            // 다음 이미지
            cell.imageView.userInteractionEnabled = true
            let nextTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleNextTap(_:)))
            cell.imageView.addGestureRecognizer(nextTap)
            
            //let margin = (collectionViewWidth - image!.size.width) / 2
            let viewsDictionary = ["imageView": cell.imageView]
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]-|", options: [], metrics: nil, views: viewsDictionary))
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[imageView]-|", options: [], metrics: nil, views: viewsDictionary))
            
            break
 
        case "image":
            
            let image = UIImage(named: sections[indexPath.section])
            cell.imageView.image = image
            //cell.imageView.backgroundColor = UIColor.redColor()
            cell.imageView.contentMode = .ScaleAspectFit
            
            let viewsDictionary = ["imageView": cell.imageView]
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]-|", options: [], metrics: nil, views: viewsDictionary))
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[imageView]-|", options: [], metrics: nil, views: viewsDictionary))
            
            break
            
        default:
            debugPrint("default")
            break
        }
        return cell
    }
    
    // 화면에서 셀이 사라지면서 activeField가 가리키는 textField가 사라질 경우
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if self.activeField != nil {
            let cell = cell as! SettingsCell
            if cell.textField == self.activeField {
                self.activeField = nil
            }
        }
    }
    
/*
    // 섹션 헤더 설정
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        var headerView: SupplementaryView?
        if (kind == UICollectionElementKindSectionHeader) {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as? SupplementaryView
            headerView?.imageView.image = UIImage(named: sections[indexPath.section])
            headerView?.imageView.contentMode = .ScaleAspectFit
            //headerView?.imageView.frame = CGRectMake(0, 0, collectionViewWidth, image!.size.height)
            headerView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            
            
            let viewsDictionary = ["imageView": headerView!.imageView]
            headerView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]-|", options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
            headerView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: .AlignAllTop, metrics: nil, views: viewsDictionary))
        }
        return headerView!
    }
 */
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        currentSection = indexPath.section
        let cell = cell as! SettingsCell
        switch items[indexPath.section][indexPath.row] {
        case "label":
            //cell.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
            cell.cellLabel.hidden = false
            cell.imageView.hidden = true
            cell.textField.hidden = true
            break
            
        case "textField":
            //cell.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0, alpha: 0.5)
            cell.textField.hidden = false
            cell.cellLabel.hidden = true
            cell.imageView.hidden = true
            switch indexPath.section {
            case 0:
                cell.textField.keyboardType = .Default
                break
            case 1:
                cell.textField.keyboardType = .NumberPad
                break
            default:
                cell.textField.keyboardType = .Default
                break
            }
            
            keyboardScrollYN = false
            cell.textField.becomeFirstResponder()

            break
            
        case "image", "imageButton":
            //cell.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 0.5)
            cell.imageView.hidden = false
            cell.cellLabel.hidden = true
            cell.textField.hidden = true
            break
            
        default:
            break
            
        }
    }
    
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch items[indexPath.section][indexPath.row] {
        case "label":
            return CGSizeMake(collectionViewWidth, 150)
            
        case "imageButton":
            let image = UIImage(named: "next")
            return image!.size //CGSizeMake(collectionViewWidth, 150) //(image?.size.height)!)
            
        case "image":
            let image = UIImage(named: sections[indexPath.section])
            return CGSizeMake(collectionViewWidth, (image?.size.height)!)
            
        case "textField":
            return CGSizeMake(collectionViewWidth - 100, 100)
            
        default:
            return CGSizeMake(collectionViewWidth, 200)
            
        }
    }
}
