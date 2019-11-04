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
  // outlets
  @IBOutlet weak var transitonButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var descriptionLabel: UILabel!

  private let viewModel = MainViewModel()
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    // input
    transitonButton.rx.tap
      .bind(to: viewModel.onTapTransitionButton)
      .disposed(by: disposeBag)

    loginButton.rx.tap
      .bind(to: viewModel.onTapLoginButton)
      .disposed(by: disposeBag)

    logoutButton.rx.tap
      .bind(to: viewModel.onTapLogoutButton)
      .disposed(by: disposeBag)

    // output
    viewModel.showSub1View
      .subscribe(onNext: { [weak self] _ in
        self?.performSegue(withIdentifier: "toSub1", sender: nil)
      })
      .disposed(by: disposeBag)

    viewModel.showLoginView
      .subscribe(onNext: { [weak self] _ in
        self?.performSegue(withIdentifier: "toLogin", sender: nil)
      })
      .disposed(by: disposeBag)

    viewModel.isHiddenLoginButton
      .bind(to: loginButton.rx.isHidden)
      .disposed(by: disposeBag)

    viewModel.isHiddenDescriptionLabel
      .bind(to: descriptionLabel.rx.isHidden)
      .disposed(by: disposeBag)

    viewModel.isHiddenLogoutButton
      .bind(to: logoutButton.rx.isHidden)
      .disposed(by: disposeBag)

    viewModel.updateDescription
      .bind(to: descriptionLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.viewDidLoad.accept(())
  }
}

