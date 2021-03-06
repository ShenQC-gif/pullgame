//
//  ViewController.swift
//  DeliveryFight
//
//  Created by ちいつんしん on 2020/08/22.
//  Copyright © 2020 ちいつんしん. All rights reserved.
//

import AVFoundation
import UIKit

class MainViewController: UIViewController, AVAudioPlayerDelegate, BtnAction {
    private var beltStates = MainViewController.makeInitialState()
    private var sounds = Sounds()
    private var timeLimitRepository = TimeLimitRepository()
    private var timeLimit = TimeLimit.thirty
    static let itemArray: [ItemType] = [Apple(), Grape(), Melon(), Peach(), Banana(), Cherry(), Bomb()]
    static func makeInitialState() -> [BeltState] {
        [
            BeltState(item: itemArray.randomElement() ?? Apple(), itemPosition: .onBelt(.center)),
            BeltState(item: itemArray.randomElement() ?? Apple(), itemPosition: .onBelt(.center)),
            BeltState(item: itemArray.randomElement() ?? Apple(), itemPosition: .onBelt(.center)),
            BeltState(item: itemArray.randomElement() ?? Apple(), itemPosition: .onBelt(.center)),
            BeltState(item: itemArray.randomElement() ?? Apple(), itemPosition: .onBelt(.center)),
        ]
    }

    @IBOutlet private var consoleView1: CustomView!
    @IBOutlet private var consoleView2: CustomView!

    private var imageViewArrays = [[UIImageView]]()
    @IBOutlet private var imageView1: UIImageView!
    @IBOutlet private var imageView2: UIImageView!
    @IBOutlet private var imageView3: UIImageView!
    @IBOutlet private var imageView4: UIImageView!
    @IBOutlet private var imageView5: UIImageView!
    @IBOutlet private var imageView6: UIImageView!
    @IBOutlet private var imageView7: UIImageView!
    @IBOutlet private var imageView8: UIImageView!
    @IBOutlet private var imageView9: UIImageView!
    @IBOutlet private var imageView10: UIImageView!
    @IBOutlet private var imageView11: UIImageView!
    @IBOutlet private var imageView12: UIImageView!
    @IBOutlet private var imageView13: UIImageView!
    @IBOutlet private var imageView14: UIImageView!
    @IBOutlet private var imageView15: UIImageView!
    @IBOutlet private var imageView16: UIImageView!
    @IBOutlet private var imageView17: UIImageView!
    @IBOutlet private var imageView18: UIImageView!
    @IBOutlet private var imageView19: UIImageView!
    @IBOutlet private var imageView20: UIImageView!
    @IBOutlet private var imageView21: UIImageView!
    @IBOutlet private var imageView22: UIImageView!
    @IBOutlet private var imageView23: UIImageView!
    @IBOutlet private var imageView24: UIImageView!
    @IBOutlet private var imageView25: UIImageView!
    @IBOutlet private var imageView26: UIImageView!
    @IBOutlet private var imageView27: UIImageView!
    @IBOutlet private var imageView28: UIImageView!
    @IBOutlet private var imageView29: UIImageView!
    @IBOutlet private var imageView30: UIImageView!
    @IBOutlet private var imageView31: UIImageView!
    @IBOutlet private var imageView32: UIImageView!
    @IBOutlet private var imageView33: UIImageView!
    @IBOutlet private var imageView34: UIImageView!
    @IBOutlet private var imageView35: UIImageView!

    @IBOutlet private var callLabel: UILabel!
    @IBOutlet private var againBtn: UIButton!
    @IBOutlet private var homeBtn: UIButton!

    private var timer = Timer()
    private var restTime = Int()

    // btnを1列ごとに管理
    private var btnLine1 = [UIButton]()
    private var btnLine2 = [UIButton]()
    private var btnLine3 = [UIButton]()
    private var btnLine4 = [UIButton]()
    private var btnLine5 = [UIButton]()
    // btnLineを一括管理
    private var btnLineArrays = [[UIButton]]()

