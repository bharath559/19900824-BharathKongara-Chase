//
//  ServiceError.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation

enum ServiceError: Error {
   case decode
   case response
}

extension ServiceError: LocalizedError {
   var errorDescription: String? {
      switch self {
         case .decode:
            return NSLocalizedString("Decode Failed", comment: "")
         case .response:
            return NSLocalizedString("API Error", comment: "")
      }
   }
}
