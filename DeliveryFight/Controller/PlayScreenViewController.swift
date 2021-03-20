//
//  PlayScreenViewController.swift
//  DeliveryFight
//
//  Created by ちいつんしん on 2021/03/16.
//  Copyright © 2021 ちいつんしん. All rights reserved.
//

import UIKit

class PlayScreenViewController: UIViewController {

    @IBOutlet private weak var beltView1: BeltView!
    @IBOutlet private weak var beltView2: BeltView!
    @IBOutlet private weak var beltView3: BeltView!
    @IBOutlet private weak var beltView4: BeltView!
    @IBOutlet private weak var beltView5: BeltView!

    @IBOutlet private weak var player1Buttons1: UpDownButtonView!
    @IBOutlet private weak var player1Buttons2: UpDownButtonView!
    @IBOutlet private weak var player1Buttons3: UpDownButtonView!
    @IBOutlet private weak var player1Buttons4: UpDownButtonView!
    @IBOutlet private weak var player1Buttons5: UpDownButtonView!

    @IBOutlet private weak var player2Buttons1: UpDownButtonView!
    @IBOutlet private weak var player2Buttons2: UpDownButtonView!
    @IBOutlet private weak var player2Buttons3: UpDownButtonView!
    @IBOutlet private weak var player2Buttons4: UpDownButtonView!
    @IBOutlet private weak var player2Buttons5: UpDownButtonView!

    @IBOutlet private weak var player1ScoreView: ScoreView!
    @IBOutlet private weak var player2ScoreView: ScoreView!

    @IBOutlet private weak var player1TimerView: TimerView!
    @IBOutlet private weak var player2TimerView: TimerView!

    private var gameStatus = GameStatus.firstStatus
    private var sounds = Sounds()
    private var timeLimitRepository = TimeLimitRepository()
    private var timeLimit = TimeLimit.thirty
    private var timer = Timer()
    private var restTime = Int()

    @IBOutlet private weak var announceLabel: UILabel!


    private var beltViews : [BeltView] {
        [
            beltView1,
            beltView2,
            beltView3,
            beltView4,
            beltView5
        ]
    }

    private var player1Buttons : [UpDownButtonView] {
        [
            player1Buttons1,
            player1Buttons2,
            player1Buttons3,
            player1Buttons4,
            player1Buttons5
        ]
    }

    private var player2Buttons : [UpDownButtonView] {
        [
            player2Buttons1,
            player2Buttons2,
            player2Buttons3,
            player2Buttons4,
            player2Buttons5
        ]
    }

    //ここで具体的なBeltの状態(Item,Item位置)を設定
    private var beltStates : [BeltState] = [
        BeltState(item: Apple(), itemPosition: .onBelt(ItemBeltPosition.center)),
        BeltState(item: Apple(), itemPosition: .onBelt(ItemBeltPosition.center)),
        BeltState(item: Apple(), itemPosition: .onBelt(ItemBeltPosition.center)),
        BeltState(item: Apple(), itemPosition: .onBelt(ItemBeltPosition.center)),
        BeltState(item: Apple(), itemPosition: .onBelt(ItemBeltPosition.center))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configure()
    }

    //ゲームを始める前に一度だけ設定すれば良いもの設定
    private func setUp(){

        zip(beltStates, beltViews).forEach {
            $1.configure(beltState: $0)
        }

        player1Buttons.enumerated().forEach { offset, UpDownButtonView in
            UpDownButtonView.configure(
                didTapUp: { [weak self] in
                    self?.itemUp(index: offset)
                },
                didTapDown: { [weak self] in
                    self?.itemDown(index: offset)
                }
            )}

        player2Buttons.enumerated().forEach { offset, UpDownButtonView in
            UpDownButtonView.configure(
                didTapUp: { [weak self] in
                    self?.itemUp(index: offset)
                },
                didTapDown: { [weak self] in
                    self?.itemDown(index: offset)
                }
            )}

        timeLimit = timeLimitRepository.load() ?? .thirty
        restTime = timeLimit.rawValue
        player1TimerView.setTime(time: restTime)
        player2TimerView.setTime(time: restTime)
    }

