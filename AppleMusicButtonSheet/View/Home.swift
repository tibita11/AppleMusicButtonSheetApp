//
//  Home.swift
//  AppleMusicButtonSheet
//
//  Created by 鈴木楓香 on 2024/06/06.
//

import SwiftUI

struct Home: View {
    // Animation Properties
    @State private var expandSheet: Bool = false
    @Namespace private var animation
    
    var body: some View {
        TabView {
            ListenNow()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("ホーム")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
                .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
            SampleTabView("見つける", "square.grid.2x2.fill")
            SampleTabView("ラジオ", "dot.radiowaves.left.and.right")
            SampleTabView("ライブラリ", "square.stack.fill")
            SampleTabView("検索", "magnifyingglass")
        }
        .tint(.red)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CunstomBottomSheet()
        }
        .overlay {
            if expandSheet {
                ExpandedBottomSheet(expandSheet: $expandSheet,
                                    animation: animation)
                // Transition for more fluent Animation
                .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
    }
    
    // Custom Listen Now View
    @ViewBuilder
    private func ListenNow() -> some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Image(.top100)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .circular))
                    
                    Image(.replay20)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .circular))
                }
                .padding()
                .padding(.bottom, 100)
            }
            .navigationTitle("ホーム")
        }
    }
    
    @ViewBuilder
    private func CunstomBottomSheet() -> some View {
        ZStack {
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        MusicInfo(expandSheet: $expandSheet,
                                  animation: animation)
                    }
                    .matchedGeometryEffect(id: "BIGVIEW", in: animation)
            }
        }
        .frame(height: 70)
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
                .offset(y: -5)
        })
        // 49: Default Tab Bar Height
        .offset(y: -49)
    }
    
    @ViewBuilder
    private func SampleTabView(_ title: String, _ icon: String) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text(title)
                .padding(.top, 25)
        }
        .tabItem {
            Image(systemName: icon)
            Text(title)
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThickMaterial, for: .tabBar)
        .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
    }
}

// MARK: - MusicInfo

struct MusicInfo: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            // Adding Matched Geometry Effect
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        let size = $0.size
                        
                        Image(.lilac)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "LILAC", in: animation)
                }
            }
            .frame(width: 45, height: 45)

            Text("ライラック")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 15)
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
            }
            
            Button {
                
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .padding(.leading, 25)
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            // Expanding Botton Sheet
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
