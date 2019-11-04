//
//  MainViewModel.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/03.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol MainViewModelInput {
  var viewDidLoad: PublishRelay<Void> { get }
  var onTapTransitionButton: PublishRelay<Void> { get }
  var onTapLoginButton: PublishRelay<Void> { get }
  var onTapLogoutButton: PublishRelay<Void> { get }
}

public protocol MainViewModelOutput {
  var showDescriptionLabel: PublishRelay<Void> { get }
  var hideDescriptionLabel: PublishRelay<Void> { get }
  var showLoginButton: PublishRelay<Void> { get }
  var hideLoginButton: PublishRelay<Void> { get }
  var showLogoutButton: PublishRelay<Void> { get }
  var hideLogoutButton: PublishRelay<Void> { get }
  var showSub1View: PublishRelay<Void> { get }
  var showLoginView: PublishRelay<Void> { get }
  var updateDescription: PublishRelay<String> { get }
}

public final class MainViewModel: MainViewModelInput, MainViewModelOutput {
  // input
  public let viewDidLoad = PublishRelay<Void>()
  public let onTapTransitionButton = PublishRelay<Void>()
  public let onTapLoginButton = PublishRelay<Void>()
  public let onTapLogoutButton = PublishRelay<Void>()

  // output
  public let showDescriptionLabel = PublishRelay<Void>()
  public let hideDescriptionLabel = PublishRelay<Void>()
  public let showLoginButton = PublishRelay<Void>()
  public let hideLoginButton = PublishRelay<Void>()
  public let showLogoutButton = PublishRelay<Void>()
  public let hideLogoutButton = PublishRelay<Void>()
  public let showSub1View = PublishRelay<Void>()
  public let showLoginView = PublishRelay<Void>()
  public let updateDescription = PublishRelay<String>()

  private let disposeBag = DisposeBag()

  init(store: Store = Store.singleton) {

    store.login
      .filter {$0 == true}
      .subscribe(onNext: { [weak self] _ in
        self?.hideLoginButton.accept(())
        self?.showDescriptionLabel.accept(())
        self?.showLogoutButton.accept(())
      })
      .disposed(by: disposeBag)

    store.login
      .filter {$0 == false}
      .subscribe(onNext: { [weak self] _ in
        self?.showLoginButton.accept(())
        self?.hideLogoutButton.accept(())
        self?.hideDescriptionLabel.accept(())
      })
      .disposed(by: disposeBag)

    store.username
      .flatMap(Observable.from(optional:))
      .filter { !$0.isEmpty }
      .map { username in
        return String("Welcome back, \(username).")
    }
    .bind(to: updateDescription)
    .disposed(by: disposeBag)

    onTapTransitionButton
      .bind(to: showSub1View)
      .disposed(by: disposeBag)

    onTapLoginButton
      .withLatestFrom(store.login).filter { login in login == false }
      .map { _ in }
      .bind(to: showLoginView)
      .disposed(by: disposeBag)

    onTapLogoutButton.map{ _ in false}
      .bind(to: store.login)
    .disposed(by: disposeBag)
  }
}