    /*-------------------画面読込-------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewArrays = [
            [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7],
            [imageView8, imageView9, imageView10, imageView11, imageView12, imageView13, imageView14],
            [imageView15, imageView16, imageView17, imageView18, imageView19, imageView20, imageView21],
            [imageView22, imageView23, imageView24, imageView25, imageView26, imageView27, imageView28],
            [imageView29, imageView30, imageView31, imageView32, imageView33, imageView34, imageView35],
        ]

        // Btnを一列毎に管理
        btnLine1 = [consoleView1.upBtn0, consoleView1.downBtn0, consoleView2.upBtn0, consoleView2.downBtn0]
        btnLine2 = [consoleView1.upBtn1, consoleView1.downBtn1, consoleView2.upBtn1, consoleView2.downBtn1]
        btnLine3 = [consoleView1.upBtn2, consoleView1.downBtn2, consoleView2.upBtn2, consoleView2.downBtn2]
        btnLine4 = [consoleView1.upBtn3, consoleView1.downBtn3, consoleView2.upBtn3, consoleView2.downBtn3]
        btnLine5 = [consoleView1.upBtn4, consoleView1.downBtn4, consoleView2.upBtn4, consoleView2.downBtn4]

        // btnLineを一括管理
        btnLineArrays = [btnLine1, btnLine2, btnLine3, btnLine4, btnLine5]

        consoleView1.delegate = self
        consoleView2.delegate = self

        againBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        homeBtn.titleLabel?.adjustsFontSizeToFitWidth = true

        // player1側のLabelは180度回転させる
        rotate(consoleView1, 180)
        // ボタンだけは元に戻す
        rotate(consoleView1.BtnSV, 180)

        // game開始
        gameStart()
    }

    // Viewを回転させる
    private func rotate(_ UIView: UIView, _ angle: CGFloat) {
        let oneDegree = CGFloat.pi / 180
        UIView.transform = CGAffineTransform(rotationAngle: CGFloat(oneDegree * angle))
    }

    /*-------------------game開始時の挙動-------------------*/

