//
//  GameViewController.swift
//  SwiftTiles
//
//  Created by Sin2 on 2014-06-04.
//  Copyright (c) 2014 Sin2. All rights reserved.
//

import Foundation
import UIKit

class GameViewController : UIViewController {
    var _rows: NSMutableArray
    var _gameSize: Int
    var _gameProgress: Int
    var _gameTime: UILabel
    var _gameTimer: MZTimerLabel
    var _gameView: UIView
    
    init(gameSize: NSInteger ){
        _rows = NSMutableArray()
        _gameSize = gameSize
        _gameProgress = 0
        _gameTime = UILabel()
        _gameTimer = MZTimerLabel(label: _gameTime)
        _gameView = UIView()
        
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Swift Tiles"
        
        _gameTimer.timeFormat = "ss.SS\""
        _gameTime.frame = CGRectMake(0, 10, self.view.frame.size.width, kGameTimeLabelHeight)
        _gameTime.textAlignment = NSTextAlignment.Center
        _gameTime.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        _gameTime.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        self.view.addSubview(_gameTime)
        
        _gameView.frame = CGRectMake(0, kGameTimeLabelHeight, self.view.frame.size.width, self.view.frame.size.height - kGameTimeLabelHeight)
        _gameView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_gameView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        startGame()

    }
    
    func createTiles() {
        for var x = 0; x < defaultGameHeight; x++ {
            var row = createRow(x)
            row.alpha = 0;
            _gameView.addSubview(row)
            UIView.animateWithDuration(0.5, animations: {
                row.alpha = 1;
            })
            _rows.addObject(row)
        }

    }
    
    func createRow(rowY: NSInteger) -> UIView{
        let width = self.view.frame.size.width / CGFloat(_gameSize)
        let height = (self.view.frame.size.height - 50) / CGFloat(defaultGameHeight)
        let blackTileIndex = Int(rand()) % _gameSize
        
        var row: UIView = UIView(frame: CGRectMake(0, height * CGFloat(rowY), self.view.frame.size.width, height))
        for var x = 0; x < _gameSize; x++ {
            var tile: TileView
            var tileType: TileType = TileType.White
            var tileSelector = "whiteTileTapped:"
            
            switch x{
                case blackTileIndex:
                    tileType = TileType.Black
                    tileSelector = "blackTileTapped:"
                default:
                break
            }
            
            tile = TileView(type: tileType, frame: CGRectMake(CGFloat(x) * width, 0, width, height))
            var singleFingerTap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(tileSelector))
            tile.addGestureRecognizer(singleFingerTap)
            
            row.addSubview(tile)
        }
        return row
    }
    
    func blackTileTapped(sender : AnyObject) {
        if sender is UIGestureRecognizer{
            var x: TileView = sender.view! as TileView
            if x.superview.isEqual(_rows.lastObject){
                
                // Start Timer if new game
                if _gameProgress == 0 {
                    _gameTimer.start()
                }
                
                _gameProgress++
                
                // If gameover
                if _gameProgress == defaultGameLength{
                    _gameTimer.pause()
                    var alert = UIAlertController(title: "Game Over", message: "Your time is " + _gameTime.text, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    endGame()
                }
                
                let height = (self.view.frame.size.height - 50) / CGFloat(defaultGameHeight)
                
                //Shift Rows down
                UIView.animateWithDuration(0.01, animations: {
                    for row:AnyObject in self._rows{
                        var x = row as UIView
                        x.frame = CGRectMake(x.frame.origin.x, x.frame.origin.y + height, x.frame.size.width, x.frame.size.height)
                    }
                    }, completion: {isDone in
                        // Remove tapped row
                        var lastRow = self._rows.lastObject as UIView
                        lastRow.removeFromSuperview()
                        self._rows.removeLastObject()
                    })
                
                // Only add a row if there are rows left to add
                if defaultGameLength - defaultGameHeight >= _gameProgress{
                    //Add new row
                    var nextRow = createRow(0)
                    nextRow.frame = CGRectMake(nextRow.frame.origin.x, nextRow.frame.origin.y, nextRow.frame.size.width, nextRow.frame.size.height)
                    _rows.insertObject(nextRow, atIndex: 0)
                    _gameView.addSubview(_rows.firstObject as UIView)
                    _gameView.sendSubviewToBack(_rows.firstObject as UIView)
                }
            }
        }
    }
    
    func whiteTileTapped(sender: AnyObject) {
        // Reset game
        _gameTimer.pause()
        endGame()
    }
    
    func endGame() {
        for view : AnyObject in _rows{
            view.removeFromSuperview()
        }
        _rows.removeAllObjects()
        _gameTimer.reset()
        startGame()
    }
    
    func startGame() {
        _gameProgress = 0
        _gameTimer.reset()
        createTiles()
        
    }
}
