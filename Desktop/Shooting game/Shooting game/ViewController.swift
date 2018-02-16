
//  ViewController.swift
//  かわすやつ
//
//  Created by メイト on 2017/12/25.
//  Copyright © 2017年 com.litech. All rights reserved.
//

import UIKit
import CoreMotion

class GameViewController: UIViewController {
    
    @IBOutlet var label: UILabel! //タイマーのラベル
    
    var imgViews: [CGRect] = []
    
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
        
        //playetViewを生成
        // プレイヤーの大きさと位置を指定
        playerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        playerImageView.center = structView.center
        //UIImageを作成
        let playerImage: UIImage = UIImage(named: "icon.jpg")!
        
        playerImageView.image = playerImage
        
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
            //
            //            if (self.goalView.frame.intersects(self.playerImageView.frame)){
            //                self.gameCheck(result: "claer", messege: "クリアしました")
            //                return
            //            }
            
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
        
        let retryAction = UIAlertAction(title: "もう一度", style: .default, handler:  {
            (action: UIAlertAction!) -> Void in
            self.retry()
        })
        
        gameCheckAlert.addAction(retryAction)
        
        self.present(gameCheckAlert, animated: true, completion: nil)
    }
    
    func retry () {
        //プレイヤーの位置を初期化
        playerImageView.center = structView.center
        //加速度センサーを開始する
        if !playerMotionManager.isAccelerometerActive {
            self.startAccelerometer()
        }
        
        
        
        //スピードを初期化
        speedX = 0
        speedY = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    ///////////////////////////////////////////////////////////////////////////////////////
    
    
}

