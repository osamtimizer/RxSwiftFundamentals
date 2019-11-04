//
//  Sub1ViewModel.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/04.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol Sub1ViewModelInput {
  var viewDidLoad: PublishRelay<Void> { get }
  var onTapBackButton: PublishRelay<Void> { get }
  var onTapLoginbutton: PublishRelay<Void> { get }

}
public protocol Sub1ViewModelOutput {
  var isHiddenContents: BehaviorRelay<Bool> { get }
  var isHiddenLoginButton: BehaviorRelay<Bool> { get }
  var isHiddenLoginContents: BehaviorRelay<Bool> { get }
  var showLoginView: PublishRelay<Void> { get }
  var dismiss: PublishRelay<Void> { get }
  var email: BehaviorRelay<String> { get }
  var username: BehaviorRelay<String> { get }
  var followeeCount: BehaviorRelay<String> { get }
  var followerCount: BehaviorRelay<String> { get }

}

public final class Sub1ViewModel: Sub1ViewModelInput, Sub1ViewModelOutput {
  // input
  public let viewDidLoad = PublishRelay<Void>()
  public let onTapBackButton = PublishRelay<Void>()
  public let onTapLoginbutton = PublishRelay<Void>()

  // output
  public let isHiddenContents = BehaviorRelay<Bool>(value: false)
  public let isHiddenLoginContents = BehaviorRelay<Bool>(value: true)
  public let isHiddenLoginButton = BehaviorRelay<Bool>(value: false)
  public let showLoginView = PublishRelay<Void>()
  public let dismiss = PublishRelay<Void>()
  public let email = BehaviorRelay<String>(value: "")
  public let username = BehaviorRelay<String>(value: "")
  public let followeeCount = BehaviorRelay<String>(value: "")
  public let followerCount = BehaviorRelay<String>(value: "")

  private let disposeBag = DisposeBag()

  init(store: Store = Store.singleton) {
    store.login.filter { $0 == true }
      .subscribe({ [weak self] _ in
        self?.isHiddenContents.accept(true)
        self?.isHiddenLoginButton.accept(true)
        self?.isHiddenLoginContents.accept(false)
      })
      .disposed(by: disposeBag)

    store.email
      .flatMap(Observable.from(optional:))
      .filter { email in
        !email.isEmpty }
      .bind(to: email)
      .disposed(by: disposeBag)

    store.username
      .flatMap(Observable.from(optional:))
      .filter { username in
        !username.isEmpty }
      .bind(to: username)
      .disposed(by: disposeBag)

    store.followeeCount
      .flatMap(Observable.from(optional:))
      .map { count in String(count) }
      .bind(to: followeeCount)
      .disposed(by: disposeBag)

    store.followerCount
      .flatMap(Observable.from(optional:))
      .map { count in String(count) }
      .bind(to: followerCount)
      .disposed(by: disposeBag)

    onTapLoginbutton
      .withLatestFrom(store.login).filter { $0 != true }
      .map { _ in }
      .bind(to: showLoginView)
      .disposed(by: disposeBag)

    onTapBackButton
      .bind(to: dismiss)
      .disposed(by: disposeBag)
  }
}
