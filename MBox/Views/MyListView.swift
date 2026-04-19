//
//  MyListView.swift
//  MBox
//
//  Created by YoonieMac on 4/19/26.
//

import SwiftUI


/// 사용자가 MyList에 저장한 영화 데이터를 표시하는 View
/// MyList에 저장된 영화가 없을 경우 메시지 표시하고 있을 경우 그리드 형태로 데이터를 보여줌
struct MyListView: View {
	// MARK: - Properties
	@EnvironmentObject private var vm: MovieViewModel // ViewModel연결
	@State private var selectedMovie: Movie? = nil // 선택된 영화
	
	// Grid Layout 설정: 3열로 구성된 유연한 그리드 레이아웃
	var columns: [GridItem] = [
		GridItem(.flexible(), spacing: 10), // 첫번째 열
		GridItem(.flexible(), spacing: 10), // 두번째 열
		GridItem(.flexible(), spacing: 10), // 세번째 열
	]
	
	
    var body: some View {
		ZStack {
			// background color
			Color.ccBlack
				.ignoresSafeArea()
			
			VStack(spacing: 20) {
				// 제목
				Text("My List")
					.foregroundStyle(.ccWhite)
					.font(.largeTitle)
					.hLeading()
					.padding(.horizontal, 10)
				// Content
				if vm.myMovies.isEmpty {
					// coredata가 없는 경우
					VStack(spacing: 0) {
						Text("My List에 저장된 Movie가 없습니다")
							.foregroundStyle(.ccWhite)
							.font(.title)
							.multilineTextAlignment(.center)
					} //:VSTACK
					.vCenter() // 화면 중앙 배치
				} else {
					// 데이터가 있는 경우
					ScrollView {
						LazyVGrid(columns: columns, spacing: 15) {
							ForEach(vm.myMovies) { movie in
								// 영화 셀 구성
								MBoxMovieCell(
									imageName: movie.posterURL?.absoluteString ?? "",
									title: movie.title ?? ""
								)
								.onTapGesture {
									// 선택된 MyMovie 데이터를 Movie 모델로 변환하여 상세 뷰로 전달
									self.selectedMovie = Movie(
										id: Int(movie.id),
										title: movie.title ?? "",
										overview: movie.overview ?? "",
										releaseDate: movie.releaseDate ?? "",
										voteAverage: movie.voteAverage,
										posterPath: movie.posterPath
									)
								}
							} //:LOOP
						}//: LazyVGrid
						.padding()
					} //:SCROLL
				}//:CONDITIONAL
				
			} //:VSTACK
		} //:ZSTACK
		.sheet(item: $selectedMovie) { movie in
			// 영화 상세 뷰 표시
			MovieDetailView(movie: movie)
		}
	}//:body
}

//#Preview {
//    MyListView()
//		.environmentObject(MovieViewModel())
//}