    // game開始(再開)
    private func gameStart() {
        // 画面初期化
        beforeCountDown()

        // カウントダウン開始
        callLabel.text = "③"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.sounds.playSound(rosource: CountDown())

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.callLabel.text = "②"

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.callLabel.text = "①"

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.afterCountDown()
                    }
                }
            }
        }
    }

    // 画面初期化
    private func beforeCountDown() {
        // 各種表示/非表示切り替え
        againBtn.isHidden = true
        homeBtn.isHidden = true
        callLabel.isHidden = false

        // 勝ち負けLabelを非表示
        consoleView1.hideResultLabel()
        consoleView2.hideResultLabel()

        consoleView1.resetScore()
        consoleView2.resetScore()

        timeLimit = timeLimitRepository.load() ?? .thirty
        restTime = timeLimit.rawValue
        consoleView1.loadTime(self.restTime)
        consoleView2.loadTime(self.restTime)
    }

    // カウントダウン終了後の状態
    private func afterCountDown() {
        callLabel.isHidden = true

        // Btn有効化
        for btnLine in btnLineArrays {
            btnLineStatus(btnLine: btnLine, status: true)
        }

        // imageViewを表示
        for imageArray in imageViewArrays {
            for image in imageArray {
                image.isHidden = false
            }
        }

        beltStates = MainViewController.makeInitialState()
        configureUI(beltStates: beltStates)

        // タイマースタート
        timerStart()
    }

    private func timerStart() {
        // タイマーを作動
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] timer in

            if self.restTime > 0 {
                // 残り時間を減らしていく
                self.restTime -= 1
                consoleView1.loadTime(self.restTime)
                consoleView2.loadTime(self.restTime)
            }
            if self.restTime == 0 {
                // タイマーを無効化にし、ゲーム終了時の挙動へ
                timer.invalidate()
                self.gameFinish()
            }
        })
    }

    /*-------------------game中の操作-------------------*/

    func didTapUp(button: CustomView.UpButton) {

        let index = button.index

        let beltState = beltStates[index]

        let newItemPosition : ItemPosition = {
            switch beltState.itemPosition {
                case let .onBelt(position):
                    return position.prev().map { ItemPosition.onBelt($0) } ?? ItemPosition.outOfBelt(.player1)
                case .outOfBelt:
                    return ItemPosition.onBelt(.center)
            }
        }()

        beltStates[index] = BeltState(item: beltState.item, itemPosition: newItemPosition)
        configureUI(beltStates: beltStates)
        checkIfOutOfBelt(beltState: beltStates[index], player: .player1, index: index)
    }

    func didTapDown(button: CustomView.DownButton) {

        let index = button.index

        let beltState = beltStates[index]

        let newItemPosition: ItemPosition = {
            switch beltState.itemPosition {
                case let .onBelt(position):
                    return position.next().map { ItemPosition.onBelt($0) } ?? ItemPosition.outOfBelt(.player2)
                case .outOfBelt:
                    return ItemPosition.onBelt(.center)
            }
        }()
        
        beltStates[index] = BeltState(item: beltState.item, itemPosition: newItemPosition)
        configureUI(beltStates: beltStates)
        checkIfOutOfBelt(beltState: beltStates[index], player: .player2, index: index)
    }

    private func configureUI(beltStates: [BeltState]) {
        // ここでUIを適切に設定する
        for i in 0 ..< beltStates.count {
            let name = beltStates[i].item.imageName

            for imageView in imageViewArrays[i] {
                imageView.image = nil
            }

            func targetImageView() -> UIImageView{
                switch beltStates[i].itemPosition {
                case let .onBelt(poistion):
                    switch poistion {
                    case .pos0:
                        return imageViewArrays[i][1]
                    case .pos1:
                        return imageViewArrays[i][2]
                    case .pos2:
                        return imageViewArrays[i][3]
                    case .pos3:
                        return imageViewArrays[i][4]
                    case .pos4:
                        return imageViewArrays[i][5]
                    }

                case let .outOfBelt(player):
                    switch player {
                    case .player1:
                        return imageViewArrays[i][0]
                    case .player2:
                        return imageViewArrays[i][6]
                    }
                }
            }

            targetImageView().image = UIImage(named: name)
        }
    }

    private func checkIfOutOfBelt(beltState: BeltState, player: Player, index: Int) {
        if beltState.itemPosition == ItemPosition.outOfBelt(player) {
            playSoundByTypeOfPresent(beltState)
            updateScore(beltState: beltState, player: player)
            resetBeltState(index)
        }
    }

    private func updateScore(beltState: BeltState, player: Player) {
        switch player {
        case .player1:
            consoleView1.updateScore(item: beltState.item)
        case .player2:
            consoleView2.updateScore(item: beltState.item)
        }
    }

    private func resetBeltState(_ index: Int) {
        btnLineStatus(btnLine: btnLineArrays[index], status: false)

        let newItem = MainViewController.itemArray.randomElement() ?? Apple()
        let newItemPosition = ItemPosition.onBelt(.center)
        beltStates[index] = BeltState(item: newItem, itemPosition: newItemPosition)

        // 0.5秒後に、残り時間がまだあればItemを再セット
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.restTime > 0 {
                self.configureUI(beltStates: self.beltStates)
                self.btnLineStatus(btnLine: self.btnLineArrays[index], status: true)
            }
        }
    }

    /*-------------------game終了後の挙動-------------------*/

    // game終了
    private func gameFinish() {
        sounds.playSound(rosource: Finish())

        // 画面上からimageViewを消す
        for imageArray in imageViewArrays {
            for image in imageArray {
                image.isHidden = true
            }
        }

        // Btn無効化
        for btnLine in btnLineArrays {
            btnLineStatus(btnLine: btnLine, status: false)
        }

        callLabel.isHidden = false
        callLabel.text = "Finish!!"

        // 結果発表
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.compareScore()

            // 時間差で表示されることがあるため、もう一度Btn無効化
            for btnLine in self.btnLineArrays {
                self.btnLineStatus(btnLine: btnLine, status: false)
            }
        }

        // メニュー表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.callLabel.isHidden = true
            self.againBtn.isHidden = false
            self.homeBtn.isHidden = false
        }
    }

    // 点数比較して勝ち負けを表示
    private func compareScore() {

        func judgePlayer1() -> GameResult{
            if consoleView1.scoreNum > consoleView2.scoreNum {
                return .win
            } else if consoleView1.scoreNum < consoleView2.scoreNum {
                return .lose
            } else {
                return .draw
            }
        }

        func judgePlayer2() -> GameResult{
            judgePlayer1().opponentResult()
        }

        consoleView1.configureApperance(gameResult: judgePlayer1())
        consoleView2.configureApperance(gameResult: judgePlayer2())

    }

    @IBAction private func startAgain(_: Any) {
        gameStart()
        sounds.playSound(rosource: Decide())
    }

    @IBAction func home(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        sounds.playSound(rosource: Decide())
    }

    /*-------------------その他共通-------------------*/
    // presentの種類によって音声を再生
    private func playSoundByTypeOfPresent(_ beltState: BeltState) {
        // presentが爆弾なら爆発音、それ以外なら得点
        if beltState.item.isBomb {
            sounds.playSound(rosource: GetBomb())
        } else {
            sounds.playSound(rosource: GetPoint())
        }
    }

    // 1列毎のbtnLineの有効化/無効化を管理
    private func btnLineStatus(btnLine: [UIButton], status: Bool) {
        for btn in btnLine {
            btn.isEnabled = status
        }
    }
}


private extension CustomView.UpButton {
    var index : Int {
        switch self {
            case .upButton0:
                return 0
            case .upButton1:
                return 1
            case .upButton2:
                return 2
            case .upButton3:
                return 3
            case .upButton4:
                return 4
        }
    }
}

private extension CustomView.DownButton {
    var index : Int {
        switch self {

            case .downButton0:
                return 0
            case .downButton1:
                return 1
            case .downButton2:
                return 2
            case .downButton3:
                return 3
            case .downButton4:
                return 4
        }
    }
}
