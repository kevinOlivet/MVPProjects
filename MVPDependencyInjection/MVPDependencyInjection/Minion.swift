//
//  Minion.swift
//  UnitTestsDependencyInjection
//
//  Created by Jon Olivet on 11/15/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

struct Minion {
  let name: String
}

extension Minion: Equatable {}
func == (lhs: Minion, rhs: Minion) -> Bool {
  return lhs.name == rhs.name
}
