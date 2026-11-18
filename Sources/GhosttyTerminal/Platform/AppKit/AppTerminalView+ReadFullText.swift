#if !canImport(UIKit) && canImport(AppKit)
    import AppKit
    import GhosttyKit

    public extension AppTerminalView {
        /// Read the scrollback and active screen without changing selection
        /// or touching the pasteboard. Nil before the surface attaches.
        func readFullText() -> String? {
            guard let pointer = surface?.rawValue else { return nil }
            let selection = ghostty_selection_s(
                top_left: ghostty_point_s(
                    tag: GHOSTTY_POINT_SCREEN, coord: GHOSTTY_POINT_COORD_TOP_LEFT, x: 0, y: 0,
                ),
                bottom_right: ghostty_point_s(
                    tag: GHOSTTY_POINT_SCREEN, coord: GHOSTTY_POINT_COORD_BOTTOM_RIGHT, x: 0, y: 0,
                ),
                rectangle: false,
            )
            var result = ghostty_text_s()
            guard ghostty_surface_read_text(pointer, selection, &result) else { return nil }
            defer { ghostty_surface_free_text(pointer, &result) }
            guard let text = result.text else { return "" }
            let bytes = UnsafeRawBufferPointer(start: text, count: Int(result.text_len))
            return String(decoding: bytes, as: UTF8.self)
        }
    }
#endif
