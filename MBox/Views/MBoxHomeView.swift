//
//  MBoxHomeView.swift
//  MBox
//
//  Created by YoonieMac on 4/18/26.
//

import SwiftUI


/// 앱의 홈화면을 구성하는 View
/// 영화 데이터를 카테고리별로 표시하고, My List 화면으로의 네비게이션 기능 포함
struct MBoxHomeView: View {
	
	// MARK: - Properties
	@EnvironmentObject private var vm: MovieViewModel  // ViewModel객체
	
	// MARK: - Body
    var body: some View {
		NavigationStack {
			ZStack {
				//backgroundColor
				Color.ccBlack.ignoresSafeArea()
				
				// MARK: - Content
				VStack(spacing: 0) {
					header // 헤더 영역
					ScrollView(.vertical, showsIndicators: false) {
						VStack(spacing: 10) {
							// 렌덤으로 선택된 HeroCell
							if let randomMovie = vm.randomNowPlayingMovie {
								heroCell(movie: randomMovie)
									.padding(.bottom, 20)
							}
							
						} //:VSTACK
						.padding(.top, 10)
					} //:SCROLL
				} //:VSTACK
				
			} //:ZSTACK
			.foregroundStyle(.ccWhite)
		}//: NavigationStack
    }//:body
	
	
	
	// MARK: - Extension
	/// 헤더 영역
	private var header: some View {
		// Header 영역
		HStack(spacing: 20) {
			//로고
			HStack(spacing: 8) {
				Text("M")
					.foregroundStyle(.ccDarkRed) // M 부분 빨간색
					.font(.largeTitle)
				Text("BOX")
					.font(.title)
					.fontWeight(.bold)
					.kerning(3)
			} //:HSTACK
			.hLeading() // 왼쪽 정렬
			
			// My List로 이동 버튼
			Button {
				// TODO: My List View로 전환
				
			} label: {
				Image(systemName: "pencil.and.list.clipboard")
			}
			.font(.title2)
			
		} //:HSTACK
		.padding(.horizontal, 20)
	}
	
	/// 렌덤으로 선택된 HeroCell
	private func heroCell(movie: Movie) -> some View {
		MBoxHeroCell(
			imageName: movie.posterURL?.absoluteString ?? "", // 영화 포스터 URL
			title: movie.title, // 영화 제목
			onBackgroundPressed: { // 배경 클릭 시 상세보기로 이동
				
			},
			onDetailPressed: { // 버튼 클릭 시 상세보기로 이동
				
			}
		)
	}
	
}

#Preview {
    MBoxHomeView()
		.environmentObject(MovieViewModel())
}
