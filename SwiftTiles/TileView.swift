//
//  TileView.swift
//  SwiftTiles
//
//  Created by Sin2 on 2014-06-04.
//  Copyright (c) 2014 Sin2. All rights reserved.
//

import Foundation
import UIKit

enum TileType {
    case Black, White
}

class TileView : UIView {
    
    var _tileType: TileType
    
    init(type: TileType, frame:CGRect) {
        _tileType = type
        
        super.init(frame: frame)
        
        switch _tileType{
            case TileType.Black:
                    self.backgroundColor = UIColor.blackColor()
            case TileType.White:
                    self.backgroundColor = UIColor.whiteColor()
        }
        
        self.layer.borderWidth = 0.25
    }
    
}
