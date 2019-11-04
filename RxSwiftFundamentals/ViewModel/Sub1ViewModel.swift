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
  var dismiss: PublishRelay<Void> { get }
  var showLoginView: PublishRelay<Void> { get }
}

public final class Sub1ViewModel: Sub1ViewModelInput, Sub1ViewModelOutput {
  // input
  public let viewDidLoad = PublishRelay<Void>()
  public let onTapBackButton = PublishRelay<Void>()
  public let onTapLoginbutton = PublishRelay<Void>()

  // output
  public let isHiddenContents = BehaviorRelay<Bool>(value: false)
  public let isHiddenLoginButton = BehaviorRelay<Bool>(value: false)
  public let dismiss = PublishRelay<Void>()
  public let showLoginView = PublishRelay<Void>()

  private let disposeBag = DisposeBag()

  init(store: Store = Store.singleton) {
    store.login.filter { $0 == true }
      .subscribe({ [weak self] _ in
        self?.isHiddenContents.accept(true)
        self?.isHiddenLoginButton.accept(true)
      })
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
