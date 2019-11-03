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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    transitonButton.rx.tap
      .subscribe (onNext: { _ in
        print("tapped")
      })
  }
}

