//
//  ViewController.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/03.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
  @IBOutlet weak var transitonButton: UIButton!
  private let viewModel = MainViewModel()
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    transitonButton.rx.tap
      .bind(to: viewModel.onTapTransitionButton)
      .disposed(by: disposeBag)

    viewModel.showSub1View
      .subscribe(onNext: { [weak self] _ in
        self?.performSegue(withIdentifier: "toSub1", sender: nil)
      })
      .disposed(by: disposeBag)

    viewModel.viewDidLoad.accept(())
  }
}

