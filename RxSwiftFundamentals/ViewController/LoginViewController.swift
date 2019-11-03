//
//  LoginViewController.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/03.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class LoginViewController: UIViewController {
  @IBOutlet weak var warningLabel: UILabel!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var submitLoginButton: UIButton!

  private let viewModel = LoginViewModel()
  private let disposeBag = DisposeBag()

  public override func viewDidLoad() {
    super.viewDidLoad()

    usernameTextField.rx.text.orEmpty
      .bind(to: viewModel.username)
      .disposed(by: disposeBag)

    passwordTextField.rx.text.orEmpty
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)

    submitLoginButton.rx.tap
      .bind(to: viewModel.onTapSubmitLoginButton)
      .disposed(by: disposeBag)

    viewModel.showWarningLabel
      .subscribe({[weak self] _ in
        self?.warningLabel.isHidden = false
      })
      .disposed(by: disposeBag)
    
    viewModel.dismiss
      .subscribe(onNext: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)

  }
}
