//
//  TypeAlias.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import Foundation

#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

#if os(OSX)
  public typealias CurrentController = NSViewController
#else
  public typealias CurrentController = UIViewController
#endif
