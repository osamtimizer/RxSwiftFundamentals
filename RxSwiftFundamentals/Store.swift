//
//  Store.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/03.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class Store {

  public static let singleton = Store()
  public let login = BehaviorRelay<Bool>(value: false)

  init() {
  }
}