    //ゲーム全体の状態によって表示(内容・方法)が変わるものを規定
    private func configure(){
        switch gameStatus {
            case .countDownBeforPlay(countDown: let countDown):
                switch countDown {
                    case .three:

                        sounds.playSound(rosource: CountDown())
                        announceLabel.text = "③"

                        for beltView in beltViews {
                            beltView.hideItem(hide: true)
                        }

                        for button in player1Buttons {
                            button.status(isEnabled: false)
                        }

                        for button in player2Buttons {
                            button.status(isEnabled: false)
                        }

                        player1ScoreView.resetScore()
                        player2ScoreView.resetScore()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.gameStatus = .countDownBeforPlay(countDown: .two)
                            self.configure()
                        }

                    case .two:
                        announceLabel.text = "②"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.gameStatus = .countDownBeforPlay(countDown: .one)
                            self.configure()
                        }

                    case .one:
                        announceLabel.text = "①"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.gameStatus = .onPlay
                            self.configure()
                        }
                }

            case .onPlay:
                announceLabel.isHidden = true

                for beltView in beltViews {
                    beltView.hideItem(hide: false)
                }

                for button in player1Buttons {
                    button.status(isEnabled: true)
                }

                for button in player2Buttons {
                    button.status(isEnabled: true)
                }

            // タイマースタート
            timerStart()

            case .afterPlay:
                announceLabel.isHidden = false
                announceLabel.text = "Finish!!"

                sounds.playSound(rosource: Finish())

                for beltView in beltViews {
                    beltView.hideItem(hide: true)
                }

                for button in player1Buttons {
                    button.status(isEnabled: false)
                }

                for button in player2Buttons {
                    button.status(isEnabled: false)
                }
        }
    }

    private func itemUp(index: Int){

        let belt = beltStates[index]
        let item = belt.item
        let newItemPosition : ItemPosition = {
            switch belt.itemPosition{
                case let .onBelt(position):
                    return position.prev().map { ItemPosition.onBelt($0)} ?? ItemPosition.outOfBelt(.player1)
                case .outOfBelt:
                    return ItemPosition.onBelt(.center)
            }
        }()

        beltStates[index] = BeltState(item: item, itemPosition: newItemPosition)
        beltViews[index].configure(beltState: beltStates[index])
        checkIfOutOfBelt(index: index)
    }

    private func itemDown(index: Int){

        let belt = beltStates[index]
        let item = belt.item
        let newItemPosition : ItemPosition = {
            switch belt.itemPosition{
                case let .onBelt(position):
                    return position.next().map { ItemPosition.onBelt($0)} ?? ItemPosition.outOfBelt(.player2)
                case .outOfBelt:
                    return ItemPosition.onBelt(.center)
            }
        }()

        beltStates[index] = BeltState(item: item, itemPosition: newItemPosition)
        beltViews[index].configure(beltState: beltStates[index])
        checkIfOutOfBelt(index: index)
    }

    private func checkIfOutOfBelt(index: Int){
        switch beltStates[index].itemPosition {
            case let .outOfBelt(player):

                player1Buttons[index].status(isEnabled: false)
                player2Buttons[index].status(isEnabled: false)
                playSoundByTypeOfItem(item: beltStates[index].item)

                switch player {
                    case .player1:
                        player1ScoreView.updateScore(item: beltStates[index].item)
                    case .player2:
                        player2ScoreView.updateScore(item: beltStates[index].item)
                }


                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.gameStatus == .onPlay{
                        self.resetBelt(index: index)
                    }
                }

            default:
                break
        }
    }

    private func resetBelt(index: Int){
        player1Buttons[index].status(isEnabled: true)
        player2Buttons[index].status(isEnabled: true)
        beltStates[index] = BeltState(item: randomItem(), itemPosition: .onBelt(.center))
        beltViews[index].configure(beltState: beltStates[index])
    }

    private func randomItem() -> ItemType {
        return MainViewController.itemArray.randomElement() ?? Apple()
    }

    private func timerStart() {
        // タイマーを作動
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] timer in

            if restTime > 0 {
                // 残り時間を減らしていく
                restTime -= 1
                player1TimerView.setTime(time:restTime)
                player2TimerView.setTime(time:restTime)
            }
            if restTime == 0 {
                // タイマーを無効化にし、ゲーム終了時の挙動へ
                timer.invalidate()
                gameStatus = .afterPlay
                configure()
            }
        })
    }

    // presentの種類によって音声を再生
    private func playSoundByTypeOfItem(item: ItemType) {
        // presentが爆弾なら爆発音、それ以外なら得点
        if item.isBomb {
            sounds.playSound(rosource: GetBomb())
        } else {
            sounds.playSound(rosource: GetPoint())
        }
    }

}
