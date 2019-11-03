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
}

public protocol MainViewModelOutput {
  var showSub1View: PublishRelay<Void> { get }
}

public final class MainViewModel: MainViewModelInput, MainViewModelOutput {
  // input
  public let viewDidLoad = PublishRelay<Void>()
  public let onTapTransitionButton = PublishRelay<Void>()

  // output
  public let showSub1View = PublishRelay<Void>()

  private let disposeBag = DisposeBag()

  init() {
    onTapTransitionButton
      .bind(to: showSub1View)
      .disposed(by: disposeBag)
  }
}
