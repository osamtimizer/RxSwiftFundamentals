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

    viewModel.showLoginButton
      .subscribe({ [weak self] _ in
        self?.loginButton.isHidden = false
      })
      .disposed(by: disposeBag)

    viewModel.hideLoginButton
      .subscribe({ [weak self] _ in
        self?.loginButton.isHidden = true
      })
      .disposed(by: disposeBag)

    viewModel.showDescriptionLabel
      .subscribe({[weak self] _ in
        self?.descriptionLabel.isHidden = false
      })
      .disposed(by: disposeBag)

    viewModel.hideDescriptionLabel
      .subscribe({[weak self] _ in
        self?.descriptionLabel.isHidden = true
      })
      .disposed(by: disposeBag)

    viewModel.showLogoutButton
      .subscribe({[weak self] _ in
        self?.logoutButton.isHidden = false
      })
      .disposed(by: disposeBag)

    viewModel.hideLogoutButton
      .subscribe({[weak self] _ in
        self?.logoutButton.isHidden = true
      })
      .disposed(by: disposeBag)

    viewModel.updateDescription
      .bind(to: descriptionLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.viewDidLoad.accept(())
  }
}

