//
//  LoginAction.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/04.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class LoginAction {
  public static func tryLogin(store: Store = Store.singleton, username: String, password: String) -> Single<Bool> {
    return Single.create { event in

      // In production, send actual request to some API on your service.
      if username == "username" && password == "password" {
        store.login.accept(true)
        event(.success(true))
      } else if username == "hoge" && password == "fuga" {
        store.login.accept(true)
        event(.success(true))
      } else {
        event(.success(false))
      }
      return Disposables.create{}
    }
  }
}

public final class FetchError: Error {

}
