//
//  MemoListViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/21.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit
import SVProgressHUD
import CCBottomRefreshControl
import PullToRefreshKit

class MemoListViewController: UIViewController
, UICollectionViewDelegate
, UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout
, UISearchBarDelegate
, UISearchDisplayDelegate
, MemoCollectionViewCellDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBtnView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    
    private var gPopupMaskBG: UIView?
    private var delegateObj: AppDelegate?
    private var loadingFlag: Bool = false
    private var updateFlag: Bool = false
    private var editable: Bool = false
    
    private var groupedMemoList: NSMutableArray!
    private var groupKeyList: NSMutableArray!
    private var deleteMemoList: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()

//        SVProgressHUD.show()
        self.navigationController?.isNavigationBarHidden = true

        searchBar.delegate = self
        self.collectionView.register(UINib(nibName: "MemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MemoCollectionViewCell")
        self.collectionView.register(UINib(nibName: "MemoHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MemoHeaderCollectionReusableView");
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.editBtn.layer.cornerRadius = 5
        self.addBtnView.layer.cornerRadius = 25
        self.addBtnView.layer.masksToBounds = false
        self.addBtnView.layer.shadowRadius = 4
        self.addBtnView.layer.shadowOpacity = 1
        self.addBtnView.layer.shadowColor = UIColor.gray.cgColor
        self.addBtnView.layer.shadowOffset = CGSize(width: 0 , height:2)

        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: Config.SCREEN_WIDTH/2-15, height: Config.SCREEN_WIDTH/2-15)
        layout.headerReferenceSize = CGSize(width:0, height:50)
        layout.sectionHeadersPinToVisibleBounds = true

//        let bottomRefreshController = UIRefreshControl()
//        bottomRefreshController.triggerVerticalOffset = 20
//        bottomRefreshController.addTarget(self, action: #selector(refreshBottom), for: .valueChanged)
//
//        collectionView.bottomRefreshControl = bottomRefreshController
        
        deleteMemoList = NSMutableArray()
        groupedMemoList = NSMutableArray()
        groupKeyList = NSMutableArray()

        addDoneButtonOnKeyboard()

    }
    
    @objc func refreshBottom() {
        if !updateFlag {
//            updateData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

        self.loadMemoData(key: self.searchBar.searchTextField.text!)
    }
    
    func loadMemoData(key: String) {
        var memoData:[Memo] = []
        memoData = DatabaseManager.getSearchDatas(keyword: key)
        groupedMemoList.removeAllObjects()
        groupKeyList.removeAllObjects()
        
        for i in 0 ..< memoData.count {
            if !groupKeyList.contains(memoData[i].company!) {
                groupKeyList.add(memoData[i].company!)
            }else {
                continue
            }
        }
        for i in 0 ..< groupKeyList.count {
            var memoItems:[Memo] = []
            for j in 0 ..< memoData.count {
                if (groupKeyList.object(at: i) as! String) == memoData[j].company {
                    memoItems.append(memoData[j])
                }
            }
            groupedMemoList.add(memoItems)
        }
        self.collectionView.reloadData()
    }

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.searchBar.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        self.searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        self.loadMemoData(key: searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let memoDatas = self.groupedMemoList.object(at: section) as! [Memo]
        return memoDatas.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MemoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoCollectionViewCell", for: indexPath) as! MemoCollectionViewCell;
        let memoDatas = self.groupedMemoList.object(at: indexPath.section) as! [Memo]
        cell.initData(memoData: memoDatas[indexPath.row], section: indexPath.section, ind: indexPath.row, editable: self.editable)
        cell.delegate = self
        
        return cell;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groupKeyList.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !editable {
            let vc = MemoViewController()
            vc.editType = "edit"
            let memoDatas = self.groupedMemoList.object(at: indexPath.section) as! [Memo]
            vc.memo = memoDatas[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MemoHeaderCollectionReusableView", for: indexPath) as! MemoHeaderCollectionReusableView

            reusableview.titleLb.text = (self.groupKeyList[indexPath.section] as! String)
            return reusableview
        default:  fatalError("Unexpected element kind")
        }
    }
    
    func checkBtnClicked(section: Int, ind: Int, selected: Bool) {
        let memoDatas = self.groupedMemoList.object(at: section) as! [Memo]
        if selected {
            deleteMemoList.add(memoDatas[ind])
        }else {
            deleteMemoList.remove(memoDatas[ind])
        }
    }
    
    func deleteSelectedDatas() {
        let alert: UIAlertController = UIAlertController(title: "注意", message: "削除してもよろしいですか？\n（１度削除したデータは復元できません。）", preferredStyle:  UIAlertController.Style.actionSheet)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            for i in 0 ..< self.deleteMemoList.count {
                DatabaseManager.persistentContainer.viewContext.delete(self.deleteMemoList.object(at: i) as! Memo)
                LocalNotificationManager.removeNotification(data: self.deleteMemoList.object(at: i) as! Memo)
            }
            self.editable = false
            self.editBtn.setTitle("編集", for: .normal)
            self.editBtn.setTitleColor(.systemBlue, for: .normal)
            self.loadMemoData(key: self.searchBar.searchTextField.text!)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.editable = false
            self.collectionView.reloadData()
            self.editBtn.setTitle("編集", for: .normal)
            self.editBtn.setTitleColor(.systemBlue, for: .normal)
            self.deleteMemoList.removeAllObjects()
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let vc = MemoViewController()
        vc.editType = "new"
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        if !editable {
            self.editBtn.setTitle("削除", for: .normal)
            self.editBtn.setTitleColor(.red, for: .normal)
            editable = !editable
            deleteMemoList.removeAllObjects()
            self.collectionView.reloadData()
        }else {
            if self.deleteMemoList.count > 0 {
                deleteSelectedDatas()
            }else {
                self.editable = false
                self.collectionView.reloadData()
                self.editBtn.setTitle("編集", for: .normal)
                self.editBtn.setTitleColor(.systemBlue, for: .normal)
            }
        }
    }
    
    
}
