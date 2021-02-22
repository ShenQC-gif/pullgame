//
//  CustomView.swift
//  pullgame
//
//  Created by ちいつんしん on 2020/11/23.
//  Copyright © 2020 ちいつんしん. All rights reserved.
//

import UIKit

@objc protocol BtnAction {
    func didTapUp(_ tag: Int)

    func didTapDown(_ tag: Int)
}

class CustomView: UIView {
    @IBOutlet var BtnActionDelegate: BtnAction?

    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var BtnSV: UIStackView!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var upBtn0: UIButton!
    @IBOutlet var upBtn1: UIButton!
    @IBOutlet var upBtn2: UIButton!
    @IBOutlet var upBtn3: UIButton!
    @IBOutlet var upBtn4: UIButton!

    @IBOutlet var downBtn0: UIButton!
    @IBOutlet var downBtn1: UIButton!
    @IBOutlet var downBtn2: UIButton!
    @IBOutlet var downBtn3: UIButton!
    @IBOutlet var downBtn4: UIButton!

    var scoreNum = Int()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    func loadNib() {
        // CustomViewの部分は各自作成したXibの名前に書き換えてください
        let view = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
        // timerに枠線を設定
        timerLabel.layer.borderWidth = 1
        scoreNum = 0
    }

    @IBAction func presetnUp(_ sender: Any) {
        let tag = ((sender as AnyObject).tag)!

        BtnActionDelegate?.didTapUp(tag)
    }

    @IBAction func presentDown(_ sender: Any) {
        let tag = ((sender as AnyObject).tag)!

        BtnActionDelegate?.didTapDown(tag)
    }
}

struct ResultLabelProperty {
    let text: String
    let color: UIColor
}

enum Result {
    case win
    case lose
    case draw

    func returnResult() -> ResultLabelProperty {
        switch self {
        case .win:
            return ResultLabelProperty(text: "Win!", color: .red)
        case .lose:
            return ResultLabelProperty(text: "...Lose", color: .blue)
        case .draw:
            return ResultLabelProperty(text: "Draw!", color: .black)
        }
    }
}
