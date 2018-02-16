
//  ViewController.swift
//  かわすやつ
//
//  Created by メイト on 2017/12/25.
//  Copyright © 2017年 com.litech. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel! //タイマーのラベル
    
    var imgViews: [CGRect] = []
    var timeCount = 15
    var myTimer = Timer()
    
    
    var playerImageView: UIImageView!
    var playerMotionManager: CMMotionManager!
    var speedX: Double = 0.0
    var speedY: Double = 0.0
    
    let screenSize = UIScreen.main.bounds.size
    
    //スタートとゴールを表すUIView
    var startView: UIView!
    //    var goalView: UIView!
    
    let structView = UIView(frame: CGRect(x: 0, y: 0, width: 375
        , height: 800))
    
    //wallViewのフレーム情報を入れて置く配列
    var wallRectArray = [CGRect]()
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        myTimer =
//            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector
//                (ViewController.timerUpdate),userInfo: nil, repeats: true)
//        
        //playetViewを生成
        // プレイヤーの大きさと位置を指定
        playerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        playerImageView.center = structView.center
        //UIImageを作成
        let playerImage: UIImage = UIImage(named: "zigun.png")!
        
        playerImageView.image = playerImage
        start()
        //        playerImageView.center = structView.center
        
        self.view.addSubview(playerImageView)
        
        //MotionManegerを作成
        playerMotionManager = CMMotionManager()
        playerMotionManager.accelerometerUpdateInterval = 0.02
        
        self.startAccelerometer()
        
        
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func startAccelerometer() {
        
        
        //加速度を取得する
        let handler: CMAccelerometerHandler = {(CMAccelerometerData:CMAccelerometerData?, error:Error?) ->
            Void in
            self.speedX += CMAccelerometerData!.acceleration.x
            self.speedY += CMAccelerometerData!.acceleration.y
            
            //プレイヤーの中心位置を設定
            var posX = self.playerImageView.center.x + (CGFloat(self.speedX) / 3)
            var posY = self.playerImageView.center.y - (CGFloat(self.speedY) / 3)
            
            //画面上からプレイヤーがはみ出しそうだったら、posX/posYを修正
            if posX <= self.playerImageView.frame.width / 2 {
                self.speedX = 0
                posX = self.playerImageView.frame.width / 2
            }
            if posY <= self.playerImageView.frame.width / 2 {
                self.speedY = 0
                posY = self.playerImageView.frame.width / 2
            }
            if posX >= self.screenSize.width - (self.playerImageView.frame.width / 2) {
                self.speedX = 0
                posX = self.screenSize.width - (self.playerImageView.frame.width / 2)
            }
            if posY >= self.screenSize.height - (self.playerImageView.frame.width / 2) {
                self.speedY = 0
                posY = self.screenSize.height - (self.playerImageView.frame.width / 2)
            }
            
            for wallRect in self.imgViews {
                if (wallRect.intersects(self.playerImageView.frame)){
                    self.gameCheck(result: "gameover", messege: "敵に当たりました")
                    return
                }
            }
           
            self.playerImageView.center = CGPoint(x: posX, y: posY)
        }
        //加速度の開始
        playerMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: handler)
    }
    
    func gameCheck(result: String, messege: String){
        //加速度を止める
        if playerMotionManager.isAccelerometerActive {
            playerMotionManager.stopAccelerometerUpdates()
        }
        
        let gameCheckAlert: UIAlertController = UIAlertController(title: result, message: messege,
                                                                  preferredStyle: .alert)
        
        self.present(gameCheckAlert, animated: true, completion: nil)
    }
    var timer: Timer! //画像を動かすためのタイマー
    
    @objc func up() {}

    func start() {
        //タイマーを動かす
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self,
                                     selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        timer.fire()
    }

    @objc func timerUpdate() {
        timeCount -= 1
        label.text = "残り\(timeCount)秒"
        if timeCount < 1 {
            myTimer.invalidate()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    ///////////////////////////////////////////////////////////////////////////////////////
        }
}
