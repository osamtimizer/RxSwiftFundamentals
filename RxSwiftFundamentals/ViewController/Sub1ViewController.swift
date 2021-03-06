//
//  Sub1ViewController.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/03.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class Sub1ViewController: UIViewController {
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var notLoggedInDescriptionLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var userInfoStackView: UIStackView!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var followeeLabel: UILabel!
  @IBOutlet weak var followerLabel: UILabel!
  

  private let viewModel = Sub1ViewModel()
  private let disposeBag = DisposeBag()

  public override func viewDidLoad() {
    super.viewDidLoad()

    // input
    loginButton.rx.tap
      .bind(to: viewModel.onTapLoginbutton)
      .disposed(by: disposeBag)

    backButton.rx.tap
      .bind(to: viewModel.onTapBackButton)
      .disposed(by: disposeBag)

    // output
    viewModel.isHiddenContents
      .bind(to: notLoggedInDescriptionLabel.rx.isHidden)
      .disposed(by: disposeBag)

    viewModel.isHiddenLoginButton
      .bind(to: loginButton.rx.isHidden)
      .disposed(by: disposeBag)

    viewModel.isHiddenLoginContents
      .bind(to: userInfoStackView.rx.isHidden)
      .disposed(by: disposeBag)

    viewModel.email
      .bind(to: emailLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.username
      .bind(to: nameLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.followeeCount
      .bind(to: followeeLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.followerCount
      .bind(to: followerLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.dismiss
      .subscribe({ [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)

    viewModel.showLoginView
      .subscribe({ [weak self] _ in
        self?.performSegue(withIdentifier: "toLogin", sender: nil)
      })
      .disposed(by: disposeBag)

    viewModel.viewDidLoad.accept(())
  }
}
