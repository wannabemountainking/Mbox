//
//  MovieDetailView.swift
//  MBox
//
//  Created by YoonieMac on 4/19/26.
//

import SwiftUI


/// 영화 상세 정보를 표시하는 View
/// 사용자가 영화의 상세정보, 줄거리, My list 추가 / 제거 기능을 확인하고 사용 가능함
struct MovieDetailView: View {
	// MARK: - Properties
	let movie: Movie // 선택된 영화 데이터
	@Environment(\.dismiss) private var dismiss // sheet 닫기 동작을 위한 환경 변수
	@EnvironmentObject private var vm: MovieViewModel // ViewModel 연결
	@State private var isInMyList: Bool = false // My List 포함 여부
	@State private var showPopup: Bool = false // 팝업 표시 여부
	@State private var popupMessage: String = "" // 팝업 메시지
	
    var body: some View {
		ZStack {
			// background color
			Color.ccBlack.ignoresSafeArea()
			
			// content
			ScrollView {
				VStack(spacing: 20) {
					posterView // 영화 포스터
					movieInfo // 영화 정보 (제목, 줄거리 등)
					viewDetailButton // 영화 상세 페이지 링크 버튼
				} //:VSTACK
				
			} //:SCROLL
			.padding(.top, 20)
			
			// Close 버튼
			closeBtn
				.vTop()
				.hTrailing()
				.padding()
				.padding(.vertical, 30)
				.zIndex(1.0)
			// My List 추가 / 삭제 결과를 표시하는 팝업뷰
			if showPopup {
				popupView
					.transition(.opacity)
					.zIndex(1.0)
			}
			
		} //:ZSTACK
		.foregroundStyle(.ccWhite)
	}//:body
	
	
	
	// MARK: - Extension
	
	// 영화 포스터
	private var posterView: some View {
		ImageLoaderView(movie.posterURL?.absoluteString ?? "")
			.scaledToFill()
			.frame(height: 400)
	}
	
	// 영화 정보(타이틀, 장르, 줄거리, 평점 등)
	private var movieInfo: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Text(movie.title)
					.font(.largeTitle)
					.fontWeight(.bold)
					.hLeading()
				
				MyListButton(inMyList: isInMyList) {
					if isInMyList {
						// My List 에 이미 있는 값이면 삭제 로직 추가 예정
						isInMyList = false
						showPopupMessage("삭제되었습니다")
					} else {
						// My List 에 없는 값이면 새로 추가 로직 추가 예정
						isInMyList = true
						showPopupMessage("추가되었습니다")
					}
				}
			}//:HSTACK
			
			// 개봉일 및 평점
			HStack(spacing: 0) {
				Text("개봉일: \(movie.releaseDate)") // 개봉일
					.font(.footnote)
				Spacer()
				Text("⭐️ \(String(format: "%.1f", movie.voteAverage))") // 평점은 소수점 1자리로 잘라서 변환해서 나타냄
					.font(.footnote)
					.foregroundStyle(.yellow)
			}
			
			// 줄거리
			if !movie.overview.isEmpty {
				Text("줄거리")
					.font(.headline)
					.padding(.top, 10)
				Text(movie.overview)
					.font(.body)
					.foregroundStyle(.ccLightGray)
					.lineLimit(4)
			}
			
		} //:VSTACK
		.padding(.horizontal)
	}
	
	/// TMDB 영화 상세 페이지(웹)로 이동하는 버튼
	private var viewDetailButton: some View {
		Button(action: {
			if let url = URL(string: "https://www.themoviedb.org/movie/\(movie.id)") {
				UIApplication.shared.open(url)
			}
		}, label: {
			Text("자세히 보기")
				.font(.headline)
				.frame(maxWidth: .infinity)
				.padding(10)
		})
		.buttonStyle(.borderedProminent)
		.tint(Color.ccDarkRed)
		.padding(.horizontal)
	}
	
	// MARK: - Popup 관련 메서드
	/// 팝업 메시지 표시
	/// parameter - message :  표시할 메시지
	private func showPopupMessage(_ message: String) {
		popupMessage = message // 메시지 설정
		withAnimation {
			showPopup = true // 팝업 표시
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			showPopup = false // 팝업 숨기기
		}
	}
	
	// 팝업 뷰
	private var popupView: some View {
		Text(popupMessage)
			.font(.headline)
			.padding()
			.background(Color.ccWhite.opacity(0.9))
			.cornerRadius(10)
			.shadow(radius: 10)
			.frame(maxWidth: .infinity)
			.foregroundStyle(.ccBlack)
	}
	
	/// sheet 닫기 버튼
	private var closeBtn: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				Button {
					// Action
					dismiss()
				} label: {
					Image(systemName: "xmark.circle.fill")
						.font(.largeTitle)
						.foregroundStyle(.ccWhite)
				}
			} //:HSTACK
		} //:VSTACK
	}
}

#Preview {
	MovieDetailView(movie: Movie.mock)
		.environmentObject(MovieViewModel())
}
