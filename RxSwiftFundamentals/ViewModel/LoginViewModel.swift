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
  var onTapBackButton: PublishRelay<Void> { get }
  var username: PublishRelay<String> { get }
  var password: PublishRelay<String> { get }
}

public protocol LoginViewModelOutput {
  var isHiddenWarningLabel: PublishRelay<Bool> { get }
  var dismiss: PublishRelay<Void> { get }
}

public final class LoginViewModel: LoginViewModelInput, LoginViewModelOutput {
  private let disposeBag = DisposeBag()

  // input
  public let viewDidLoad = PublishRelay<Void>()
  public let onTapSubmitLoginButton = PublishRelay<Void>()
  public let onTapBackButton = PublishRelay<Void>()
  public let username = PublishRelay<String>()
  public let password = PublishRelay<String>()

  // output
  public let isHiddenWarningLabel = PublishRelay<Bool>()
  public let dismiss = PublishRelay<Void>()

  init(store: Store = Store.singleton) {
    let loginParams = Observable.combineLatest(username, password) { username, password in
      (username, password)
    }

    // input
    onTapSubmitLoginButton.withLatestFrom(loginParams)
      .flatMap { (username, password) in
        LoginAction.tryLogin(username: username, password: password)
    }
    .bind(to: store.login)
    .disposed(by: disposeBag)

    onTapBackButton
      .bind(to: dismiss)
      .disposed(by: disposeBag)

    // store
    store.login.filter { $0 == true }
    .withLatestFrom(username)
      .flatMap { username in
        UserAction.fetchUserInfo(username: username)
    }
      .subscribe()
      .disposed(by: disposeBag)

    store.login.filter { $0 == true }
      .map { _ in }
      .bind(to: dismiss)
      .disposed(by: disposeBag)

    store.login.filter { $0 == false }
      .subscribe({[weak self] _ in
        self?.isHiddenWarningLabel.accept(false)
      })
      .disposed(by: disposeBag)
  }
}
