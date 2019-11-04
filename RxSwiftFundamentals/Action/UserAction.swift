//
//  UserAction.swift
//  RxSwiftFundamentals
//
//  Created by osamtimizer on 2019/11/04.
//  Copyright © 2019 osamtimizer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class UserAction {
  public static func fetchUserInfo(store: Store = Store.singleton, username: String) -> Completable {
    return Completable.create { event in

      if username == "" {
        event(.error(UserActionError()))
      } else {
        store.email.accept("username@example.com")
        store.username.accept(username)
        store.followeeCount.accept(100)
        store.followerCount.accept(200)
        event(.completed)
      }

      return Disposables.create{}
    }
  }
}

public final class UserActionError: Error {

}
