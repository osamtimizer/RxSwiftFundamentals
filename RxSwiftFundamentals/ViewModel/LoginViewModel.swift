//
//  LoginViewModel.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/03.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol LoginViewModelInput {
  var viewDidLoad: PublishRelay<Void> { get }
  var onTapSubmitLoginButton: PublishRelay<Void> { get }
  var username: PublishRelay<String> { get }
  var password: PublishRelay<String> { get }
}

public protocol LoginViewModelOutput {
  var showWarningLabel: PublishRelay<Void> { get }
  var hideWarningLabel: PublishRelay<Void> { get }
  var dismiss: PublishRelay<Void> { get }
}

public final class LoginViewModel: LoginViewModelInput, LoginViewModelOutput {
  private let disposeBag = DisposeBag()

  // input
  public let viewDidLoad = PublishRelay<Void>()
  public let onTapSubmitLoginButton = PublishRelay<Void>()
  public let username = PublishRelay<String>()
  public let password = PublishRelay<String>()

  // output
  public let showWarningLabel = PublishRelay<Void>()
  public let hideWarningLabel = PublishRelay<Void>()
  public let dismiss = PublishRelay<Void>()

  init(store: Store = Store.singleton) {
    let loginParams = Observable.combineLatest(username, password) { username, password in
      (username, password)
    }

    onTapSubmitLoginButton.withLatestFrom(loginParams)
      .flatMap { (username, password) in
        LoginAction.tryLogin(username: username, password: password)
    }
    .map { [weak self] result in
      if result == false {
        self?.showWarningLabel.accept(())
      }
      return result
    }
    .bind(to: store.login)
    .disposed(by: disposeBag)

    store.login.filter { $0 == true }
      .subscribe({[weak self] _ in
        self?.dismiss.accept(())
      })
      .disposed(by: disposeBag)

  }
}
