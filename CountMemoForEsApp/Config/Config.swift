//
//  Config.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import Foundation
import UIKit

func SCALE(value : CGFloat) -> CGFloat{
    return value * Config.SCREEN_WIDTH / 414
}
func BORDER_WIDTH() -> CGFloat{
    if(Config.SCREEN_WIDTH>375){
        return 0.33
    }else{
        return 0.5
    }
}

class Config {
    
    static let MemoTypeData = ["北海道",
    "青森県",
    "岩手県",
    "宮城県",
    "秋田県"]
    

    static let YES = "はい"
    static let NO = "いいえ"
    static let CANCEL = "キャンセル"
    static let INPUT_ERR_TITLE = "入力エラー"
    static let INPUT_ERR_MSG = "を正確に入力してください。"

    static let BASE = UIColor(red: 1.0, green: 196/255, blue: 193/255, alpha: 1.0)
    static let BACK = UIColor(red: 137/255, green: 193/255, blue: 180/255, alpha: 1.0)
    static let GRAY = UIColor(red: 112/255, green: 111/255, blue: 111/255, alpha: 1.0)
    static let BLACK = UIColor(red: 29/255, green: 29/255, blue: 27/255, alpha: 1.0)
    static let BUBBLE = UIColor(red: 203/255, green: 187/255, blue: 159/255, alpha: 1.0)

    //UIConfig
    
    static let SCREEN_WIDTH  = CGFloat(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT = CGFloat(UIScreen.main.bounds.size.height)
    static let SCALE         = SCREEN_WIDTH / 414.0
    static let HEADER_HEIGHT = 70 * SCALE
    static let TABBAR_HEIGHT = 60 * SCALE
    static let NAV_BAR_OFFSET: Int = 50
    
}
