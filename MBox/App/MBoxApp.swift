//
//  MBoxApp.swift
//  MBox
//
//  Created by yoonie on 4/17/26.
//

import SwiftUI

@main
struct MBoxApp: App {
	
	/// 앱 전체에 공유될 ViewModel 인스턴스를 싱글톤으로 생성하고 상태 객체로 관리
	@StateObject private var vm = MovieViewModel()
	
    var body: some Scene {
        WindowGroup {
            MBoxHomeView()
				.environmentObject(vm) // MovieViewModel을 뷰 계층 구조에 주입
        }
    }
}
